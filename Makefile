export APP_NAME=quickon-zentao
export OPEN_VER := $(shell jq -r .zentaopms.version < version.json)
export BIZ_VER := biz$(shell jq -r .biz.version < version.json)
export MAX_VER := max$(shell jq -r .max.version < version.json)
export MAX_K8S_VER := max$(shell jq -r '."max.k8s".version' < version.json).k8s
export BIZ_K8S_VER := biz$(shell jq -r '."biz.k8s".version' < version.json).k8s
export LITE_VER := lite$(shell jq -r .litev.version < version.json)
export LITEBIZ_VER := litevip$(shell jq -r .litevipv.version < version.json)
export BUILD_DATE := $(shell date +'%Y%m%d')

.DEFAULT_GOAL:=help

help: ## this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_\-0-9]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build-all: build build-biz build-max build-max-k8s build-lite build-litebiz ## 构建禅道所有版本镜像

build: ## 构建开源版镜像
	docker build --build-arg VERSION=$(OPEN_VER) -t hub.qucheng.com/app/$(APP_NAME):$(OPEN_VER)-$(BUILD_DATE) -f Dockerfile .

build-biz: ## 构建企业版镜像
	docker build --build-arg VERSION=$(BIZ_VER) -t hub.qucheng.com/app/$(APP_NAME):$(BIZ_VER)-$(BUILD_DATE) -f Dockerfile .

build-biz-k8s: ## 构建企业版Kubernetes定制版镜像
	docker build --build-arg VERSION=$(BIZ_K8S_VER) -t hub.qucheng.com/app/$(APP_NAME):$(BIZ_K8S_VER)-$(BUILD_DATE) -f Dockerfile .

build-max: ## 构建旗舰版镜像
	docker build --build-arg VERSION=$(MAX_VER) -t hub.qucheng.com/app/$(APP_NAME):$(MAX_VER)-$(BUILD_DATE) -f Dockerfile .

build-max-k8s: ## 构建旗舰版Kubernetes定制版镜像
	docker build --build-arg VERSION=$(MAX_K8S_VER) -t hub.qucheng.com/app/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE) -f Dockerfile .

build-max-k8s-arm64: ## 构建旗舰版Kubernetes定制版镜像(arm64)
	docker build --platform arm64 --build-arg MIRROR=true --build-arg VERSION=$(MAX_K8S_VER) -t hub.qucheng.com/app/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE) -f Dockerfile.arm64 .

build-lite: ## 构建迅捷版
	docker build --build-arg VERSION=$(LITE_VER) -t hub.qucheng.com/app/$(APP_NAME):$(LITE_VER)-$(BUILD_DATE) -f Dockerfile .

build-litebiz: ## 构建旗迅捷企业版
	docker build --build-arg VERSION=$(LITEBIZ_VER) -t hub.qucheng.com/app/$(APP_NAME):$(LITEBIZ_VER)-$(BUILD_DATE) -f Dockerfile .

push-all-public: push-public push-biz-public push-biz-k8s-public push-max-k8s-public push-max-public push-lite-public push-litebiz-public ## 将所有镜像push到 hub.docker.com 镜像仓库

push-all: push push-biz push-max push-max-k8s push-lite push-litebiz ## 将所有镜像push到 hub.qucheng.com 镜像仓库

push: ## push 禅道开源版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/$(APP_NAME):$(OPEN_VER)-$(BUILD_DATE)

push-biz: ## push 禅道企业版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/$(APP_NAME):$(BIZ_VER)-$(BUILD_DATE)

push-biz-k8s: ## push 企业版k8s --> hub.qucheng.com
	docker push hub.qucheng.com/app/$(APP_NAME):$(BIZ_K8S_VER)-$(BUILD_DATE)

push-max: ## push 禅道旗舰版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/$(APP_NAME):$(MAX_VER)-$(BUILD_DATE)

push-max-k8s: ## push 禅道旗舰版k8s --> hub.qucheng.com
	docker push hub.qucheng.com/app/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE)

push-max-k8s-arm64: ## push 禅道旗舰版k8s(arm64) --> hub.qucheng.com
	docker push --platform linux/arm64 hub.qucheng.com/app/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE)

push-lite: ## push 禅道迅捷版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/$(APP_NAME):$(LITE_VER)-$(BUILD_DATE)

push-litebiz: ## push 禅道迅捷企业版 --> hub.qucheng.com
	docker push hub.qucheng.com/app/$(APP_NAME):$(LITEBIZ_VER)-$(BUILD_DATE)

push-public: ## push 禅道开源版 --> hub.docker.com
	docker tag hub.qucheng.com/app/$(APP_NAME):$(OPEN_VER)-$(BUILD_DATE) easysoft/$(APP_NAME):$(OPEN_VER)-$(BUILD_DATE)
	docker tag easysoft/$(APP_NAME):$(OPEN_VER)-$(BUILD_DATE) easysoft/$(APP_NAME):latest
	docker push easysoft/$(APP_NAME):$(OPEN_VER)-$(BUILD_DATE)
	docker push easysoft/$(APP_NAME):latest
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(OPEN_VER)-$(BUILD_DATE)


