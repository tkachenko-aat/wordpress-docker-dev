.PHONY: up down logs shell setup clean restart status wpcli help

# Start all services
up:
	docker-compose up -d

# Stop all services
down:
	docker-compose down

# View WordPress logs
logs:
	docker-compose logs -f wordpress

# Open WordPress container shell
shell:
	docker-compose exec wordpress bash

# Open WP-CLI container
wpcli:
	docker-compose exec wpcli bash

# Run initial setup
setup: up
	./setup.sh

# Clean up everything (removes volumes)
clean:
	docker-compose down -v
	docker system prune -f

# Restart all services
restart: down up

# Show container status
status:
	docker-compose ps

# Show available commands
help:
	@echo "Available commands:"
	@echo "  make up       - Start all services"
	@echo "  make down     - Stop all services"
	@echo "  make logs     - View WordPress logs"
	@echo "  make shell    - Open WordPress container shell"
	@echo "  make wpcli    - Open WP-CLI container"
	@echo "  make setup    - Run initial setup"
	@echo "  make clean    - Clean up everything"
	@echo "  make restart  - Restart all services"
	@echo "  make status   - Show container status"
	@echo "  make help     - Show this help"