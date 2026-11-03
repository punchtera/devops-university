# AWS DevOps Learning Path — 45 min/day

Oct 27, 2026 · Juan Ramirez

## How to use this plan

The plan runs 24 weeks at 45 minutes a day, 5 days a week (about 90 hours), and ends with you deploying and operating a multi-environment app on AWS that you built from code. Weekends are optional catch-up; a missed day just shifts the plan, it never restarts it.

### The daily 45 minutes

- **5 min** — reread yesterday's notes and today's task.
- **30 min** — the course module or hands-on lab for the day.
- **10 min** — write 3 lines in `devops-journal.md`: what you built, what broke, one question. Commit it. The commit streak is your consistency tracker.

**One repo for everything.** Every script, template, pipeline and note goes in this repo, so by week 24 it is a portfolio.

### My account: AWS Free plan (new AWS experience)

This whole plan runs on a **Free plan** account — no credit card charges, ever, unless I choose to upgrade.

- **Account:** signed up Nov 2, 2026 with `js.ramirezc18@gmail.com` through the new AWS sign-up experience. Resources live in a **project** ("Blank Slate", account `357601815547`, Region `us-east-2`), owned by my **AWS Builder ID**. There is **no root user** and no IAM Identity Center; I already have admin access to the project.
- **Credits:** $100 at sign-up, plus up to **$100 more** for first-time activities (launch EC2, try a Bedrock prompt, create a cost budget, build a Lambda web app, create an RDS database). Days that earn credits are marked 💰.
- **Duration:** the Free plan ends after **6 months (≈ May 3, 2027) or when credits run out**, whichever comes first. The account then closes, with 90 days to upgrade and recover. Day 120 lands around mid-April 2027 if I keep 5 days a week, so use weekends to catch up on missed days.
- **Things that would end the Free plan** (upgrade to Paid, irreversible — avoid): joining or creating an **AWS Organization**, setting up Control Tower, activating "advanced features" (which requires a paid upgrade first), or adding a payment method to upgrade.
- **Not available on the Free plan:** Savings Plans, Reserved Instances, spend limits (Paid only), some Marketplace offers, and some services. If a lab's service isn't available, do the local / read-only version and journal what you'd do.

### Cost safety before anything else (Day 1–2)

- Turn on MFA for your AWS Builder ID (profile.aws.amazon.com → Security): Touch ID + an authenticator app as backup. If you sign in with Google, also turn on Google 2-Step Verification.
- 💰 Create an **AWS Budget** with an email alert at $5 that **excludes credits** (`IncludeCredit` off), so you see real usage, not $0. It earns bonus credits too.
- Watch credits in settings.aws.com → **Billing**. Credits are money: a forgotten resource drains them just like a bill.
- Biggest credit burners in this plan: **NAT gateways** (~$32/month each + data), **public IPv4 addresses** (~$3.60/month each, even idle), **load balancers**, **EKS clusters**, **RDS instances**. Tear down at the end of every lab session; from week 8 onward use IaC so teardown is one command.

> **Learning rule:** for every service you touch, write one line in your journal answering *"why this service and not the alternative?"* That habit is what turns service knowledge into judgment.

## Phase overview

Six phases build on each other: you learn the platform, then automate it, then ship to it, then operate it. Each phase ends with a small deliverable in your repo.

