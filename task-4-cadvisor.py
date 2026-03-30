# Python script for pulling and running cAdvisor container
# usage: python task-4-cadvisor.py

# loading modules
import docker

try:
    # creating connection to docker daemon
    client = docker.from_env()

    # running container in detached mode
    container = client.containers.run(
    'google/cadvisor',
    detach=True,
    ports={'8080/tcp': 70},  # map to host 70
    name='cadvisor',
    remove=True,
    volumes={
        '/': {'bind': '/rootfs', 'mode': 'ro'},
        '/var/run': {'bind': '/var/run', 'mode': 'rw'},
        '/sys': {'bind': '/sys', 'mode': 'ro'},
        '/var/lib/docker/': {'bind': '/var/lib/docker', 'mode': 'ro'}
    }
)

   # optional performance flags

    # print container id to terminal
    print("cAdvisor container started successfully")
    print("Container ID:", container.id)
    print("Open in browser: http://localhost:8090")

except Exception as e:
    print("Error starting cAdvisor:", e)
