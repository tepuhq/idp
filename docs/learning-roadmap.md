# Tepu: Learning Roadmap

## Approach

Learn the resource lifecycle locally before automating it. Floci is the primary environment for initial experiments; a real AWS account is an optional, later validation environment. The sequence is: perform operations manually with AWS CLI, reproduce understood resources with Terraform, compare deployment strategies, then design automation in Go and self-service in Next.js.

Each stage is a learning milestone. Local success proves behavior only for the tested Floci version and configuration. Record that version, the operations exercised, observed results, and cleanup. A future labs document can expand these milestones into command-by-command exercises.

Use a dedicated local CLI profile or shell session with **dummy credentials**, an explicit Floci endpoint, and a chosen test region. Keep real AWS credentials out of local labs and the repository. Verify the endpoint before creating resources; configure Terraform endpoints for every service used. Floci's [quick start](https://floci.io/floci/getting-started/quick-start/) and [Terraform guide](https://floci.io/floci/getting-started/terraform/) describe this setup without an AWS account.

## Stage 1: Local toolchain and endpoint safety

- **Learn:** Install and start Floci; install AWS CLI and Terraform; understand Docker, CLI profiles, regions, dummy credentials, and endpoints.
- **Exercise:** Follow Floci's [installation](https://floci.io/floci/getting-started/installation/) and quick start. Make a read-only AWS CLI request to Floci. Initialize a Terraform configuration with local service endpoints, without applying resources.
- **Complete when:** Floci responds, the CLI request uses dummy credentials and its local endpoint, Terraform initializes, and you can explain how to prevent a local command from targeting AWS.
- **Clean up:** Stop Floci and remove temporary CLI profiles or shell variables. Retain installation notes and the tested version.

## Stage 2: Manual resources with AWS CLI