| Phase | Weeks | Days | You can do this at the end | Main free resource |
|---|---|---|---|---|
| 1. Cloud & AWS foundations | 1–4 | 1–20 | Explain and build a VPC with public/private subnets, EC2, S3, IAM roles | AWS Skill Builder: Cloud Practitioner Essentials, Cloud Quest |
| 2. Linux, Git & containers | 5–7 | 21–35 | Containerize your own app and push it to Amazon ECR | Skill Builder container courses, Docker docs |
| 3. Infrastructure as Code | 8–11 | 36–55 | Recreate all of Phase 1 from code, in two environments | CloudFormation docs, CDK Workshop, Terraform AWS tutorials |
| 4. CI/CD | 12–15 | 56–75 | Push to main → tests → build image → deploy to dev → approve → prod | Getting Started with DevOps on AWS, CodePipeline docs, GitHub Actions docs |
| 5. Orchestration & serverless | 16–19 | 76–95 | Run the app on ECS Fargate behind an ALB, plus one Lambda-based service | ECS Workshop, Serverless Land, EKS Workshop (intro) |
| 6. Observability, security, cost | 20–23 | 96–115 | Dashboards, alarms, tracing, least-privilege IAM, a cost review | One Observability Workshop, Well-Architected Framework |
| Capstone | 24+ | 116–120+ | One-command deploy of a multi-env app with blue/green releases | Your repo + DevOps Engineer Learning Plan |

---

## Phase 1 — Cloud & AWS foundations (weeks 1–4)

**Goal:** understand the building blocks every deployment sits on — identity, networking, compute, storage — well enough to draw any architecture on paper. Enroll on AWS Skill Builder (free tier) in *AWS Cloud Practitioner Essentials* and *AWS Cloud Quest: Cloud Practitioner*, which is free with a Skill Builder login.

### Week 1 — Account, security, mental model

- [x] Day 1 — Create the AWS account (Free plan, new experience), register 2 MFA devices on your Builder ID, create the GitHub repo and `devops-journal.md`.
- [x] Day 2 — 💰 Create a $5 AWS Budget alert (credits excluded), check credit usage in settings.aws.com → Billing, explore AWS Settings (settings.aws.com: Projects, Team, Billing), install the AWS CLI v2, sign in with `aws login`, and run `aws sts get-caller-identity`. Journal: what do projects and the Builder ID replace from the classic root-user + IAM setup?
- [ ] Day 3 — Cloud Practitioner Essentials: cloud concepts, Regions, Availability Zones, shared responsibility model. 💰 Optional: send one prompt in the Amazon Bedrock playground.
- [ ] Day 4 — Cloud Practitioner Essentials: compute module (EC2, instance types, Auto Scaling, ELB).
- [ ] Day 5 — Cloud Quest assignment 1–2. Journal: your project runs in `us-east-2` (Ohio). If you could choose, which Region would you pick and why (latency to Medellín vs. service availability vs. price)?

### Week 2 — Identity and networking

- [ ] Day 6 — IAM deep dive: users vs. roles vs. policies; read one AWS managed policy JSON line by line.
- [ ] Day 7 — Write your own least-privilege policy that allows read-only on one S3 bucket; test it with the IAM Policy Simulator.
- [ ] Day 8 — Cloud Practitioner Essentials: networking (VPC, subnets, route tables, internet gateway, security groups vs. NACLs).
- [ ] Day 9 — Build a VPC by hand in the console: 2 public + 2 private subnets across 2 AZs. Draw it in your journal. **Don't create a NAT gateway** (~$32/month); if you did, delete it today.
- [ ] Day 10 — Cloud Quest assignments 3–4.

### Week 3 — Compute and storage

- [ ] Day 11 — 💰 Launch a free-tier-eligible t-family EC2 instance in a public subnet; connect with Session Manager (no SSH keys, no port 22).
- [ ] Day 12 — Attach an IAM role to the instance so it can read your S3 bucket with no stored keys. This is the single most important DevOps security pattern.
- [ ] Day 13 — S3: storage classes, versioning, lifecycle rules, bucket policies; host a static page.
- [ ] Day 14 — Databases overview: RDS vs. Aurora vs. DynamoDB; when each fits.
- [ ] Day 15 — Cloud Quest assignments 5–6. Terminate everything from this week.

### Week 4 — Putting it together

