# Documentation Technique - Cloud Form Platform

## 1. Présentation du Projet
Cette plateforme permet la création et la collecte de formulaires de manière sécurisée et scalable. Elle repose sur **Formbricks**, une solution 'open-source' moderne.

## 2. Architecture Technique
Le projet utilise une architecture distribuée, isolée et monitorée :
- **Proxy/WAF**: Nginx avec ModSecurity (OWASP CRS) pour la protection contre les cyberattaques.
- **Application**: Multi-instances de Formbricks (Next.js) pour la haute disponibilité.
- **Base de données**: PostgreSQL 15 (Isolé dans un réseau de données).
- **Cache**: Redis 6.
- **Observabilité**: Stack complète avec **Prometheus** (métriques), **Loki** (logs), et **Grafana** (visualisation).
- **Backups**: Worker automatisé effectuant des sauvegardes quotidiennes vers **Amazon S3**.

## 3. Déploiement Automatisé (CI/CD)
Le projet est configuré pour se déployer automatiquement sur un **VPS Contabo** via **GitHub Actions**.

### Configuration des Secrets GitHub
Pour que le déploiement fonctionne, configurez les secrets suivants dans votre dépôt GitHub :

| Secret Name | Description |
| :--- | :--- |
| `VPS_HOST` | Adresse IP du serveur Contabo |
| `VPS_SSH_KEY` | Clé privée SSH (doit correspondre à la clé publique dans `authorized_keys` du VPS) |
| `AWS_ACCESS_KEY_ID` | Identifiant d'accès S3 |
| `AWS_SECRET_ACCESS_KEY` | Clé secrète S3 |
| `S3_BUCKET_NAME` | Nom du bucket pour les backups |
| `POSTGRES_PASSWORD` | Mot de passe de la base de données |
| `NEXTAUTH_SECRET` | Secret pour l'authentification (générer une chaîne aléatoire) |
| `ENCRYPTION_KEY` | Clé de chiffrement (32 caractères) |
| `GRAFANA_ADMIN_PASSWORD`| Mot de passe administrateur pour Grafana |

### Lancer un Déploiement
Tout "push" sur la branche `main` déclenche automatiquement le cycle de déploiement :
1. Build de l'image Docker.
2. Push vers le registre.
3. Mise à jour des fichiers sur le VPS via SSH/SCP.
4. Redémarrage des containers.

## 4. Accès aux Services
Une fois déployé, les services sont accessibles aux adresses suivantes :
- **Application principale** : `https://[IP_DU_VPS]:8444` (Port 8081 pour HTTP)
- **Dashboard Monitoring (Grafana)** : `http://[IP_DU_VPS]:3001` (Login: `admin`)

## 5. Sécurité & Fiabilité
- **WAF**: Protection contre SQLi, XSS via ModSecurity (OWASP CRS).
- **SSL**: Certificats Let's Encrypt gérés par Certbot avec renouvellement automatique.
- **Isolation réseau**: 4 réseaux Docker distincts (`edge-net`, `app-net`, `data-net`, `monitoring-net`).
- **Sauvegardes**: Planifiées chaque jour à 3h00 du matin via le script `backups/backup_s3.sh`.

## 6. Guide d'Utilisation
1. Accéder à l'interface via votre domaine ou IP.
2. Créer un compte administrateur lors de la première connexion.
3. Configurer vos formulaires et collecter les données.
4. Surveiller l'état de santé du serveur sur Grafana (Port 3001).
