
# Étape 1 : On part d'une image officielle Nginx, version "alpine" (très légère et sécurisée)
FROM nginx:alpine

# Étape 2 : On copie notre fichier index.html dans le dossier par défaut de Nginx
COPY index.html /usr/share/nginx/html/

# Étape 3 : On indique que le conteneur va écouter sur le port 80
EXPOSE 80