- **Learn:** Create, inspect, use, and delete resources individually. Start with S3 objects and an SQS queue; the required operations are documented by Floci for [S3](https://floci.io/floci/services/s3/) and [SQS](https://floci.io/floci/services/sqs/).
- **Exercise:** Create a bucket, upload and retrieve an object; create a queue, send and receive a message; inspect both resources. Record dependencies and cleanup order. The two resources are independent in this lab.
- **Complete when:** You can reproduce the operations from notes, verify the object content and received message, and identify which commands change state.
- **Clean up:** Delete the object before the bucket; acknowledge or remove the message and delete the queue. List the resources afterward to confirm removal.

## Stage 3: Reproduce resources with Terraform

- **Learn:** Provider configuration, resources, variables, outputs, local state, plans, drift, and destruction. The [Floci Terraform guide](https://floci.io/floci/getting-started/terraform/) uses dummy credentials and explicit service endpoints.
- **Exercise:** After removing the manual resources, define an equivalent S3 bucket and SQS queue with Terraform and local state. Inspect the plan, apply it to Floci, verify with AWS CLI, and make one intentional configuration change. If the provider calls an unsupported operation, record the exact failure rather than assuming that the service listing guarantees Terraform compatibility.
- **Complete when:** You can explain the plan before applying it, identify tracked resources, and observe the intentional change through CLI inspection.
- **Clean up:** Run `terraform destroy` against Floci and verify removal with AWS CLI. Remove any leftover objects.

## Stage 4: Simplest deployment, a static site

- **Learn:** The difference between object storage and website hosting, and the limits of a static deployment.
- **Exercise:** Publish a small page with Floci's [S3 website hosting](https://floci.io/floci/services/s3/). Compare the object API and website addresses, then update the page. Floci documents GET/HEAD website requests, index resolution, and error documents; advanced routing rules are outside this lab.
- **Complete when:** A local HTTP request returns the expected page, an update becomes visible, and you can explain why this strategy does not run a Go server or a dynamic Next.js application.
- **Clean up:** Delete website configuration and objects, then the bucket. Confirm that the site URL no longer serves the page.

## Stage 5: A Go HTTP application on emulated EC2

- **Learn:** Server deployment responsibilities: runtime preparation, startup, network reachability, logs, and shutdown.
- **Exercise:** Use a small learning-only Go HTTP application. Provision an EC2 instance manually with AWS CLI, start the application, and inspect its response and logs. Document Docker access and the AMI-to-image mapping required by Floci's [EC2 implementation](https://floci.io/floci/services/ec2/).
- **Complete when:** The endpoint responds locally, you can locate the instance and its logs, and you can explain how a Docker-backed instance differs from an AWS VM. Record the networking mode used and its limitations.
- **Clean up:** Terminate the instance, remove lab-specific network or key resources, and confirm that the application endpoint and instance container are gone.

## Stage 6: Containers with ECR and ECS

- **Learn:** Run the same Go application as a local container, then add image storage and task orchestration.
- **Exercise:** Build the image locally, create an emulated ECR repository, push the image, and start an ECS task or service using AWS CLI. Inspect image, task, container, network, and log state. Floci documents a [Docker-backed ECR registry](https://floci.io/floci/services/ecr/) and [Docker-backed ECS tasks](https://floci.io/floci/services/ecs/) in its default execution mode. Confirm Docker access before this lab.
- **Complete when:** The containerized endpoint responds, the image is visible in ECR, and the task's actual running state and logs can be inspected. Compare setup steps, dependencies, update path, and cleanup with stages 4 and 5.
- **Clean up:** Stop tasks; remove any service, task definitions, cluster, and ECR repository in dependency order; remove the local test image and check for remaining Floci-managed containers.

## Stage 7: Automate one workflow with Go

- **Learn:** Map a completed manual workflow to backend operations for validation, resource ownership, status reporting, failure recovery, and deletion.
- **Exercise:** Specify the operations the Tepu modular monolith must perform for one completed local workflow, then implement that narrow workflow yourself in Go. Decide whether Terraform or direct service calls own each resource; do not assign both to the same resource. Keep every local operation pointed at Floci.
- **Complete when:** A request to the Go backend creates and reports a local resource, an invalid request produces an understandable failure, and a deletion request removes the resource. You can trace those outcomes to the previously documented manual operations.
- **Clean up:** Use the Go deletion path, verify removal with AWS CLI, and stop the backend and any temporary processes.

## Stage 8: Build a narrow Next.js self-service flow

- **Learn:** Present an application template and its lifecycle while exposing infrastructure status and errors.
- **Exercise:** Implement one small user journey yourself: select a template, submit inputs, inspect progress, view the resulting resource or endpoint, and request deletion. Connect the UI to the Go workflow from stage 7. Keep asynchronous workers an open decision until a concrete workflow requires them.
- **Complete when:** The UI can create, display, and delete one local application or resource through Go; it shows a useful error for an invalid request; and the lifecycle can be traced from the screen to Floci.
- **Clean up:** Delete test resources through the UI, verify removal with AWS CLI, and stop local frontend and backend processes.

## Stage 9: Optional validation on AWS

- **Learn:** Check which local assumptions hold in real AWS, especially identity, networking, runtime behavior, observability, and costs.
- **Exercise:** Only if desired, select the smallest completed workflow and prepare a separate AWS account or environment, credentials, budget, inventory, and teardown procedure. Review expected resources and charges before running it. This stage is never a prerequisite for stages 1 through 8.
- **Complete when:** The selected workflow has been observed on AWS, differences from Floci are recorded, and every created resource is accounted for.
- **Clean up:** Delete resources in dependency order, inspect for leftovers, and review billing afterward.

## Emulation limits and trade-offs

Floci's [service matrix](https://floci.io/floci/services/) is a discovery aid, not a guarantee of complete AWS compatibility. Verify the operations and integrations used by each lab against its service documentation and the tested Floci version. Its EC2 instances are Docker containers rather than AWS VMs, and Docker networking does not reproduce every VPC or security group behavior. ECS can run Docker containers, while mock mode reports task state without running them. The local ECR registry and authentication differ from AWS ECR, and S3 website hosting does not implement advanced routing rules. A successful local deployment therefore establishes local behavior, not AWS equivalence. [EC2](https://floci.io/floci/services/ec2/), [ECS](https://floci.io/floci/services/ecs/), [ECR](https://floci.io/floci/services/ecr/), [S3](https://floci.io/floci/services/s3/).

AWS CLI exposes individual calls and dependencies. Terraform makes known infrastructure repeatable but introduces state and change review. Go and Next.js add self-service and must account for partial failures and user feedback. Kubernetes, multiple backend services, and workers should wait for evidence from the simpler workflows.

## Decision status

### Confirmed decisions

- Floci is the primary environment for initial experiments; real AWS validation is optional and later.
- Local labs use dummy credentials and explicit local endpoints.
- Manual AWS CLI work precedes Terraform for the same resource lifecycle; Go and Next.js automation follows the manual labs.
- The technology direction remains Go, Next.js, AWS-compatible services, and Terraform, with a modular monolith initially.

### Hypotheses to validate

- S3, EC2, and ECS labs provide a useful progression from static hosting to server and container deployments.
- A narrow manual workflow provides enough evidence to design the first Go and Next.js self-service flow.

### Open questions

- Which deployment strategy should become Tepu's first managed application template?
- Which differences between Floci and AWS will matter for that template?
- When does the platform need shared Terraform state, stronger isolation, or an asynchronous worker?

The [overview](overview.md) records the project's scope and architectural direction.
