#!/bin/bash

set -e
echo "building for $RID"

if [[ $RID =~ arm64 ]]; then
    arch="arm64"
elif [[ $RID =~ arm ]]; then
    arch="armhf"
elif [[ $RID =~ ppc64le ]]; then
    arch="powerpc64le"
elif [[ $RID =~ riscv64 ]]; then
    arch="riscv64"
else
    arch="amd64"
fi

if [[ $RID == linux-musl* ]]; then
    is_musl="true"
else
    is_musl="false"
fi

docker build -t $RID -f docker/linux \
    --build-arg ARCH=$arch \
    --build-arg IS_MUSL=$is_musl .

docker run -t -e RID=$RID --name=$RID $RID

docker cp $RID:/nativebinaries/nuget.package/runtimes nuget.package

docker rm $RID
