# Docker Bamboo Agent DIND
This Docker Bamboo Agent allows you to run Docker images in agent docker container.

To learn more about Bamboo, see: https://www.atlassian.com/software/bamboo

# Overview

This Docker image makes it easy to get an instance of Bamboo Agent up and running.
This minimal image is suitable for run docker containers and contains only Bamboo Agent,
OpenJDK 8 and Docker.

Note that Bamboo Agent DIND Image does not include a Bamboo server.

# Quick Start

1. Make sure your Bamboo server is running and has remote agents support enabled. To enable it, go to **Administration > Agents console**.
2. Start the Bamboo Agent DIND container:

		docker run --name="bambooAgent" --privileged --net=host -e "BAMBOO_CI_URL=<<bamboo-server-url>>" -d citilink/bamboo-agent-dind

	where <<bamboo-server-url>> is the base URL of your Bamboo server.
	
3. Verify if your remote agent has registered itself. Go back to the **Administration > Agents console**.

### Security token

If you have security token verification enabled on your server, you can pass the token to the agent via the `SECURITY_TOKEN` environment variable in the docker run command.

### JVM Configuration

If you need to override Bamboo agent's default memory configuration or pass additional JVM arguments, use the `VM_OPTS` environment variable (see Dockerfile).

# Upgrade

Remote agents are updated automatically, so you don't need to worry about it during Bamboo server upgrade. Agents automatically detect when a new version is available and downloads new classes from the server.

# Issue tracker

* You can view know issues: [here](https://github.com/citilinkru/docker-bamboo-agent-dind/issues).