# Docs & Evidence

This folder contains screenshots and artifacts demonstrating the working deployment, CI/CD, security, and monitoring.

## Screenshots

- **architecture.png**  
  High-level diagram of the stack (VPC, ALB, ECS/Fargate, ECR, ACM, Secrets Manager, CloudWatch, SNS, GitHub OIDC).

![Architecture diagram](./images/sparkrock-assignment.png)

- **01-actions-success.png**  
  GitHub Actions run for `main` showing: OIDC assume role, ECR login, image builds/pushes, and ECS service rollout succeeded.

- **02-ecr-repos.png**  
  ECR console listing three repositories: `frontend`, `backend`, `proxy` with `latest` (and/or commit SHA) tags pushed.

- **03-ecs-service.png**  
  ECS service details page with **Desired=1 / Running=1**, confirming the task is healthy on Fargate.

- **04-alb-listeners.png**  
  ALB listeners showing **HTTP :80 → HTTPS redirect** and **HTTPS :443 → target group** forwarding.

- **05-cloudwatch-alarm-ok.png**  
  CloudWatch alarm for **ECSServiceAverageCPUUtilization ≥ 70%** in **OK** state (include an additional `-alarm.png` if you triggered it).

- **06-sns-email.png**  
  Inbox screenshot of the SNS notification (test publish or actual alarm email).

- **07-site-401.png**  
  Browser or cURL showing **401 Unauthorized** at `https://sparkrock.zakjanzi.me/` (proves Basic Auth is enforced).

- **08-site-200.png**  
  After providing credentials (`sparkrock` / bcrypt in Secrets Manager), the dummy frontend loads over **HTTPS**.

- **09-acm-issued.png** 
  ACM certificate status **ISSUED** for `sparkrock.zakjanzi.me`.

- **10-cloudflare-cname.png**  
  Cloudflare DNS CNAME pointing `sparkrock.zakjanzi.me` to the ALB DNS name.


