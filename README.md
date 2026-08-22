# TeploTEC Installation OS

Rails application for planning and operating TeploTEC geothermal installation projects.

## Stack

- Rails 8.1
- PostgreSQL 18
- Inertia.js + React 19 + TypeScript
- Tailwind CSS 4
- ReUI.io Gantt
- Solid Cache, Solid Queue, and Solid Cable

The project started from the Inertia Rails React Starter Kit. The starter auth, application shell, settings, and deployment foundation are intentionally retained; the previous hiring/ATS domain has been removed.

## Domain

The first vertical slice centers on one shared task model:

- `Organization`
- `Project`
- `Task`
- `TaskDependency`
- `ProjectEvent`
- `ProcessTemplate` and step/dependency templates
- `KnowledgeEntity`, translations, and `SemanticLink`

Dashboard, Today, List, Kanban, ReUI Gantt, Timeline, and Graph are different projections of the same project/task data. Gantt is not a second scheduling database.

## Local setup

```bash
docker compose up -d db
bin/setup
```

Open http://localhost:3000.

PostgreSQL runs on `localhost:5433` with development defaults:

```text
database: teplotec_development
user:     teplotec
password: teplotec_development
```

If this checkout previously used the old `hire_do` Docker volume, recreate the local database once:

```bash
docker compose down -v
docker compose up -d db
bin/setup
```

Development seeds create a TeploTEC workspace, a geothermal demo project, and a small installation schedule. Defaults can be overridden with `SEED_ADMIN_EMAIL` and `SEED_ADMIN_PASSWORD`.

## Database security

Organization-owned domain tables use PostgreSQL row-level-security policies keyed by `app.current_organization`. Rails uses `db/structure.sql` as the canonical schema format because RLS policies are not represented by `schema.rb`.

Local Docker and CI currently run with the database owner for simplicity. A restricted `NOBYPASSRLS` runtime role should be added before production deployment so RLS is exercised as a hard database boundary rather than only as application structure.

## Production

Production keeps separate database URLs for the primary app, Solid Cache, Solid Queue, and Solid Cable:

```text
DATABASE_URL
CACHE_DATABASE_URL
QUEUE_DATABASE_URL
CABLE_DATABASE_URL
```

They may point to separate databases on the same PostgreSQL server.

## License

MIT. See [LICENSE](LICENSE).
