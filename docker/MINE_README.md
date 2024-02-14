
# How to run localy 

docker-compose -f docker-compose-mine.yaml up

for site:
http://localhost:7030
user - mine
pass - mine

for api with api key
http://localhost:7030/api-with-key
Header: x-api-key = mine

# How to build / push for GKE use
run from this folder

docker build -f docker/server/Dockerfile -t conductor:server ../ 

docker tag conductor:server europe-docker.pkg.dev/mine-staticresources/conductor/conductor-server:{TAG}

docker push europe-docker.pkg.dev/mine-staticresources/conductor/conductor-server:{TAG}