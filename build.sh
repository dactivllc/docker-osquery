#!/bin/bash

build_deb() {
    VERSION=$1
    OS=$2

    TAG=$(echo $OS | sed 's/://g')

    docker build . --build-arg OSQUERY_URL=https://pkg.osquery.io/deb/osquery_${VERSION}_1.linux.amd64.deb --build-arg OS_IMAGE=$OS -t dactiv/osquery:${VERSION}-${TAG}
}

build_rpm() {
    VERSION=$1
    OS=$2

    TAG=$(echo $OS | sed 's/centos://g')

    docker build -f rpm-dockerfile . --build-arg OSQUERY_URL=https://pkg.osquery.io/rpm/osquery-${VERSION}-1.linux.x86_64.rpm --build-arg OS_IMAGE=$OS -t dactiv/osquery:${VERSION}-${TAG}
}

versions='4.3.0'
deb_platforms='ubuntu:20.04 ubuntu:18.04 ubuntu:16.04 ubuntu:14.04'
rpm_platforms='centos:centos8 centos:centos7 centos:centos6'

for v in $versions
do
    for os in $deb_platforms
    do
        build_deb $v $os
    done

    for os in $rpm_platforms
    do
        build_rpm $v $os
    done
done