- [ ] Day 16 — Application Load Balancer (burns credits while running — finish Day 17 the next day, then tear down) + Auto Scaling group of 2 instances running a simple web server (user data script).
- [ ] Day 17 — Kill one instance and watch Auto Scaling replace it. Journal what happened and how long it took.
- [ ] Day 18 — Billing: Cost Explorer, tags, the pricing calculator; estimate what Day 16's setup costs per month, and check how many credits it actually used.
- [ ] Day 19 — Cloud Quest assignments 7–8; finish Cloud Practitioner Essentials.
- [ ] Day 20 — Checkpoint: from memory, draw a 2-AZ web app architecture and explain every arrow. Tear down all resources.

Keep going with the remaining Cloud Quest assignments on weekends; finishing all 12 earns a badge. Optional: the free *Introduction to AWS Cloud: Builder Labs* learning plan has 10 hands-on labs.

---

## Phase 2 — Linux, Git & containers (weeks 5–7)

**Goal:** package your own app so it runs the same on your laptop, in CI and on AWS. Pick one small app you already know (an API with one endpoint and a health check is ideal) — it becomes the app you deploy for the rest of the plan.

### Week 5 — Shell and Git fluency

- [ ] Day 21 — Linux essentials on your EC2 box or locally: processes, systemd, permissions, journalctl, environment variables.
- [ ] Day 22 — Bash scripting: write `healthcheck.sh` that curls your app and exits non-zero on failure.
- [ ] Day 23 — Networking from the shell: dig, `curl -v`, ss, ports, DNS resolution, TLS basics.
- [ ] Day 24 — Git for teams: trunk-based development, branches, rebasing, pull requests, tags for releases.
- [ ] Day 25 — Add a Makefile (or npm scripts) with test, build, run targets to your app. CI will call these later.

### Week 6 — Docker

- [ ] Day 26 — Containers vs. VMs; images, layers, registries. Follow Docker's official Get Started guide.
- [ ] Day 27 — Write a Dockerfile for your app; get it running locally.
- [ ] Day 28 — Make it production-grade: multi-stage build, non-root user, `.dockerignore`, pinned base image. Compare image sizes before and after.
- [ ] Day 29 — Configuration the 12-factor way: env vars for config, logs to stdout, a `/health` endpoint.
- [ ] Day 30 — `docker compose` with your app + a database; understand container networking and volumes.

### Week 7 — Containers on AWS

- [ ] Day 31 — Create an Amazon ECR repository; authenticate and push your image with the CLI.
- [ ] Day 32 — Turn on ECR image scanning and a lifecycle policy that keeps the last 10 images. Read the scan results.
- [ ] Day 33 — Run your container on an EC2 instance pulling from ECR via its IAM role (no keys).
- [ ] Day 34 — Secrets: store the DB password in AWS Secrets Manager or SSM Parameter Store and read it at startup. Journal: when would you pick each?
- [ ] Day 35 — Checkpoint: a teammate (or future you) can clone the repo and run the app with one command. Tear down EC2.

---

## Phase 3 — Infrastructure as Code (weeks 8–11)

**Goal:** nothing in your account exists unless it is in Git. You will learn CloudFormation (what every AWS tool compiles to), then CDK (AWS-native, in a language you already code in), then Terraform (multi-cloud and the most common in job posts). Use the CDK Workshop and HashiCorp's free Terraform AWS tutorials.

### Week 8 — CloudFormation

- [ ] Day 36 — Templates, stacks, parameters, outputs, intrinsic functions. Deploy a template with one S3 bucket.
- [ ] Day 37 — Write a template for your Phase 1 VPC (2 public + 2 private subnets).
- [ ] Day 38 — Change sets and drift detection: edit a resource in the console, then detect the drift.
- [ ] Day 39 — Nested stacks vs. cross-stack exports; split network and app into two stacks.
- [ ] Day 40 — Stack policies, `DeletionPolicy: Retain`, rollback triggers. Delete everything with one command.

### Week 9 — AWS CDK

