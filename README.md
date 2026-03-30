# Docker Web Application Monitoring and Benchmarking Project

## Project Overview

This project demonstrates a complete, production-style DevOps workflow for deploying, monitoring, benchmarking, and visualizing a containerized web application using Docker Swarm. The objective of this implementation is not only to run a web service but to showcase how modern DevOps engineers manage distributed services, monitor container performance, collect operational metrics, and generate analytical insights from real-time system data.

The application used in this project is a Java-based Prime Number Check web service deployed as multiple replicas to simulate a scalable production environment. Alongside the application, a MongoDB database is used to store performance metrics, while cAdvisor provides detailed container-level monitoring. Finally, R scripting is used to generate visual graphs of CPU and memory usage from collected data.

This repository reflects a hands-on implementation of container orchestration, monitoring, automation, and data visualization—core competencies expected from DevOps engineers working in cloud-native environments.

---

## System Architecture

The project architecture consists of the following components working together:

- **Web Application Service** – A Java-based Prime Number Check API running in multiple replicas
- **Docker Swarm** – Orchestrates and manages containerized services
- **MongoDB Database** – Stores benchmark and monitoring data
- **cAdvisor Monitoring Tool** – Collects container resource usage metrics
- **Load Generator Scripts** – Simulates real-world user traffic
- **R Data Visualization** – Generates CPU and memory usage graphs
- **Automation Scripts** – Ensures repeatable and reliable deployment

This design mirrors real-world production systems where applications must be scalable, observable, and measurable.

---

## Key Features

- Containerized web application deployment
- Multi-service orchestration using Docker Swarm
- Automated service scaling with multiple replicas
- Real-time container monitoring using cAdvisor
- Load testing and benchmarking simulation
- MongoDB-based metrics storage
- Automated data visualization using R
- Fully script-driven deployment and verification
- Production-style DevOps workflow implementation

---

## Technologies Used

- Docker
- Docker Swarm
- MongoDB
- cAdvisor
- Python (Docker SDK)
- Bash / PowerShell
- R Programming
- GitHub
- Windows / Linux environment

---

## Prerequisites

Before running this project, ensure the following tools are installed and configured:

- Docker Desktop
- Python 3.x
- Git Bash (for running shell scripts on Windows)
- R and Rscript
- Internet connectivity for pulling container images

Optional but recommended:

- Visual Studio Code
- Docker CLI familiarity

---

## Project Workflow and Tasks

This project is organized into structured operational tasks that simulate a real DevOps deployment lifecycle.

---

## Task 1: Pull and Run Web Application

The first step is to deploy the Prime Number Check web application as a Docker container.

Command:

```bash
docker run -p 8080:8080 -d --name primecheck --rm nclcloudcomputing/javabenchmarkapp
```

Purpose:

This command pulls the container image from Docker Hub and starts the web application. The service becomes accessible through a local browser endpoint.

Verification:

Open the following URL in your browser:

```
http://localhost:8080/primecheck
```

This confirms the API is operational and ready to handle requests.

---

## Task 2: Deploy Multi-Service Application Using Docker Swarm

Docker Swarm is used to orchestrate multiple services and manage scalability.

Commands:

```bash
docker swarm init

docker stack deploy -c docker-compose.yml cloudproject

docker service ls

docker container ls -a
```

Purpose:

- Initializes a Swarm cluster
- Deploys services defined in the docker-compose configuration
- Launches multiple replicas of the web application
- Starts MongoDB and a service visualizer

Verification URLs:

```
http://localhost:80/primecheck
http://localhost:8880
```

This stage demonstrates service orchestration and container clustering.

---

## Task 3: Load Generator and Benchmark Testing

A load generator script simulates concurrent user requests to evaluate system performance under stress.

Command:

```bash
sh ./task-3-load-generator.sh http://localhost:8080/primecheck 4 2 4
```

Purpose:

- Generates multiple simultaneous API requests
- Measures response time performance
- Simulates real-world traffic patterns

This step is critical for validating application scalability and responsiveness.

---

## Task 4: Container Monitoring Using cAdvisor

cAdvisor is deployed to monitor container performance metrics such as CPU, memory, network activity, and resource usage.

Command:

```bash
docker run --publish=70:8080 --detach=true --rm --name cadvisor google/cadvisor:latest
```

Purpose:

This tool continuously collects performance data from all running containers, including:

- CPU usage
- Memory consumption
- Network traffic
- Container statistics
- Subcontainer metrics
- Top resource-consuming processes

Verification:

```
http://localhost:70
```

This dashboard provides a real-time operational view of the container ecosystem.

---

## Task 5: Store Benchmark Data in MongoDB

Benchmark results generated during load testing are stored in MongoDB for further analysis.

Command:

```bash
sh ./task-5-master.sh http://localhost:8080/primecheck 150 10 1 four
```

Purpose:

- Collect performance metrics
- Store monitoring data in database collections
- Enable long-term performance analysis

This stage demonstrates data persistence and operational logging.

---

## Task 6: Data Visualization Using R

R scripting is used to recreate performance graphs from MongoDB data.

Command:

```bash
Rscript R/graphs.R "<project_path>" memory
```

Purpose:

- Generate CPU usage graphs
- Generate memory usage graphs
- Export visual analytics as PNG images

Output Location:

```
graphics/
```

These visualizations support performance reporting and capacity planning.

---

## Automation and Reliability

All project components are designed to be repeatable and automated using scripts. This ensures consistent deployment behavior across environments and reduces manual configuration errors.

Automation benefits include:

- Faster environment setup
- Predictable deployment results
- Reduced operational risk
- Improved system reliability

---

## Monitoring Capabilities Demonstrated

The monitoring dashboard provides deep visibility into container runtime behavior, including:

- Docker container performance metrics
- Pod runtime and isolation statistics
- CPU usage breakdown
- Memory allocation and consumption
- Network usage monitoring
- System error tracking
- Subcontainer resource hierarchy
- Top CPU usage containers
- Top memory usage containers

These capabilities reflect enterprise-grade observability practices used in modern cloud infrastructure.

---

## Screenshots to Include in Repository

To help reviewers and hiring managers quickly understand the system, I have 
include the following screenshots in the images folder.

1. Web Application API Interface

Screenshot showing:

```
http://localhost:8080/primecheck
```

2. cAdvisor Monitoring Dashboard

Screenshot showing:

- Container list
- CPU usage graphs
- Memory usage graphs
- Network statistics
- Resource utilization metrics

3. File System Details

Screenshot showing:

- docker paths
- hosting services route
- file paths

These visuals provide immediate evidence of system functionality and monitoring capabilities.

---

## Why This Project Matters

This project demonstrates practical DevOps skills that are directly applicable in real-world production environments. It showcases the ability to deploy scalable services, monitor infrastructure performance, automate workflows, and generate actionable insights from operational data.

It reflects hands-on experience with container orchestration, system monitoring, load testing, and performance visualization—key responsibilities expected from modern DevOps engineers.

---

## Conclusion

This repository represents a complete end-to-end DevOps implementation covering deployment, monitoring, benchmarking, data storage, and visualization. The workflow emphasizes automation, reliability, and observability, which are essential pillars of modern cloud-native systems.

The project demonstrates not only technical capability but also structured problem-solving, operational awareness, and production readiness—qualities valued by engineering teams and hiring managers in DevOps and cloud infrastructure roles.

