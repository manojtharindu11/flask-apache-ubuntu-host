CICD when i crewate and push code to github and then github action will run and push code to gitlab
domain: manoj-services.duckdns.org
ssh: ssh -i "flask-cloud.pem" ubuntu@13.245.118.72

<VirtualHost *:80>
    ServerName manoj-services.duckdns.org
    
    ErrorLog ${APACHE_LOG_DIR}/flaskapp_error.log
    CustomLog ${APACHE_LOG_DIR}/flaskapp_access.log combined

    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:8000/
    ProxyPassReverse / http://127.0.0.1:8000/
</VirtualHost>

start form this 
- sudo apt update
- 

ssh -i "D:\ES\AWS\flask-cloud.pem" ubuntu@13.60.255.157
sudo apt update
sudo apt install python3 python3-pip python3-venv -y

mkdir ~/flaskapp
cd ~/flaskapp
python3 -m venv venv


test gitlab ci
# stages:
#   - build
#   - test

# create_file:
#   image: alpine
#   stage: build
#   script:
#     - echo "Creating a file ..."
#     - mkdir build
#     - touch build/test.txt
#   artifacts:
#     paths:
#       - build/

# test_file:
#   image: alpine
#   stage: test
#   script:
#     - test -f build/test.txt
