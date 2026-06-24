replica-up:
	@bash ./replica-up.sh
.PHONY: replica-up

replica-down:
	@(docker compose -f docker-compose-reth.yml down)
.PHONY: replica-down
