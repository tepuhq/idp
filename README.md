# Tepu IDP

**Self-service infrastructure and application management for developers.**

Tepu IDP is an open-source Internal Developer Platform designed to simplify application provisioning, deployment, and infrastructure management through developer self-service.

The project is part of the [Tepu](https://github.com/tepuhq) ecosystem and serves as its first developer tooling product.

## Project status

Tepu IDP is currently in its early development stage, focusing on cloud infrastructure, automation, and the foundations of its self-service platform.

Initial experiments run locally with Floci, with optional validation on real AWS.

## Technical direction

- **Backend:** Go, initially as a modular monolith.
- **Frontend:** Next.js.
- **Infrastructure:** AWS-compatible services and Terraform.
- **Local environment:** Floci where its documented operations support the experiment.

The initial goal is to establish a complete application lifecycle before expanding into automated provisioning, deployments, infrastructure visibility, and management.

## Documentation

- [Overview](docs/overview.md): purpose, scope, architectural direction, and open decisions.
- [Learning roadmap](docs/learning-roadmap.md): local-first exercises with AWS CLI, Terraform, deployment strategies, Go automation, and Next.js self-service.

## License

Tepu IDP is licensed under the [Apache License 2.0](LICENSE).
