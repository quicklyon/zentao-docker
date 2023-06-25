#!/bin/bash

tag=$1

[ -z "$tag" ] && echo "Usage: $0 <tag>" && exit 1

newtag="$tag-$(date +'%Y%m%d')"

docker push easysoft/quickon-zentao:$tag
curl http://i.haogs.cn:3839/sync?image=easysoft/quickon-zentao:$tag

docker tag easysoft/quickon-zentao:$tag easysoft/quickon-zentao:$newtag
docker push easysoft/quickon-zentao:$newtag
curl http://i.haogs.cn:3839/sync?image=easysoft/quickon-zentao:$newtag