push-biz-public: ## push 禅道企业版 --> hub.docker.com
	docker tag hub.qucheng.com/app/$(APP_NAME):$(BIZ_VER)-$(BUILD_DATE) easysoft/$(APP_NAME):$(BIZ_VER)-$(BUILD_DATE)
	docker push easysoft/$(APP_NAME):$(BIZ_VER)-$(BUILD_DATE)
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(BIZ_VER)-$(BUILD_DATE)

push-biz-k8s-public: ## push 企业版k8s --> hub.docker.com
	docker tag hub.qucheng.com/app/$(APP_NAME):$(BIZ_K8S_VER)-$(BUILD_DATE) easysoft/$(APP_NAME):$(BIZ_K8S_VER)-$(BUILD_DATE)
	docker push  easysoft/$(APP_NAME):$(BIZ_K8S_VER)-$(BUILD_DATE)
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(BIZ_K8S_VER)-$(BUILD_DATE)


push-max-public: ## push 禅道旗舰版 --> hub.docker.com
	docker tag hub.qucheng.com/app/$(APP_NAME):$(MAX_VER)-$(BUILD_DATE) easysoft/$(APP_NAME):$(MAX_VER)-$(BUILD_DATE)
	docker push  easysoft/$(APP_NAME):$(MAX_VER)-$(BUILD_DATE)
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(MAX_VER)-$(BUILD_DATE)

push-max-k8s-public: ## push 禅道旗舰版k8s --> hub.docker.com
	docker tag hub.qucheng.com/app/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE) easysoft/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE)
	docker push  easysoft/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE)
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE)

push-max-k8s-arm64-public: ## push 禅道旗舰版k8s(arm64) --> hub.docker.com
	docker tag hub.qucheng.com/app/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE) easysoft/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE)
	docker push easysoft/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE)
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(MAX_K8S_VER)-$(BUILD_DATE)

push-lite-public: ## push 禅道迅捷版 --> hub.docker.com
	docker tag hub.qucheng.com/app/$(APP_NAME):$(LITE_VER)-$(BUILD_DATE) easysoft/$(APP_NAME):$(LITE_VER)-$(BUILD_DATE)
	docker push easysoft/$(APP_NAME):$(LITE_VER)-$(BUILD_DATE)
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(LITE_VER)-$(BUILD_DATE)

push-litebiz-public: ## push 禅道迅捷企业版 --> hub.docker.com
	docker tag hub.qucheng.com/app/$(APP_NAME):$(LITEBIZ_VER)-$(BUILD_DATE) easysoft/$(APP_NAME):$(LITEBIZ_VER)-$(BUILD_DATE)
	docker push easysoft/$(APP_NAME):$(LITEBIZ_VER)-$(BUILD_DATE)
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(LITEBIZ_VER)-$(BUILD_DATE)

push-sync-tcr: push-all-public ## 同步到腾讯镜像仓库
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):latest

run: ## 运行禅道开源版
	export TAG=$(OPEN_VER)-$(BUILD_DATE); docker-compose -f docker-compose.yml up -d

run-biz: ## 运行禅道企业版
	export TAG=$(BIZ_VER)-$(BUILD_DATE); docker-compose -f docker-compose.yml up -d

run-biz-k8s: ## 运行禅道旗舰版k8s
	export TAG=$(BIZ_K8S_VER)-$(BUILD_DATE); docker-compose -f docker-compose.yml up -d

run-max: ## 运行禅道旗舰版
	export TAG=$(MAX_VER)-$(BUILD_DATE); docker-compose -f docker-compose.yml up -d

run-max-k8s: ## 运行禅道旗舰版k8s
	export TAG=$(MAX_K8S_VER)-$(BUILD_DATE); docker-compose -f docker-compose.yml up -d

run-max-k8s-arm64: ## 运行禅道旗舰版k8s(arm64)
	export TAG=$(MAX_K8S_VER)-$(BUILD_DATE); docker-compose -f docker-compose-arm64.yml up -d

run-lite: ## 运行禅道迅捷版
	export TAG=$(LITE_VER)-$(BUILD_DATE);docker-compose -f docker-compose.yml up -d

run-litebiz: ## 运行禅道迅捷企业版
	export TAG=$(LITEBIZ_VER)-$(BUILD_DATE);docker-compose -f docker-compose.yml up -d

test-open: ## 测试禅道开源版
	hack/make-rules/smoke-test.sh "zentao-open" "run"

test-max: ## 测试禅道旗舰版
	hack/make-rules/smoke-test.sh "zentao-max" "run-max"

test-biz: ## 测试禅道企业版
	hack/make-rules/smoke-test.sh "zentao-biz" "run-biz"

ps: ## 运行状态
	docker-compose -f docker-compose.yml ps

stop: ## 停服务
	docker-compose -f docker-compose.yml stop
	docker-compose -f docker-compose.yml rm -f

stop-arm: ## 停arm服务
	docker-compose -f docker-compose-arm64.yml stop
	docker-compose -f docker-compose-arm64.yml rm -f

restart: build clean ps ## 重构

clean-arm64:  ## 停arm服务
	docker-compose -f docker-compose-arm64.yml stop
	docker-compose -f docker-compose-arm64.yml rm -f
	docker-compose -f docker-compose-arm64.yml down
	docker volume prune -f

clean: stop ## 停服务
	docker-compose -f docker-compose.yml down
	docker volume prune -f

logs: ## 查看运行日志
	docker-compose -f docker-compose.yml logs
