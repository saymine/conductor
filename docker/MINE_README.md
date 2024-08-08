
# How to run localy 

docker-compose -f docker-compose-mine.yaml up
docker-compose -f docker-compose-mine.yaml up --build

for site:
http://localhost:7030
user - mine
pass - mine

swagger: http://localhost:7030/swagger-ui/index.html#/

for api with api key
http://localhost:7030/api-with-key
Header: x-api-key = mine

# How to build / push for GKE use
run from this main folder

we use gcloud builds:

TAG: shoud be: v{CONDUCTOR-VERSION}.{MINE-PATCH}

this will build and push to: europe-docker.pkg.dev/mine-artifacts-registry/conductor/conductor-server:{TAG}

gcloud builds submit --config mine-ci.yaml --project mine-devops-infra --substitutions _TAG={TAG}

# How to upgrade from remote

git fetch upstream

git checkout main

git rebase upstream/main

git push origin HEAD

# how to move to new tag

git checkout {TAG}

git checkout -b mine-{TAG}

git git merge origin/mine-{PREV-TAG}
