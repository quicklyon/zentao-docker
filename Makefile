export APP_NAME=easysoft/quickon-zentao
export OPEN_VER := $(shell jq -r .zentaopms.version < version.json)
export BIZ_VER := biz$(shell jq -r .biz.version < version.json)
export MAX_VER := max$(shell jq -r .max.version < version.json)
export MAX_K8S_VER := max$(shell jq -r '."max.k8s".version' < version.json).k8s
export BIZ_K8S_VER := biz$(shell jq -r '."biz.k8s".version' < version.json).k8s
export LITE_VER := lite$(shell jq -r .litev.version < version.json)
export LITEBIZ_VER := litevip$(shell jq -r .litevipv.version < version.json)
export IPD_VER := ipd$(shell jq -r .ipd.version < version.json)

.DEFAULT_GOAL:=help

help: ## this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_\-0-9]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build-all: build build-biz build-biz-k8s build-max build-max-k8s build-ipd  ## 构建禅道所有版本镜像

build: ## 构建开源版镜像
	docker build --build-arg VERSION=$(OPEN_VER) -t $(APP_NAME):$(OPEN_VER) -f Dockerfile .

build-arm: ## 构建开源版镜像ARM
	docker build --platform arm64 --build-arg VERSION=$(OPEN_VER) -t $(APP_NAME):$(OPEN_VER) -f Dockerfile.arm64 .

build-biz: ## 构建企业版镜像
	docker build --build-arg VERSION=$(BIZ_VER) -t $(APP_NAME):$(BIZ_VER) -f Dockerfile .

build-biz-k8s: ## 构建企业版Kubernetes定制版镜像
	docker build --build-arg VERSION=$(BIZ_K8S_VER) -t $(APP_NAME):$(BIZ_K8S_VER) -f Dockerfile .

build-max: ## 构建旗舰版镜像
	docker build --build-arg VERSION=$(MAX_VER) -t $(APP_NAME):$(MAX_VER) -f Dockerfile .

build-max-k8s: ## 构建旗舰版Kubernetes定制版镜像
	docker build --build-arg VERSION=$(MAX_K8S_VER) -t $(APP_NAME):$(MAX_K8S_VER) -f Dockerfile .

build-max-k8s-php81: ## 构建旗舰版 PHP8.1 Kubernetes 镜像
	docker build --build-arg VERSION=$(MAX_K8S_VER) -t $(APP_NAME):$(MAX_K8S_VER)-php81 -f Dockerfile.php81 .

build-max-k8s-arm64: ## 构建旗舰版Kubernetes定制版镜像(arm64)
	docker build --platform arm64 --build-arg VERSION=$(MAX_K8S_VER) -t $(APP_NAME):$(MAX_K8S_VER) -f Dockerfile.arm64 .

build-lite: ## 构建迅捷版
	docker build --build-arg VERSION=$(LITE_VER) -t $(APP_NAME):$(LITE_VER) -f Dockerfile .

build-litebiz: ## 构建旗迅捷企业版
	docker build --build-arg VERSION=$(LITEBIZ_VER) -t $(APP_NAME):$(LITEBIZ_VER) -f Dockerfile .

build-ipd: ## 构建ipd版本
	docker build --build-arg VERSION=$(IPD_VER) -t $(APP_NAME):$(IPD_VER) -f Dockerfile .

push-all-public: push-public push-biz-public push-biz-k8s-public push-max-k8s-public push-max-public push-ipd-public

push-all: push push-biz push-biz-k8s push-max push-max-k8s ## 将所有镜像push到 hub.qucheng.com 镜像仓库

push: ## push 禅道开源版 --> hub.qucheng.com
	docker push $(APP_NAME):$(OPEN_VER)

push-biz: ## push 禅道企业版 --> hub.qucheng.com
	docker push $(APP_NAME):$(BIZ_VER)

push-biz-k8s: ## push 企业版k8s --> hub.qucheng.com
	docker push $(APP_NAME):$(BIZ_K8S_VER)

