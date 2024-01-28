# =====================================================================
# CarSaaz The Showroom Management System - Makefile
# =====================================================================
# Convenience targets for local development. Override connection
# variables on the command line, e.g.
#
#     make setup DB_USER=root DB_PASS=secret
# =====================================================================

DB_HOST ?= localhost
DB_PORT ?= 3306
DB_USER ?= root
DB_PASS ?=
DB_NAME ?= carsaaz

MYSQL  = mysql -h $(DB_HOST) -P $(DB_PORT) -u $(DB_USER) $(if $(DB_PASS),-p$(DB_PASS))

.PHONY: help setup schema seed query reset clean

help:
	@echo "CarSaaz - available targets"
	@echo "  make setup        Create schema and load sample data"
	@echo "  make schema       Run 01_schema.sql only"
	@echo "  make seed         Run 02_insert_data.sql only"
	@echo "  make query        Run 03_queries.sql"
	@echo "  make reset        Drop + recreate + reseed"

schema:
	$(MYSQL) < sql/01_schema.sql

seed:
	$(MYSQL) $(DB_NAME) < sql/02_insert_data.sql

query:
	$(MYSQL) $(DB_NAME) < sql/03_queries.sql

setup: schema seed
	@echo "Database $(DB_NAME) is ready."

reset: setup
	@echo "Database has been reset from scratch."

clean:
	@echo "Nothing to clean."