- [ ] Day 41 — CDK Workshop: setup, `cdk init`, `cdk bootstrap`, first stack (pick TypeScript or Python).
- [ ] Day 42 — CDK Workshop: Lambda + API Gateway "Hello CDK". Run `cdk synth` and read the generated CloudFormation.
- [ ] Day 43 — CDK Workshop: writing your own construct.
- [ ] Day 44 — CDK Workshop: testing constructs (assertion and snapshot tests).
- [ ] Day 45 — Rebuild your VPC + ECR repo in CDK. Compare lines of code against the CloudFormation version.

### Week 10 — Terraform

- [ ] Day 46 — Terraform AWS tutorial: install, init / plan / apply / destroy.
- [ ] Day 47 — Variables, outputs, tfvars, data sources.
- [ ] Day 48 — Remote state in S3 with state locking; understand why local state breaks teams.
- [ ] Day 49 — Modules: use the community VPC module, then write a small module of your own.
- [ ] Day 50 — `terraform import` an existing resource; run fmt, validate and a linter such as tflint.

### Week 11 — Multi-environment design

- [ ] Day 51 — Pick one tool (CDK or Terraform) for the rest of the plan and write down why.
- [ ] Day 52 — Parameterize for dev and prod environments (different sizes, same code).
- [ ] Day 53 — Tagging standard (env, owner, app, cost-center) enforced in code.
- [ ] Day 54 — Policy-as-code basics: run cfn-lint or checkov against your templates and fix findings.
- [ ] Day 55 — Checkpoint: destroy and recreate dev from scratch in under 15 minutes.

---

## Phase 4 — CI/CD (weeks 12–15)

**Goal:** a push to main reaches production safely with no human touching the console. Start with the free Skill Builder course *Getting Started with DevOps on AWS*, part of the AWS DevOps Engineering learning plan. You will build the pipeline twice — once AWS-native, once with GitHub Actions — because real teams use both.

### Week 12 — Concepts and CI

- [ ] Day 56 — Getting Started with DevOps on AWS: CI vs. continuous delivery vs. continuous deployment.
- [ ] Day 57 — Finish the course. Journal: what your team does today vs. what the course describes.
- [ ] Day 58 — GitHub Actions basics: a workflow that runs `make test` on every pull request.
- [ ] Day 59 — Add lint, unit tests and a Docker build to the workflow; cache dependencies.
- [ ] Day 60 — Branch protection: require the check to pass before merge.

### Week 13 — Secure AWS access from CI

- [ ] Day 61 — Read GitHub's guide to OIDC in AWS: it lets workflows reach AWS without long-lived secrets.
- [ ] Day 62 — Create the GitHub OIDC identity provider and a deploy role in IaC, scoped to your repo and main branch.
- [ ] Day 63 — Use `aws-actions/configure-aws-credentials` to push your image to ECR from the workflow.
- [ ] Day 64 — Tag images with the Git SHA, never `latest`. Journal: why this makes rollbacks trivial.
- [ ] Day 65 — Add an IaC plan / `cdk diff` step that comments on pull requests.

### Week 14 — AWS-native pipeline

- [ ] Day 66 — AWS CodeBuild: write a `buildspec.yml` that tests and builds your image.
- [ ] Day 67 — AWS CodePipeline: source (GitHub connection) → build → deploy to dev.
- [ ] Day 68 — Add a manual approval stage before prod.
- [ ] Day 69 — Define the whole pipeline in IaC (CDK Pipelines or Terraform).
- [ ] Day 70 — Journal: GitHub Actions vs. CodePipeline — when would you pick each? Delete the one you won't keep.

### Week 15 — Release strategies

