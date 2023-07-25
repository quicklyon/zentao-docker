export APP_NAME=hub.qc.oop.cc/app/zentao
export OPEN_VER := $(or $(PMS_VERSION),$(shell jq -r .zentaopms.version < version.json))
export BIZ_VER := $(or $(BIZ_VERSION),biz$(shell jq -r .biz.version < version.json))
export MAX_VER := $(or $(MAX_VERSION),max$(shell jq -r .max.version < version.json))
export MAX_K8S_VER := $(or $(MAX_VERSION).k8s,max$(shell jq -r '."max.k8s".version' < version.json).k8s)
export BIZ_K8S_VER := $(or $(BIZ_VERSION).k8s,biz$(shell jq -r '."biz.k8s".version' < version.json).k8s)
export LITE_VER := lite$(shell jq -r .litev.version < version.json)
export LITEBIZ_VER := litevip$(shell jq -r .litevipv.version < version.json)
export IPD_VER := ipd$(shell jq -r .ipd.version < version.json)
export PHP_VER="7.4.33"
export MYSQL_VER="10.6.14"

.DEFAULT_GOAL:=help

help: ## this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_\-0-9]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

build-all: build build-biz build-biz-k8s build-max build-max-k8s build-ipd  ## 构建禅道所有版本镜像

build: ## 构建开源版镜像
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(OPEN_VER) $(PHP_VER) $(MYSQL_VER) "linux/amd64" "Dockerfile" "internal"
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(OPEN_VER) $(PHP_VER) $(MYSQL_VER) "linux/arm64" "Dockerfile" "internal"

build-biz: ## 构建企业版镜像
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(BIZ_VER) $(PHP_VER) $(MYSQL_VER) "linux/amd64" "Dockerfile" "internal"
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(BIZ_VER) $(PHP_VER) $(MYSQL_VER) "linux/arm64" "Dockerfile" "internal"

build-biz-k8s: ## 构建企业版Kubernetes定制版镜像
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(BIZ_K8S_VER) $(PHP_VER) $(MYSQL_VER) "linux/amd64" "Dockerfile" "internal"
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(BIZ_K8S_VER) $(PHP_VER) $(MYSQL_VER) "linux/arm64" "Dockerfile" "internal"

build-max: ## 构建旗舰版镜像
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(MAX_VER) $(PHP_VER) $(MYSQL_VER) "linux/amd64" "Dockerfile" "internal"
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(MAX_VER) $(PHP_VER) $(MYSQL_VER) "linux/arm64" "Dockerfile" "internal"

build-max-k8s: ## 构建旗舰版Kubernetes定制版镜像
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(MAX_K8S_VER) $(PHP_VER) $(MYSQL_VER) "linux/amd64" "Dockerfile" "internal"
	/bin/bash ./hack/make-rules/build.sh $(APP_NAME) $(MAX_K8S_VER) $(PHP_VER) $(MYSQL_VER) "linux/arm64" "Dockerfile" "internal"

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

push-public: ## push 禅道开源版 --> hub.docker.com
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(OPEN_VER)
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):latest
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

push-ipd-public: ## push 禅道ipd版 --> hub.docker.com
	hack/make-rules/docker.sh $(IPD_VER)

push-sync-tcr: push-all-public ## 同步到腾讯镜像仓库
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):latest

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

run-max-php74: ## 运行禅道旗舰版k8s
	export TAG=$(MAX_K8S_VER); docker-compose -f docker-compose-php74.yml up -d

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

clean: stop ## 停服务
	docker-compose -f docker-compose.yml down -v

logs: ## 查看运行日志
	docker-compose -f docker-compose.yml logs

markdown-init:
	@hack/make-rules/gen_report.sh init

markdown-render:
	@hack/make-rules/gen_report.sh render
