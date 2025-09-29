docker exec -i docker-postgres-postgres-1 psql -U nickd -d literacyfootprints_template --csv < ~/dev/netsuite-crm/account-change-orders/scripts/1-export-change-orders.sql
