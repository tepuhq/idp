# Tepu: Overview

## Purpose

Tepu is an open-source Internal Developer Platform (IDP) project for learning and demonstrating Cloud Computing, DevOps, and Platform Engineering. Its long-term goal is to let developers use templates to create, provision, deploy, and manage applications through a self-service workflow.

The project is also a learning environment. Each capability should make the underlying cloud operation understandable: what is created, who can access it, how it is deployed, how it is observed, and how it is removed. Automation should follow a manually understood workflow.

## Goals and audience

Tepu has two audiences:

- **The project maintainer**, who uses implementation and practical exercises to learn the infrastructure and platform decisions firsthand.
- **Future application developers**, who would use a consistent workflow to manage applications without repeating every infrastructure step.

The initial goals are to document the platform's boundaries, learn AWS-compatible operations locally through the AWS CLI and Floci, express understood infrastructure with Terraform, and identify the smallest useful self-service workflow. Success at this stage means that decisions and experiments are reproducible and explainable; it does not require a complete developer portal or an AWS account.

## Initial scope and boundaries

The proposed first slice is one application template and a traceable path from application creation to deployment and cleanup. The exact template, AWS runtime, and deployment mechanism remain open decisions. Documentation and labs should expose the steps behind that path before Tepu automates them.

The platform is intended to manage applications and their supporting resources. It is not currently defined as a general-purpose cloud control plane, a replacement for AWS consoles or the AWS CLI, or a multi-cloud product. These are scope boundaries for learning and initial design, not permanent restrictions.

Operational concerns belong in the first slice: identity and permissions, cost visibility, configuration, logs, failure handling, and resource cleanup. Their concrete implementation depends on the services selected later.

## Architectural direction

The intended backend language is Go, the frontend framework is Next.js, the cloud provider is AWS, and Terraform is the infrastructure-as-code tool. The initial application architecture is a modular monolith. These choices define a starting direction, not a claim that components have already been implemented.

A modular monolith keeps related platform workflows in one deployable backend while allowing clear module boundaries. It reduces the operational burden of separate services during early learning. The trade-off is that the backend shares a deployment and failure boundary; module interfaces should remain explicit so that a later split is possible when evidence justifies it.

Asynchronous workers may become useful for long-running provisioning or deployment work. Adding them now would introduce queues, retries, and coordination before the first workflow is understood. The need for workers should be revisited when a concrete workflow cannot be handled well within the initial architecture.

Floci is the primary environment for initial experiments when it supports the operations a workflow needs. Its actual coverage and behavior must be verified against Floci documentation and practical experiments for each service. Local success cannot by itself establish that an AWS deployment behaves identically. Validation on real AWS is a future, optional stage.

## Decision status

### Confirmed decisions

- The project is open source and lives in `tepuhq/idp` under the `tepuhq` GitHub organization.
- The technology direction is Go, Next.js, AWS, and Terraform.
- The initial architecture is a modular monolith.
- Initial learning is local-first with Floci; real AWS validation is optional and later.
- The long-term product goal is template-based application self-service.
- The maintainer will implement the platform manually as part of the learning process.

### Hypotheses to validate

- A single application template is enough to reveal the essential platform workflow.
- A modular monolith can support the initial provisioning and deployment workflows without a separate worker process.
- Floci can support the first end-to-end workflow once the required operations and behavior are verified.

### Open questions

- Which application template and AWS execution option should form the first complete workflow?
- Which resources should Tepu provision, and which should be prerequisites managed outside the platform?
- What should be the ownership model for Terraform state and, if real AWS is used later, its accounts and credentials?
- What lifecycle actions should the first version expose beyond creation and deployment?
- What evidence would justify asynchronous workers or a more complex deployment architecture?

These questions should be answered through the [learning roadmap](learning-roadmap.md), focused experiments, and explicit architectural decisions.
