#!/bin/bash

image=$(docker build . -q)
docker run -v `pwd`:/opt ${image}
