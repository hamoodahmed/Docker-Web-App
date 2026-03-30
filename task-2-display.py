# Python script for showing running services and containers
# usage: python task-2-display.py

# loading modules
import docker

try:
    # setting up client
    client = docker.from_env()

    # show services
    print("=== Running Services ===")
    services = client.services.list()

    if services:
        for service in services:
            print(f"Service Name: {service.name}")
            print(f"Service ID: {service.id}")
            print("-------------------------")
    else:
        print("No services running.")

    # show containers
    print("\n=== Running Containers ===")
    containers = client.containers.list(all=True)

    if containers:
        for container in containers:
            print(f"Container Name: {container.name}")
            print(f"Container ID: {container.id}")
            print(f"Status: {container.status}")
            print("-------------------------")
    else:
        print("No containers found.")

except Exception as e:
    print("Error:", e)
    
