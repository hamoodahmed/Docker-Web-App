#!/usr/bin/env python3
# Python script for pulling raw data from cAdvisor and storing in MongoDB
# usage: python task-05-pipeline.py <database_number>
# Returns: prints the collection names within the database

import docker
import requests
import json
import sys
from pymongo import MongoClient

try:
    # Docker client
    client = docker.from_env()

    # MongoDB client (default port 27017)
    mclient = MongoClient('mongodb://localhost:27017')

    # Database name
    if len(sys.argv) < 2:
        print("Usage: python task-05-pipeline.py <database_number>")
        sys.exit(1)

    number = sys.argv[1]
    db_name = 'loadgen' + number
    db = mclient[db_name]

    # Iterate over containers
    for item in client.containers.list():
        cont_id = item.id
        cont_name = item.name
        print(f"Processing container: {cont_name}")

        # cAdvisor URL
        url = f'http://localhost:8090/api/v1.2/docker/{cont_id}'

        try:
            res = requests.get(url, timeout=5)
            res.raise_for_status()
            data = res.json()
        except Exception as e:
            print(f"Error fetching data for container {cont_name}: {e}")
            continue

        # MongoDB collection for this container
        collection = db[cont_name]
        collection.delete_many({})

        # Unique container search parameter
        search_key = f'/docker/{cont_id}'

        # Store each stats record in MongoDB
        stats_list = data.get(search_key, {}).get('stats', [])
        for record in stats_list:
            collection.insert_one(record)

    # Show all collections in database
    print(f"\nCollections in database '{db_name}':")
    print(db.list_collection_names())

except Exception as e:
    print("Error:", e)