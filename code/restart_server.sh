#! /usr/bin/env bash

docker restart $(docker ps -q)
