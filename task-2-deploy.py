# task-2-deploy.py (Windows-friendly, fixed)
import docker
import os

# Connect to Docker daemon
client = docker.from_env()

# Check if swarm is active
info = client.info()
if not info.get("Swarm") or info["Swarm"]["LocalNodeState"] == "inactive":
    print("Initializing new swarm...")
    client.swarm.init()
else:
    print("Swarm already active, skipping init.")

# Deploy stack using docker-compose.yml in current folder
print("Deploying stack 'cloudproject' ...")
os.system("docker stack deploy -c docker-compose.yml cloudproject")

# List services
print("\nServices:")
os.system("docker service ls")

# List containers
print("\nContainers:")
os.system("docker container ls -a")
