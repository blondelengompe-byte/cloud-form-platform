# Image personnalisée pour la plateforme de formulaires
FROM ghcr.io/formbricks/formbricks:latest

# Exemple d'ajout de configuration personnalisée
# COPY custom-config.json /app/config/

# On s'assure que l'utilisateur non-root est utilisé (déjà le cas dans l'image officielle)
USER nextjs

EXPOSE 3000

CMD ["node", "apps/web/server.js"]
