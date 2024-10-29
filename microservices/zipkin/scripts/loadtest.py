#!/usr/bin/python3

import logging
from locust import HttpUser, TaskSet, task, between

# Configurer le logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class UserBehavior(TaskSet):
    @task
    def load_catalogue(self):
        response = self.client.get("/catalogue")
        if response.status_code == 200:
            logger.info(f"Requête réussie : {response.status_code}")
        else:
            logger.error(f"Erreur lors de la requête : {response.status_code} - {response.text}")

class WebsiteUser(HttpUser):
    tasks = [UserBehavior]
    wait_time = between(1, 3)  # Attendre entre 1 et 3 secondes entre les requêtes

