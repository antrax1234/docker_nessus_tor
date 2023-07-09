#!/bin/bash
id=$(docker ps | grep -i nessus | awk '{print $1}')
clear
docker exec -ti -u root $id bash
