# poetryDockerDeploy :exploding_head:
Deploy your Python application using Poetry and Docker

Do you use Poetry and need to deploy your application using Docker? This Dockerfile automates several steps and even creates a lightweight package, removing cache and leaving everything ready without headache. 

Place files inside your project and run "docker build -t projectName ."

The entrypoint file starts a gunicorn server for Flask application.
