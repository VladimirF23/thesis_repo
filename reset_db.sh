#!/bin/bash

DB_NAME="isolation_benchmark"
DB_USER="benchmark"

echo "Brisanje i ponovno kreiranje baze: $DB_NAME"
sudo -u postgres dropdb --if-exists $DB_NAME
sudo -u postgres createdb -O $DB_USER $DB_NAME

echo "Kreiranje tabele i insertovanje 100.000 redova..."
sudo -u postgres psql -d $DB_NAME -c "
CREATE TABLE accounts (
    id BIGINT PRIMARY KEY,
    balance BIGINT NOT NULL
);

ALTER TABLE accounts OWNER TO $DB_USER;

INSERT INTO accounts (id, balance)
SELECT i, 100000 FROM generate_series(1, 100000) AS i;
"

echo "Ažuriranje sistemske statistike..."
sudo -u postgres psql -d $DB_NAME -c "VACUUM ANALYZE accounts;"

echo "Baza je potpuno čista i spremna za test!"