- [ ] Day 71 — Deployment strategies: rolling, blue/green, canary, feature flags. Which failure does each protect against?
- [ ] Day 72 — AWS CodeDeploy concepts: deployment groups, lifecycle hooks, automatic rollback on alarm.
- [ ] Day 73 — Add a post-deploy smoke test (your `healthcheck.sh`) that fails the pipeline.
- [ ] Day 74 — Practice a rollback: ship a broken build to dev and recover by redeploying the previous SHA.
- [ ] Day 75 — Checkpoint: merge a PR and watch it reach dev automatically and prod after one approval.

---

## Phase 5 — Orchestration & serverless (weeks 16–19)

**Goal:** run real services the way most AWS teams do. ECS on Fargate is the default for containers on AWS; Lambda for event-driven pieces; EKS only when Kubernetes is a requirement. Free resources: ECS Workshop, Serverless Land, EKS Workshop. **EKS clusters bill by the hour — always destroy them the same day.**

### Week 16 — ECS on Fargate

- [ ] Day 76 — ECS concepts: clusters, task definitions, services, Fargate vs. EC2 launch type.
- [ ] Day 77 — Deploy your app as an ECS service on Fargate behind an ALB, in private subnets, via IaC.
- [ ] Day 78 — Task roles vs. execution roles; inject secrets from Secrets Manager into the task.
- [ ] Day 79 — Service auto scaling on CPU and on ALB request count; load-test with a small tool like `hey`.
- [ ] Day 80 — Wire your Phase 4 pipeline to deploy new image SHAs to ECS.

### Week 17 — Production-grade ECS

- [ ] Day 81 — Blue/green deployments for ECS with CodeDeploy (or ECS native blue/green); test automatic rollback.
- [ ] Day 82 — 💰 Add a managed database (RDS or Aurora Serverless) in private subnets; security group references only.
- [ ] Day 83 — DNS and TLS: read how Route 53 + ACM work; use the ALB's DNS name instead of buying a domain (domain registration isn't covered by credits).
- [ ] Day 84 — Cost check: NAT gateway vs. VPC endpoints for ECR/S3. Journal the monthly difference.
- [ ] Day 85 — Mini-checkpoint: the full app runs in dev and prod, deployed only by the pipeline.

### Week 18 — Serverless

- [ ] Day 86 — Lambda fundamentals: handlers, cold starts, memory/CPU, concurrency, IAM execution role.
- [ ] Day 87 — 💰 Build an event-driven side service: S3 upload → Lambda → DynamoDB.
- [ ] Day 88 — Decoupling: SQS queue with a dead-letter queue between two services; EventBridge for events.
- [ ] Day 89 — Step Functions for a small multi-step workflow with retries.
- [ ] Day 90 — Journal: containers vs. Lambda for your app — traffic pattern, runtime limits, cost at 1k and 1M requests/day.

### Week 19 — Kubernetes on AWS (intro)

- [ ] Day 91 — Kubernetes core objects locally first (kind or minikube): pods, deployments, services.
- [ ] Day 92 — EKS Workshop: cluster setup and deploying the sample app. EKS bills per hour (control plane + nodes): create and destroy in the same session. If EKS isn't available on the Free plan, do Days 92–93 on kind / minikube.
- [ ] Day 93 — EKS Workshop: IAM roles for service accounts / Pod Identity, and the load balancer controller.
- [ ] Day 94 — Helm basics: package your app as a chart.
- [ ] Day 95 — Journal: ECS vs. EKS — what complexity you'd take on with EKS and when it's worth it.

---

## Phase 6 — Observability, security, reliability & cost (weeks 20–23)

**Goal:** run what you built — know when it breaks, why, who can touch it, and what it costs. This is the difference between deploying and managing complex deployments. Free resources: the One Observability Workshop on AWS Workshops and the AWS Well-Architected Framework.

### Week 20 — Observability

