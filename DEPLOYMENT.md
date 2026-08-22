# TeploTEC Project deployment

The application is deployed with Kamal to the existing TeploTEC Hetzner CX33 and is exposed only through Cloudflare Tunnel at:

```text
https://project.teplotec.com
```

Infrastructure for DNS, Cloudflare Access, Tunnel and the Hetzner host lives in `teplotec/infra`.

## Architecture

```text
Phone / browser
  -> Cloudflare Access
  -> Cloudflare Tunnel
  -> cloudflared on CX33
  -> 127.0.0.1:3001
  -> kamal-proxy
  -> Rails / Thruster
  -> teplotec-project-postgres on the private Kamal Docker network
```

ERPNext continues to use `127.0.0.1:8080`. Project does not expose an Internet-facing application or database port.

## Prerequisites on the deploy Mac

Install Cloudflare's client and verify the existing SSH path:

```bash
brew install cloudflared
ssh -i ~/.ssh/teplotec \
  -o 'ProxyCommand=cloudflared access ssh --hostname ssh.teplotec.com' \
  root@ssh.teplotec.com 'hostname && docker version'
```

Kamal uses the same Cloudflare Access SSH path from `config/deploy.yml`.

Docker must also be available locally because Kamal builds the application image before pushing it to GHCR.

## One-time local secrets

Create an ignored `.env.production` file. Do not commit it.

Generate the database password once and keep it stable:

```bash
DB_PASSWORD=$(openssl rand -hex 32)
cat > .env.production <<EOF
KAMAL_REGISTRY_PASSWORD=YOUR_GHCR_TOKEN
PROJECT_DB_PASSWORD=$DB_PASSWORD
EOF
chmod 600 .env.production
```

`KAMAL_REGISTRY_PASSWORD` must be able to push the initial private image to `ghcr.io/sergii/tp-installer-3f3`.

The Rails master key is read locally from `config/master.key`, which is also ignored by git.

## Infrastructure first

The `teplotec/infra` Terraform change must be applied before testing the public URL. It creates:

- `project.teplotec.com` DNS
- Cloudflare Access for trusted users
- Tunnel ingress to `127.0.0.1:3001`

It does not deploy the Rails application.

## First application deployment

From this repository and branch:

```bash
bundle install
npm ci
bin/kamal setup
```

`kamal setup` boots the PostgreSQL accessory, uploads the PostgreSQL initialization script, starts the loopback-only Kamal proxy, builds/pushes the Rails image, prepares the databases and deploys the application.

PostgreSQL 18 persists at:

```text
/opt/teplotec/project/postgresql
```

inside the Hetzner host and is mounted into `/var/lib/postgresql` in the container.

## Normal deployments

```bash
bin/kamal deploy
```

Useful commands:

```bash
bin/kamal details
bin/kamal logs
bin/kamal app logs -f
bin/kamal accessory details postgres
bin/kamal accessory logs postgres
bin/kamal console
```

## First login

Cloudflare Access protects the outer boundary. Rails authentication remains enabled inside the application.

Open `https://project.teplotec.com`, authenticate with the Cloudflare account, then create/sign in to the Rails account.

Development demo seeds are intentionally not run in production. Production demo data can be created explicitly after the first user exists.

## Repository transfer later

When this repository moves from `sergii/tp-installer-3f3` to the `teplotec` organization, the infrastructure does not need to change. Update only the Kamal image/registry coordinates and GHCR credentials as needed.
