#!/bin/env python

import json
import logging
import pymssql
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry


"""
Gets stats regarding various shipstation services from the DB and send them as custom events to NR, visible in Insights.

"Environment": "letter"  (the db letter) kv is always appended to the event_attribs before sending the event to NR.

Notes:

1. Events are batched together and sent to NR.
2. Event attributes are based on the column names returned from the query.
3. Queries that return multiple rows will treat each row as an event.

Current Limitations:

1. Column names cannot be blank.
2. No support for aggregate (group_by) queries that return colums as rows (yet)

https://docs.newrelic.com/docs/insights/insights-data-sources/custom-data/insert-custom-events-insights-api

Input format (just an example):
{
    "newrelic_credentials": {
        "api_key": "blah",
        "account_id": "blah"
    },
    "databases": {
        "B": {
            "db_hosts": [
                "s-b-sql01.sslocal.com",
                "s-b-sql02.sslocal.com"
            ]
            "db_credentials": {
                "username": "readonly",
                "password": "blahpasswd",
                "db_name": "DBName"
            },
        },
        "C": {
            "db_hosts": [
                "s-c-sql01.sslocal.com",
                "s-c-sql02.sslocal.com"
            ]
            "db_credentials": {
                "username": "readonly",
                "password": "blahpasswd",
                "db_name": "DBName"
            },
        }
    },
    "events": [
        {
            "event_type": "Test",
            "enabled": "false",
            "database_query": [
                "select top 2 * FROM dbo.AccountManager"
            ]
        },
        {
            "event_type": "SellerAlerts",
            "enabled": "true",
            "database_query": [
                "SELECT COUNT(1) AS AlertsQueued FROM seller(NOLOCK)",
                "WHERE AlertsRefreshDate < GETUTCDATE() AND (AlertsUpdated < AlertsRefreshDate OR AlertsUpdated IS NULL)",
                "AND AlertsRefreshDate IS NOT NULL"
            ]
        }
    ]
}

"""

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handle(event, context):
    """Main handler
    """

    result_set = []

    for db_env, db_info in event['databases'].items():
        logger.info("Gathering stats from: {0}".format(db_env))

        # Get db connection
        dbh = db(
            db_info['db_credentials']['username'],
            db_info['db_credentials']['password'],
            db_info['db_credentials']['db_name'],
            db_info['db_hosts'])

        # Loop through events, execute queries
        for e in event['events']:
            if e['enabled'] == "true":
                logger.info("Executing event {0}".format(e['event_type']))
                rows = query(dbh, ' '.join(e['database_query']))
                for row in rows:
                    # Add some custom k/v data into the event
                    # eventType is required by NR
                    row.update({'eventType': e['event_type']})
                    row.update({'Environment': db_env})

                    result_set.append(row)

        # Close connection to db
        dbh.close()

    logger.debug(json.dumps(result_set))
    nr_acct_id = event['newrelic_credentials']['account_id']
    nr_api_key = event['newrelic_credentials']['api_key']

    # Send event(s) to NR
    send_event(result_set, nr_acct_id, nr_api_key)


def send_event(result_set, nr_acct_id, nr_api_key):
    """Send event to NewRelic Insights"""

    nr_url = "https://insights-collector.newrelic.com/v1/accounts/{0}/events".format(
        nr_acct_id)
    headers = {'Content-Type': 'application/json', 'X-Insert-Key': nr_api_key}

    s = requests.Session()
    s.headers.update(headers)

    r = _requests_retry_session(
        session=s).post(
        nr_url,
        headers=headers,
        json=result_set)

    r.raise_for_status()

    logger.info("Data sent successfully to NR. Status code: {0}".format(r.status_code))


def db(username, password, db_name, hostnames=[]):
    """Connect to the db, try/except for not knowing who is primary vs. failover"""
    try:
        logger.info(
            "Connecting to {0} database on {1} {2} {3}".format(
                db_name, hostnames[0], username, password))
        dbh = pymssql.connect(
            hostnames[0],
            username,
            password,
            db_name,
            timeout=10)
    except pymssql.OperationalError as e:
        logger.error(str(e))
        logger.info(
            "Connecting to {0} database on {1} {2} {3}".format(
                db_name, hostnames[1], username, password))
        dbh = pymssql.connect(
            hostnames[1],
            username,
            password,
            db_name,
            timeout=10)
    except Exception:
        raise

    return dbh


def query(dbh, query):
    """
    Query the db and return results as a dict with columns as key name and
    row as the value.
    """

    def _return_dict_pair(row_item):
        return_dict = {}
        for column_name, row in zip(cursor.description, row_item):
            return_dict[column_name[0]] = row
        return return_dict

    return_list = []

    with dbh.cursor() as cursor:

        try:
            cursor.execute(query)
        except pymssql.ProgrammingError as p:
            logger.error(
                "Execution of SQL statement encountered an error: {0} {1}".format(
                    query, p))
        except pymssql.OperationalError:
            raise
        else:
            for row in cursor:
                row_item = _return_dict_pair(row)
                return_list.append(row_item)

    return return_list


def _requests_retry_session(
        retries=3,
        backoff_factor=0.5,
        status_forcelist=(500, 502, 504),
        session=None):
    """Handle retries on 500 series errors"""
    session = session or requests.Session()

    retry = Retry(
        total=retries,
        read=retries,
        connect=retries,
        backoff_factor=backoff_factor,
        status_forcelist=status_forcelist)

    adapter = HTTPAdapter(max_retries=retry)
    session.mount('https://', adapter)

    return session
