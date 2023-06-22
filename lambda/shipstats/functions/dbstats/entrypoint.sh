#!/bin/bash
# based on process in https://docs.aws.amazon.com/lambda/latest/dg/python-package.html

cd /opt
python3 -m venv myvenv
source myvenv/bin/activate
pip install -r requirements.txt
deactivate
cd myvenv/lib/python3.9/site-packages
zip -r ../../../../lambda.zip .
cd ../../../../
zip -g lambda.zip ./*.py
rm -rf myvenv