- [ ] Day 96 — The three signals: metrics, logs, traces. Define 2 SLIs for your app (availability, p95 latency) and an SLO for each.
- [ ] Day 97 — CloudWatch Logs: structured JSON logging; query with Logs Insights.
- [ ] Day 98 — CloudWatch metrics and alarms on your SLIs, notifying an SNS topic to your email.
- [ ] Day 99 — A CloudWatch dashboard in IaC: request rate, errors, latency, saturation.
- [ ] Day 100 — Distributed tracing with AWS X-Ray or OpenTelemetry (ADOT) across ECS → Lambda.

### Week 21 — Security

- [ ] Day 101 — Turn on a CloudTrail trail (not an org trail — that needs Organizations), AWS Config and GuardDuty. Note what each costs in credits; turn Config and GuardDuty off the same day if they're burning credits.
- [ ] Day 102 — Least privilege: use each role's **Last accessed** tab in IAM to find and remove unused permissions from your deploy and task roles. (IAM Access Analyzer isn't part of the new AWS experience — read how it automates this.)
- [ ] Day 103 — Encryption: KMS keys, S3 default encryption, RDS encryption, secrets rotation.
- [ ] Day 104 — Shift-left: add container image scanning and IaC scanning gates to the pipeline.
- [ ] Day 105 — Multi-account basics: read about AWS Organizations, OUs and SCPs, but **don't create an Organization** (it upgrades the account to Paid, irreversibly). Practice the idea with a second **project** (`dev` vs. `prod`): each project is its own AWS account with isolated resources.

### Week 22 — Reliability and operations

- [ ] Day 106 — Read the Reliability pillar. Map your app: what happens if one AZ fails?
- [ ] Day 107 — Backups: AWS Backup plan for the database; test a restore into dev.
- [ ] Day 108 — Chaos test: stop tasks or block a dependency (AWS Fault Injection Service or manually) and watch alarms fire.
- [ ] Day 109 — Systems Manager: Run Command, Parameter Store, Automation runbooks for a common fix.
- [ ] Day 110 — Write a runbook and a blameless postmortem for the Day 108 incident.

### Week 23 — Cost and review

- [ ] Day 111 — Cost allocation tags, Cost Explorer by tag, a Budget per environment / project. How many credits has the whole plan used so far?
- [ ] Day 112 — Right-sizing: Compute Optimizer, Fargate Spot, Graviton (ARM) images. Savings Plans and Reserved Instances aren't available on the Free plan — learn the concepts only (they're on the exams).
- [ ] Day 113 — Scheduled scale-to-zero for dev outside working hours.
- [ ] Day 114 — Run the Well-Architected Tool review on your workload; list the top 5 risks.
- [ ] Day 115 — Checkpoint: fix the top 2 risks from the review.

---

## Capstone and certification path (week 24 onward)

The capstone proves you can manage a complex deployment end to end; the certifications make it legible to employers.

### Week 24 — Capstone

- [ ] Day 116 — Write `ARCHITECTURE.md`: diagram, every service used, and the reason for each choice.
- [ ] Day 117 — Clean-room test: from an empty project, one pipeline run creates dev and prod.
- [ ] Day 118 — Release a feature with blue/green; trigger and verify an automatic rollback.
- [ ] Day 119 — Write the README as a portfolio piece: what it does, how to run it, what you'd improve.
- [ ] Day 120 — Destroy everything with one command. Decide before the Free plan ends (≈ May 3, 2027): let it close (90 days to recover), or upgrade to Paid and immediately set a project spend limit.

### Certification path

All prep below is free on Skill Builder; exams themselves are paid.

1. **AWS Certified Developer – Associate (DVA-C02)** — closest to your current role; prep with Skill Builder's free exam-prep plan in weeks 25–30.
2. **AWS Certified CloudOps Engineer – Associate (SOA-C03)** — the operations side; much of Phase 6 maps to it.
3. **AWS Certified DevOps Engineer – Professional (DOP-C02)** — the target; follow the free DevOps Engineer Learning Plan on Skill Builder. It is usually taken after the two associate certifications.

