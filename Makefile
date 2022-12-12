DJANGOAPP?=myapp

.ONESHELL:
.SILENT:

build:
	docker compose build

run:
	docker compose up


.venv:
	nix-shell -p python3 python3Packages.virtualenv --run \
	"virtualenv .venv; source .venv/bin/activate; pip install Django"


$(DJANGOAPP): .venv
	nix-shell -p python3 python3Packages.virtualenv --run \
	"source .venv/bin/activate; django-admin startproject $(DJANGOAPP) .; touch ./requirements.txt"


django: $(DJANGOAPP)
	nix-shell -p python3 python3Packages.virtualenv --run \
	"source .venv/bin/activate; pip install -r ./requirements.txt"


run: django
	nix-shell -p python3 python3Packages.virtualenv --run \
	"source .venv/bin/activate; for TASK in makemigrations migrate createcachetable collectstatic runserver; do echo ${TASK}; python manage.py ${TASK}; done"


venv-run-nixos: .venv
	@echo "To run ist:"
	@echo "nix-shell -p python3 python3Packages.virtualenv --command 'source .venv/bin/activate; return'"

