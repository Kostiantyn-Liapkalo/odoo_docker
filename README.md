##Pull odoo:
cd src
git clone --branch 17.0 https://github.com/odoo/odoo.git --depth 1 --single-branch
##Run container:
docker compose -f ./docker-compose.yml -f ./docker/docker-compose.debug.yml up
##Test:
docker compose up -d
docker compose exec -it db psql -U user -d postgres -c "DROP DATABASE IF EXISTS db_test"
docker compose exec -it db psql -U user -d postgres -c "CREATE DATABASE db_test"

docker compose exec -it web odoo -i library_app --db_host db --db_user user --db_password password -d db_test --stop-after-init

docker compose -f docker-compose.yml -f docker/docker-compose.test.yml build --no-cache
docker compose -f docker-compose.yml -f docker/docker-compose.test.yml up
##Install:
odoo --db_host db --db_port 5432 --db_user user --db_password password --stop-after-init -i library_app
odoo --db_host db --db_port 5432 --db_user user --db_password password --stop-after-init -u library_app --log-level=test --test-enabl# odoo_docker
