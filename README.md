# 📘 Full CI/CD Deployment Guide: GitHub → GitLab → EC2 (Ubuntu) with Apache + Gunicorn + HTTPS

This technical document outlines the complete process of deploying a Flask application using GitHub for source control, GitLab for CI/CD, and an Ubuntu EC2 instance for hosting. The goal is to automatically push updates from GitHub to GitLab, then deploy the latest code from GitLab to your cloud server with Apache and Gunicorn running behind HTTPS.

---

## 🔗 Repositories

* **GitHub Repository:** [github.com/manojtharindu11/flask-apache-ubuntu-host](https://github.com/manojtharindu11/flask-apache-ubuntu-host)
* **GitLab Repository:** [gitlab.com/manojtharindu11/flask-apache-ubuntu-host](https://gitlab.com/manojtharindu11/flask-apache-ubuntu-host)

---

## 🛠️ Server Setup (Ubuntu EC2)

### 1. SSH into your EC2 instance

```bash
ssh -i "flask-cloud.pem" ubuntu@<ip-address>
```

### 2. Update system packages

```bash
sudo apt update && sudo apt upgrade -y
```

### 3. Install necessary packages

```bash
sudo apt install python3 python3-pip python3-venv git apache2 -y
```

### 4. Setup the project directory and virtual environment

```bash
sudo mkdir -p /var/www/flask-apache-ubuntu-host
cd /var/www/flask-apache-ubuntu-host
python3 -m venv .venv
```

---

## 🔐 Setup SSH Access to GitLab from EC2

1. **Generate SSH key** on your EC2 instance:

   ```bash
   ssh-keygen -t rsa -b 4096 -C "gitlab-ec2"
   cat ~/.ssh/id_rsa.pub
   ```

2. **Add the public key** to GitLab:

   * Navigate to GitLab → User Settings → SSH Keys → Add New Key

3. **Test SSH connection**:

   ```bash
   ssh -T git@gitlab.com
   ```

   You should see: `Welcome to GitLab, @manojtharindu11!`

4. **Clone the repository using SSH**:

   ```bash
   git clone git@gitlab.com:manojtharindu11/flask-apache-ubuntu-host.git
   ```

---

## 💻 Local GitHub → GitLab Mirror Workflow

1. GitHub is used as your primary development repo.
2. On every commit/push, a GitHub Action pushes the updated code to the GitLab mirror repository.
3. GitLab detects the change and triggers a pipeline.
4. GitLab pipeline connects to EC2 and deploys the code.

> This setup streamlines the deployment process by automatically pushing code from GitHub to GitLab, and then deploying the latest changes from GitLab to the EC2 instance over SSH.

---

## 🐋 Apache + Gunicorn Setup

### Apache Virtual Host Configuration

Create `/etc/apache2/sites-available/flask-apache-ubuntu-host.conf`:

```apacheconf
<VirtualHost *:80>
    ServerName manoj-services.duckdns.org

    ErrorLog ${APACHE_LOG_DIR}/flaskapp_error.log
    CustomLog ${APACHE_LOG_DIR}/flaskapp_access.log combined

    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:8000/
    ProxyPassReverse / http://127.0.0.1:8000/
</VirtualHost>
```

### Enable Apache modules and site:

```bash
sudo a2enmod proxy proxy_http
sudo a2ensite flask-apache-ubuntu-host.conf
sudo systemctl restart apache2
```

---

## 🔒 Enable HTTPS with Let's Encrypt (Certbot)

### 1. Install Certbot

```bash
sudo apt install certbot python3-certbot-apache -y
```

### 2. Run Certbot to automatically configure HTTPS and redirect

```bash
sudo certbot --apache -d manoj-services.duckdns.org
```

Choose option to redirect all HTTP traffic to HTTPS.

---

## ⚙️ GitLab CI/CD Pipeline (Deploy to EC2)

### CI/CD Flow:

* GitHub Action pushes code to GitLab.
* GitLab CI/CD runs `.gitlab-ci.yml`, which:

  * SSHs into EC2
  * Pulls the latest code
  * Installs dependencies
  * Starts Gunicorn via `run.sh`

### Required GitLab CI/CD Variables (Set these in GitLab → Project → Settings → CI/CD → Variables):

* `SSH_PRIVATE_KEY`: Your EC2 private key content (plain text)
* `HOST`: EC2 public IP or domain (e.g., `13.245.118.72`)
* `USER`: SSH user, typically `ubuntu`

---

## 🚀 `run.sh` Script Overview

This file is part of the project. It:

* Activates the Python virtual environment
* Installs Python dependencies from `requirements.txt`
* Starts Gunicorn with specified logging settings

Make sure it’s executable:

```bash
chmod +x run.sh
```

GitLab runner will execute this script on the EC2 instance during deployment.

---

## ✅ Useful Commands and Debugging Tips

* **Apache Logs**:

  ```bash
  sudo tail -f /var/log/apache2/*.log
  ```

* **Gunicorn Logs**:

  ```bash
  sudo journalctl -u gunicorn
  ```

* **Apache Service Status**:

  ```bash
  systemctl status apache2
  ```

* **Create Gunicorn Log Directory** (if needed):

  ```bash
  sudo mkdir -p /var/log/gunicorn
  sudo chown ubuntu:ubuntu /var/log/gunicorn
  ```

---

## 🧪 Test Deployment

After pushing changes to GitHub:

1. Check GitHub Actions tab to ensure push to GitLab succeeded.
2. Visit GitLab → CI/CD → Pipelines to confirm the pipeline ran.
3. Visit `https://manoj-services.duckdns.org` to see your Flask app.

---

## 🔧 Conclusion

This document is a complete educational guide for deploying Flask using a modern DevOps workflow. It includes GitHub → GitLab mirroring, EC2 deployment, and secure HTTPS configuration with Apache and Gunicorn. You can reuse and extend this workflow for future projects confidently.
