#!/usr/bin/env bash
set -eu

export ARCH="${KUBE_ARCH:-`dpkg --print-architecture`}"
KUBE_ARCH=${ARCH}
SNAP_ARCH=${KUBE_ARCH}
if [ "$ARCH" = "ppc64el" ]; then
  KUBE_ARCH="ppc64le"
elif [ "$ARCH" = "armhf" ]; then
  KUBE_ARCH="arm"
fi
export KUBE_ARCH
export ETCD_VERSION="${ETCD_VERSION:-v3.4.3}"
export FLANNELD_VERSION="${FLANNELD_VERSION:-v0.11.0}"
export CNI_VERSION="${CNI_VERSION:-v0.8.7}"
export KNATIVE_SERVING_VERSION="${KNATIVE_SERVING_VERSION:-v0.13.0}"
export KNATIVE_EVENTING_VERSION="${KNATIVE_EVENTING_VERSION:-v0.13.0}"
# RUNC commit matching the containerd release commit
# Tag 1.5.7
export CONTAINERD_COMMIT="${CONTAINERD_COMMIT:-8686ededfc90076914c5238eb96c883ea093a8ba}"
# Release v1.0.2
export RUNC_COMMIT="${RUNC_COMMIT:-52b36a2dd837e8462de8e01458bf02cf9eea47dd}"
# Set this to the kubernetes fork you want to build binaries from
export KUBERNETES_REPOSITORY="${KUBERNETES_REPOSITORY:-github.com/kubernetes/kubernetes}"

export KUBE_TRACK="${KUBE_TRACK:-}"

export KUBE_VERSION="${KUBE_VERSION:-}"
export KUBE_SNAP_BINS="${KUBE_SNAP_BINS:-}"
if [ -e "$KUBE_SNAP_BINS/version" ]; then
  export KUBE_VERSION=`cat $KUBE_SNAP_BINS/version`
else
  # KUBE_SNAP_BINS is not set meaning we will either build the binaries OR fetch them from upstream
  # eitherway the k8s binaries should land at build/kube_bins/$KUBE_VERSION
  if [ -z "$KUBE_VERSION" ]; then
    # KUBE_VERSION is not set we will probably need the one from the upstream repo. If we build from
    # source the KUBE_VERSION should be provided
    if [ -z "$KUBE_TRACK" ]; then
      export KUBE_VERSION="${KUBE_VERSION:-`curl -L https://dl.k8s.io/release/stable.txt`}"
    else
      export KUBE_VERSION="${KUBE_VERSION:-`curl -L https://dl.k8s.io/release/stable-${KUBE_TRACK}.txt`}"
    fi
  fi
fi

export KUBERNETES_TAG="${KUBE_VERSION}"
export K8S_DQLITE_TAG="${K8S_DQLITE_TAG:-v1.0.2}"

export KUBE_SNAP_ROOT="$(readlink -f .)"

echo "Building with:"
echo "KUBE_VERSION=${KUBE_VERSION}"
echo "ETCD_VERSION=${ETCD_VERSION}"
echo "FLANNELD_VERSION=${FLANNELD_VERSION}"
echo "CNI_VERSION=${CNI_VERSION}"
echo "KUBE_ARCH=${KUBE_ARCH}"
echo "KUBE_SNAP_BINS=${KUBE_SNAP_BINS}"
echo "KNATIVE_SERVING_VERSION=${KNATIVE_SERVING_VERSION}"
echo "KNATIVE_EVENTING_VERSION=${KNATIVE_EVENTING_VERSION}"
echo "RUNC_COMMIT=${RUNC_COMMIT}"
echo "CONTAINERD_COMMIT=${CONTAINERD_COMMIT}"
echo "KUBERNETES_REPOSITORY=${KUBERNETES_REPOSITORY}"
echo "KUBERNETES_TAG=${KUBERNETES_TAG}"
echo "K8S_DQLITE_TAG=${K8S_DQLITE_TAG}"
