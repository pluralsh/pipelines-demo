# Pipelines Demo

This is a very trivial demo to show a simple helm chart pipeline, it has a few main components:

* wrapper service that would point to the `/services` directory that will sync everything in
* service under `/dev` with a service deployment CRD and global service CRD to set up a global service for your dev tier. Note the tags for the GlobalService CRD there.
* service under `/prod` with a service deployment CRD and global service CRD to set up a global service for your prod tier.  Note the tags for the GlobalService CRD there.
* service under `/pipeline` that configures the pipelines CRDs needed to automate promotion between them.

The dev service sets up a deployment for all clusters in the dev tier of the fleet, any updates to that subfolder will propagate there.  Similarly for the prod service.  This is configured to be manually git-ops'ed, so you'll have to specify all changes in this repo.

## The Pipeline

The pipeline is designed to be PR-driven to maintain GitOps purity.  This involves a Pipeline CRD defining the pipeline, where each stage points to a PRAutomation as its promotion criteria, and a PipelineContext.  To trigger the pipeline, you can simply modify `spec.context` w/in the PipelineContext, and once the CRD is synced, it'll start initiating the necessary PR's.

## Setting It Up Yourself

TLDR, fork or add this repo to your console and then create a service named `pipeline-demo` under the `infra` namespace in your management cluster, pointing to the `/services` subfolder.

If you might need to be delicate about namespace creation, just grep for `namespace:` for all the namespaces used and create them manually.  You should also create the `gh-test` ScmConnection in your console manually, or rewire it to an existing one in the `pipeline/prautomation.yaml` file's `scmConnectionRef` field.

`dev/podinfo.yaml` and `prod/podinfo.yaml` are currently wired to `k3s-test` by default.  Just switch that name to a cluster you already have, and potentially you might need to create the `Cluster` crds for them, eg:

```yaml
apiVersion: deployments.plural.sh/v1alpha1
kind: Cluster
metadata:
  name: k3s-test
  namespace: infra
spec:
  handle: k3s-test
```

## Notifications Setup

We also added a commented setup for notifications routing in `services/notifications.yaml`, it expects you to have already created a notification sink named `slack`, which can be done in the notifications tab of the console UI most easily.