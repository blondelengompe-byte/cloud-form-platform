# Documentation Technique - Cloud Form Platform

## 1. Présentation du Projet
Cette plateforme permet la création et la collecte de formulaires de manière sécurisée et scalable. Elle repose sur **Formbricks**, une solution 'open-source' moderne.

## 2. Architecture Technique
Le projet utilise une architecture distribuée et isolée :
- **Proxy/WAF**: Nginx avec ModSecurity (OWASP CRS).
- **Application**: Multi-instances de Formbricks (Next.js).
- **Base de données**: PostgreSQL 15 (Isolé).
- **Cache**: Redis 7.
- **Backups**: Worker automatisé vers Amazon S3.


## 2. Déploiement
### Prérequis
- Docker & Docker Compose
- Un bucket S3 pour les sauvegardes

### Installation Locale
1. Configurer le fichier `.env`.
2. Lancer les services :
   ```bash
   docker compose up -d
   ```

## 3. Sécurité & Fiabilité
- **WAF**: Protection contre SQLi, XSS via ModSecurity.
- **SSL**: Certificats Let's Encrypt gérés par Certbot.
- **Isolation**: 3 réseaux Docker distincts (edge, app, data).
- **High Availability**: 2 réplicas pour la partie applicative.
- **Backup**: Sauvegarde quotidienne planifiée à 3h du matin.

## 4. Guide de démonstration
1. Accéder à `https://forms.local.nip.io`.
2. Créer un compte administrateur.
3. Créer un nouveau formulaire de test.
4. Soumettre une réponse et vérifier sa présence dans l'onglet 'Responses'.
5. Simuler une attaque SQLi sur le proxy pour vérifier le blocage WAF.