Skill Builder's 4-step exam plans include free practice question sets and Domain Review courses. AWS microcredentials — hands-on skill assessments — are also free to everyone since April 2026, a good proof of skill between certifications.

After week 24, keep the 45-minute habit with a rotation: Monday read one AWS architecture blog post, Tuesday–Thursday exam prep, Friday improve the capstone.

---

## Choosing services with reason

Most AWS decisions come down to how much you want to operate yourself versus hand to AWS. Default to the most managed option that meets the requirement, and move down a row only for a concrete reason. Add your own rows as you learn.

| Decision | Default choice | Pick the alternative when… |
|---|---|---|
| Run a container | ECS on Fargate | EKS: you need Kubernetes portability or its ecosystem. EC2: you need GPUs or host-level control. |
| Run code on events | Lambda | Containers: runs over 15 minutes, steady high traffic, or heavy dependencies. |
| Infrastructure as Code | CDK (AWS-only team) or Terraform (multi-cloud or existing use) | Raw CloudFormation: you need the simplest, most auditable template. |
| CI/CD | GitHub Actions + OIDC (code on GitHub) | CodePipeline: everything must stay inside AWS, or you want CodeDeploy integration. |
| Relational database | Aurora Serverless or RDS | DynamoDB: key-value access patterns at huge scale with no joins. |
| Secrets | Secrets Manager (rotation needed) | SSM Parameter Store: plain config or secrets without rotation, at lower cost. |
| Async messaging | SQS (one consumer, work queue) | SNS: fan-out to many. EventBridge: routing by event content or SaaS events. |
| Private access to AWS APIs | VPC endpoints | NAT gateway: you need general internet egress. |
| Release strategy | Rolling (dev) / blue-green (prod) | Canary: high traffic where a small percentage exposes bugs fast. |

## Free resource directory

Everything below is free. Skill Builder's free tier offers 600+ self-paced courses and learning plans; paid extras like Builder Labs and most Cloud Quest roles need a subscription, which this plan does not require.

| Resource | Used in | Link |
|---|---|---|
| AWS Skill Builder (Cloud Practitioner Essentials, DevOps learning plans, exam prep) | Phases 1, 4, certs | [skillbuilder.aws](https://skillbuilder.aws) |
| AWS Cloud Quest: Cloud Practitioner | Phase 1 | AWS |
| AWS CDK Workshop | Phase 3 | [cdkworkshop.com](https://cdkworkshop.com) |
| Terraform AWS Get Started tutorials | Phase 3 | [developer.hashicorp.com](https://developer.hashicorp.com/terraform/tutorials/aws-get-started) |
| GitHub Actions: OIDC in AWS | Phase 4 | [docs.github.com](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) |
| configure-aws-credentials action | Phase 4 | [GitHub](https://github.com/aws-actions/configure-aws-credentials) |
| ECS Workshop | Phase 5 | [ecsworkshop.com](https://ecsworkshop.com) |
| Serverless Land | Phase 5 | [serverlessland.com](https://serverlessland.com) |
| EKS Workshop | Phase 5 | [eksworkshop.com](https://eksworkshop.com) |
| AWS Workshops catalog (One Observability and more) | Phase 6 | [workshops.aws](https://workshops.aws) |
| AWS Well-Architected Framework | Phase 6 | [aws.amazon.com](https://aws.amazon.com/architecture/well-architected/) |
| AWS Free Tier guide for new accounts | Setup | AWS Builder Center |

## Sources

- Everything you need to know to get started with AWS Free Tier — AWS Builder Center
- AWS Training and Certification: March 2026 new offerings
- AWS Training and Certification: April 2026 new offerings
- Develop your cloud skills with AWS Cloud Quest
- DevOps Engineer Learning Plan — AWS
- AWS DevOps Engineering Learning Plan overview — Telerik
- Introduction to AWS Cloud: Builder Labs learning plan — DEV Community
