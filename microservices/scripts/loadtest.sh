#!/bin/bash

# Configuration
URL="https://sock-shop-dev.zennon.link/catalogue"
NUM_REQUESTS=100  # Nombre total de requêtes à effectuer
CONCURRENT_REQUESTS=10  # Nombre de requêtes simultanées

# Fonction pour effectuer les requêtes
function load_test() {
    for i in $(seq 1 $NUM_REQUESTS); do
        # Effectuer la requête GET
        response=$(curl -s -o /dev/null -w "%{http_code}" $URL)

        # Afficher le code de réponse
        if [ "$response" -eq 200 ]; then
            echo "Requête réussie : $response"
        else
            echo "Erreur lors de la requête : $response"
        fi

        # Limiter le nombre de requêtes simultanées
        if (( i % CONCURRENT_REQUESTS == 0 )); then
            echo "Attente de 1 seconde avant de continuer..."
            sleep 1
        fi
    done
}

# Démarrer le test de charge
echo "Démarrage du test de charge sur $URL avec $NUM_REQUESTS requêtes..."
load_test
echo "Test terminé."
