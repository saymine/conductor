
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
run from this main folder

we use gcloud builds:
this will build and push to: europe-docker.pkg.dev/mine-staticresources/conductor/conductor-server:{TAG}

gcloud builds submit --config mine-ci.yaml --project mine-staticresources --substitutions _TAG={TAG}