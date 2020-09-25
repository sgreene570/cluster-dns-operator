FROM registry.svc.ci.openshift.org/ocp/builder:golang-1.15 AS builder
WORKDIR /dns-operator
COPY . .
RUN make build

FROM registry.svc.ci.openshift.org/ocp/4.6:base
COPY --from=builder /dns-operator/src/github.com/openshift/cluster-dns-operator/dns-operator /usr/bin/
COPY manifests /manifests
RUN useradd dns-operator
USER dns-operator
ENTRYPOINT ["/usr/bin/dns-operator"]
LABEL io.openshift.release.operator="true"
LABEL io.k8s.display-name="OpenShift dns-operator" \
      io.k8s.description="This is a component of OpenShift and manages the lifecycle of cluster DNS services." \
      maintainer="Dan Mace <dmace@redhat.com>"
