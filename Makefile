# Makefile для Django-проекта — с цветами, табами и удобным интерфейсом

# Цвета
RED    = \033[0;31m
GREEN  = \033[0;32m
YELLOW = \033[1;33m
BLUE   = \033[0;34m
RESET  = \033[0m

# Константы
PYTHON  = python3
PIP     = pip3
MANAGE  = manage.py
WSGI    = backend.wsgi:application
WORKERS = 2

# Помощь: показать все команды с описанием
.PHONY: help
help: ## 📚 Показать справку
	@echo -e "${BLUE}Доступные команды:${RESET}\n"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/\t→ /'
	@echo -e "${RESET}"

# Виртуальное окружение
.PHONY: venv
venv: ## 🐍 Создать виртуальное окружение (venv)
	@echo -e "${GREEN}Создаём виртуальное окружение...${RESET}"
	$(PYTHON) -m venv venv
	@echo -e "${GREEN}✅ Готово: ./venv/${RESET}"

.PHONY: install
install: ## 📦 Установить зависимости
	@echo -e "${GREEN}Устанавливаем зависимости...${RESET}"
	./venv/bin/$(PIP) install -r requirements/global.txt
	@echo -e "${GREEN}✅ Завершено${RESET}"

# Запуск серверов
.PHONY: run
run: ## 🔧 Запустить веб-сервер Django
	@echo -e "${BLUE}Запускаем Django веб сервер...${RESET}"
	$(PYTHON) $(MANAGE) runserver

.PHONY: gunicorn
gunicorn: ## 🚀 Запустить веб-сервер Gunicorn
	@echo -e "${BLUE}Запускаем Gunicorn с $(WORKERS) воркерами...${RESET}"
	gunicorn $(WSGI) --workers=$(WORKERS) --bind 0.0.0.0:8000 --reload

# Django команды
.PHONY: makemigrations
makemigrations: ## 🗂 Создать миграции БД
	@echo -e "${YELLOW}Создаём миграции...${RESET}"
	$(PYTHON) $(MANAGE) makemigrations

.PHONY: migrate
migrate: ## 🛠 Применить миграции БД
	@echo -e "${YELLOW}Применяем миграции...${RESET}"
	$(PYTHON) $(MANAGE) migrate

.PHONY: createsuperuser
createsuperuser: ## 👨‍💻 Создать суперпользователя
	@echo -e "${GREEN}Создаём суперпользователя...${RESET}"
	$(PYTHON) $(MANAGE) createsuperuser

SHELL := /bin/bash