push-max: ## push 禅道旗舰版 --> hub.qucheng.com
	docker push $(APP_NAME):$(MAX_VER)

push-max-k8s: ## push 禅道旗舰版k8s --> hub.qucheng.com
	docker push $(APP_NAME):$(MAX_K8S_VER)

push-max-k8s-arm64: ## push 禅道旗舰版k8s(arm64) --> hub.qucheng.com
	docker push --platform linux/arm64 $(APP_NAME):$(MAX_K8S_VER)

push-lite: ## push 禅道迅捷版 --> hub.qucheng.com
	docker push $(APP_NAME):$(LITE_VER)

push-litebiz: ## push 禅道迅捷企业版 --> hub.qucheng.com
	docker push $(APP_NAME):$(LITEBIZ_VER)

push-public: ## push 禅道开源版 --> hub.docker.com
	curl http://i.haogs.cn:3839/sync?image=$(APP_NAME):$(OPEN_VER)
	curl http://i.haogs.cn:3839/sync?image=$(APP_NAME):latest
	hack/make-rules/docker.sh $(OPEN_VER)
	hack/make-rules/docker.sh latest

push-biz-public: ## push 禅道企业版 --> hub.docker.com
	hack/make-rules/docker.sh $(BIZ_VER)

push-biz-k8s-public: ## push 企业版k8s --> hub.docker.com
	hack/make-rules/docker.sh $(BIZ_K8S_VER)

push-max-public: ## push 禅道旗舰版 --> hub.docker.com
	hack/make-rules/docker.sh $(MAX_VER)

push-max-k8s-public: ## push 禅道旗舰版k8s --> hub.docker.com
	hack/make-rules/docker.sh $(MAX_K8S_VER)

push-max-k8s-arm64-public: ## push 禅道旗舰版k8s(arm64) --> hub.docker.com
	hack/make-rules/docker.sh $(MAX_K8S_VER)

push-lite-public: ## push 禅道迅捷版 --> hub.docker.com
	hack/make-rules/docker.sh $(LITE_VER)

push-litebiz-public: ## push 禅道迅捷企业版 --> hub.docker.com
	hack/make-rules/docker.sh $(LITEBIZ_VER)

push-ipd-public: ## push 禅道ipd版 --> hub.docker.com
	hack/make-rules/docker.sh $(IPD_VER)

push-sync-tcr: push-all-public ## 同步到腾讯镜像仓库
	curl http://i.haogs.cn:3839/sync?image=$(APP_NAME):latest

run: ## 运行禅道开源版
	export TAG=$(OPEN_VER); docker-compose -f docker-compose.yml up -d

run-biz: ## 运行禅道企业版
	export TAG=$(BIZ_VER); docker-compose -f docker-compose.yml up -d

run-biz-k8s: ## 运行禅道旗舰版k8s
	export TAG=$(BIZ_K8S_VER); docker-compose -f docker-compose.yml up -d

run-max: ## 运行禅道旗舰版
	export TAG=$(MAX_VER); docker-compose -f docker-compose.yml up -d

run-max-k8s: ## 运行禅道旗舰版k8s
	export TAG=$(MAX_K8S_VER); docker-compose -f docker-compose.yml up -d

run-max-php81: ## 运行禅道旗舰版k8s
	export TAG=$(MAX_K8S_VER); docker-compose -f docker-compose-php81.yml up -d

run-max-k8s-arm64: ## 运行禅道旗舰版k8s(arm64)
	export TAG=$(MAX_K8S_VER); docker-compose -f docker-compose-arm64.yml up -d

run-lite: ## 运行禅道迅捷版
	export TAG=$(LITE_VER);docker-compose -f docker-compose.yml up -d

run-litebiz: ## 运行禅道迅捷企业版
	export TAG=$(LITEBIZ_VER);docker-compose -f docker-compose.yml up -d

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
	docker-compose -f docker-compose-arm64.yml down -v

clean: stop ## 停服务
	docker-compose -f docker-compose.yml down -v

logs: ## 查看运行日志
	docker-compose -f docker-compose.yml logs

