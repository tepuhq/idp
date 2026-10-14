# Tepu

Tepu is an open-source Internal Developer Platform (IDP) project for learning and demonstrating Cloud Computing, DevOps, and Platform Engineering. Its long-term goal is to let developers create, provision, deploy, and manage applications through templates and a self-service workflow.

## Project status

Tepu is in its documentation and learning stage. The platform has not been implemented yet. The first experiments will run locally with Floci; validation on real AWS is optional and comes later.

## Technical direction

- **Backend:** Go, initially as a modular monolith.
- **Frontend:** Next.js.
- **Infrastructure:** AWS-compatible services and Terraform.
- **Local environment:** Floci where its documented operations support the experiment.

The first goal is to understand and document a small application lifecycle before automating it. Workers, Kubernetes, and a more distributed architecture remain decisions for a demonstrated need.

## Documentation

- [Overview](docs/overview.md): purpose, scope, architectural direction, and open decisions.
- [Learning roadmap](docs/learning-roadmap.md): local-first exercises with AWS CLI, Terraform, deployment strategies, Go automation, and Next.js self-service.

## License

Tepu is licensed under the [Apache License 2.0](LICENSE).
