replica-up:
	@bash ./replica-up.sh
.PHONY: replica-up

replica-down:
	@(docker-compose -f docker-compose.yml down)
.PHONY: replica-down

replica-clean: replica-down
	docker image ls 'bedrock-replica*' --format='{{.Repository}}' | xargs -r docker rmi
	docker volume ls --filter name=bedrock-replica --format='{{.Name}}' | xargs -r docker volume rm
.PHONY: replica-clean
