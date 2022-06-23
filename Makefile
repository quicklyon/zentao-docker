export TAG := $(shell grep open VERSION | cut -d '=' -f 2)
export TAG_BIZ := $(shell grep ^biz VERSION | cut -d '=' -f 2)
export TAG_MAX := $(shell grep max VERSION | cut -d '=' -f 2)
export TAG_LITE := $(shell grep "lite=" VERSION | cut -d '=' -f 2)
export TAG_LITEBIZ := $(shell grep litebiz VERSION | cut -d '=' -f 2)

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build-all: build build-biz build-max build-lite build-litebiz ## 构建禅道所有版本镜像

build: ## 构建开源版镜像
	docker build --build-arg VERSION=$(TAG) -t hub.qucheng.com/app/zentao:$(TAG) -f Dockerfile .

build-biz: ## 构建企业版镜像
	docker build --build-arg VERSION=$(TAG_BIZ) -t hub.qucheng.com/app/zentao:$(TAG_BIZ) -f Dockerfile .

build-max: ## 构建旗舰版镜像
	docker build --build-arg VERSION=$(TAG_MAX) -t hub.qucheng.com/app/zentao:$(TAG_MAX) -f Dockerfile .

build-lite: ## 构建迅捷版
	docker build --build-arg VERSION=$(TAG_LITE) -t hub.qucheng.com/app/zentao:$(TAG_LITE) -f Dockerfile .

build-litebiz: ## 构建旗迅捷企业版
	docker build --build-arg VERSION=$(TAG_LITEBIZ) -t hub.qucheng.com/app/zentao:$(TAG_LITEBIZ) -f Dockerfile .

push-all: push push-biz push-max push-lite push-litebiz ## 将所有镜像push到镜像仓库

push: ## push 禅道开源版镜像
	docker push hub.qucheng.com/app/zentao:$(TAG)

push-biz: ## push 禅道企业版镜像
	docker push hub.qucheng.com/app/zentao:$(TAG_BIZ)

push-max: ## push 禅道旗舰版镜像
	docker push hub.qucheng.com/app/zentao:$(TAG_MAX)

push-lite: ## push 禅道迅捷版镜像
	docker push hub.qucheng.com/app/zentao:$(TAG_LITE)

push-litebiz: ## push 禅道迅捷企业版镜像
	docker push hub.qucheng.com/app/zentao:$(TAG_LITEBIZ)

run: ## 运行禅道开源版
	docker-compose -f docker-compose.yml up -d

run-biz: ## 运行禅道企业版
	export TAG=$(TAG_BIZ); docker-compose -f docker-compose.yml up -d

run-max: ## 运行禅道旗舰版
	export TAG=$(TAG_MAX);docker-compose -f docker-compose.yml up -d

run-lite: ## 运行禅道迅捷版
	export TAG=$(TAG_LITE);docker-compose -f docker-compose.yml up -d

run-litebiz: ## 运行禅道迅捷企业版
	export TAG=$(TAG_LITEBIZ);docker-compose -f docker-compose.yml up -d

ps: ## 运行状态
	docker-compose -f docker-compose.yml ps

stop: ## 停服务
	docker-compose -f docker-compose.yml stop

restart: build clean ps ## 重构

clean: stop ## 停服务
	docker-compose -f docker-compose.yml down
	docker volume prune -f

logs: ## 查看运行日志
	docker-compose -f docker-compose.yml logs
