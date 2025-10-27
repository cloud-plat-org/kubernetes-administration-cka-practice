#!/bin/bash

# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_ROOT=$(dirname ${BASH_SOURCE})/..
DEFAULT_TAG="1.5.1"
TAG_TO_APPLY=${TAG-$DEFAULT_TAG}

if [ "${TAG_TO_APPLY}" == "${DEFAULT_TAG}" ]; then
  git switch --detach vertical-pod-autoscaler-${DEFAULT_TAG}
fi

$SCRIPT_ROOT/hack/vpa-process-yamls.sh apply $*



#  kubectl apply -f /root/vpa-crds.yml
# customresourcedefinition.apiextensions.k8s.io/verticalpodautoscalercheckpoints.autoscaling.k8s.io created
# customresourcedefinition.apiextensions.k8s.io/verticalpodautoscalers.autoscaling.k8s.io created

# controlplane ~ ➜  kubectl apply -f /root/vpa-rbac.yml
# clusterrole.rbac.authorization.k8s.io/system:metrics-reader created
# clusterrole.rbac.authorization.k8s.io/system:vpa-actor created
# clusterrole.rbac.authorization.k8s.io/system:vpa-status-actor created
# clusterrole.rbac.authorization.k8s.io/system:vpa-checkpoint-actor created
# clusterrole.rbac.authorization.k8s.io/system:evictioner created
# clusterrolebinding.rbac.authorization.k8s.io/system:metrics-reader created
# clusterrolebinding.rbac.authorization.k8s.io/system:vpa-actor created
# clusterrolebinding.rbac.authorization.k8s.io/system:vpa-status-actor created
# clusterrolebinding.rbac.authorization.k8s.io/system:vpa-checkpoint-actor created
# clusterrole.rbac.authorization.k8s.io/system:vpa-target-reader created
# clusterrolebinding.rbac.authorization.k8s.io/system:vpa-target-reader-binding created
# clusterrolebinding.rbac.authorization.k8s.io/system:vpa-evictioner-binding created
# serviceaccount/vpa-admission-controller created
# serviceaccount/vpa-recommender created
# serviceaccount/vpa-updater created
# clusterrole.rbac.authorization.k8s.io/system:vpa-admission-controller created
# clusterrolebinding.rbac.authorization.k8s.io/system:vpa-admission-controller created
# clusterrole.rbac.authorization.k8s.io/system:vpa-status-reader created
# clusterrolebinding.rbac.authorization.k8s.io/system:vpa-status-reader-binding created
