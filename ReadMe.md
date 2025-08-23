# Sparkrock's Real-World Challenge

This repo deploys a Dockerized frontend, backend, and Nginx proxy to **AWS ECS Fargate** behind an **Application Load Balancer**, with:
- **HTTPS** via ACM and **HTTP Basic Auth** (bcrypt) at the proxy
- **IaC** via Terraform
- **CI/CD** on push to `main` using **GitHub Actions OIDC** (no static AWS keys)
- **Monitoring**: CloudWatch alarm when **CPU > 70%**, notified via SNS email

**URL:** `https://sparkrock.zakjanzi.me`  
**Basic Auth:** username `sparkrock` (bcrypt stored in Secrets Manager)



## Architecture

![Architecture diagram](./docs/images/sparkrock-assignment.png)



## Project Structure

```bash
/app
/frontend # dummy Nginx static site
/backend # dummy Node.js API
/nginx # Nginx proxy (Basic Auth + routing)
Dockerfile
nginx.conf # used in ECS
entrypoint.sh # reads bcrypt from env -> /etc/nginx/.htpasswd
nginx.local.conf # (used this for local testing; not used in ECS)
/infrastructure # Terraform (AWS)
/cicd/deploy.yml # copy of workflow for reviewers
/.github/workflows/deploy.yml # CI/CD (live)

```


## To Test

Go to https://sparkrock.zakjanzi.me

username: sparkrock

pass: sparkrock


## To Test via Curl

### Without credentials (expected: 401 Unauthorized)
curl -I https://sparkrock.zakjanzi.me

### With Basic Auth (expected: 200 OK)
curl -I -u sparkrock:sparkrock https://sparkrock.zakjanzi.me
