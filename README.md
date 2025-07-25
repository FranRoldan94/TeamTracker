# 🐳 TeamTrack Microservices Environment

This repository sets up a full Docker Compose development environment for a Spring Boot-based microservices architecture, including:

- 🐘 PostgreSQL (1 per microservice: `auth`, `core`, `notification`)
- 🐇 RabbitMQ (with management UI)
- 🧠 Redis
- 🧩 pgAdmin (preconfigured)
- 🛠 Init SQL scripts for each service (run on first boot)

---

## 🚀 Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/your-org/teamtrack-infra.git
cd teamtrack-infra
```

### 2. Prepare the `.env` file

Create a `.env` file at the root:

```dotenv
# PostgreSQL credentials
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres

# Database ports (host)
AUTH_DB_PORT=5433
CORE_DB_PORT=5434
NOTIFICATION_DB_PORT=5435

# Redis
REDIS_PORT=6379

# RabbitMQ
RABBITMQ_PORT=5672
RABBITMQ_UI_PORT=15672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest

# pgAdmin
PGADMIN_CONTAINER_NAME=pgadmin_container
PGADMIN_DEFAULT_EMAIL=postgres@postgres.com
PGADMIN_DEFAULT_PASSWORD=postgres
PGADMIN_PORT=8080
```

### 3. Folder Structure

```
.
├── docker-compose.yml
├── .env
├── init-scripts/
│   ├── auth/
│   │   ├── 01-db-config.sql
│   │   └── 02-user-table.sql
│   ├── core/
│   │   └── init.sql
│   └── notification/
│       └── init.sql
└── pgadmin/
    └── servers.json
```

---

## ▶️ Run the stack

### First time / clean run:

```bash
docker compose --env-file .env down -v
docker compose --env-file .env up --build
```

> `-v` is needed to reset database volumes and run init scripts.

---

## 🛠 Services

| Service        | Host (outside container)      | Container Hostname      | Notes                         |
|----------------|-------------------------------|--------------------------|-------------------------------|
| Auth DB        | `localhost:5433`              | `postgres_auth:5432`     | Database: `auth`              |
| Core DB        | `localhost:5434`              | `postgres_core:5432`     | Database: `core`              |
| Notification DB| `localhost:5435`              | `postgres_notification:5432` | Database: `notification` |
| Redis          | `localhost:6379`              | `redis`                  |                               |
| RabbitMQ UI    | [http://localhost:15672](http://localhost:15672) | `rabbitmq`        | `guest` / `guest`             |
| pgAdmin        | [http://localhost:8080](http://localhost:8080) | `pgadmin`         | Login with configured email   |

---

## 🧠 pgAdmin Setup

`pgadmin/servers.json` automatically preloads connection info for all PostgreSQL services.

Each is grouped under **"Microservices"** in pgAdmin.

---

## 💡 Tips

- SQL scripts run **only on first boot** (empty volume). Use `docker compose down -v` to reset.
- All SQL scripts in `init-scripts/[service]/` are run **in lexicographical order**.
- Add new services by duplicating a `postgres_*` block in `docker-compose.yml` and creating corresponding scripts.

---

## 🧹 Cleanup

```bash
docker compose down -v
```

This stops and removes containers **and volumes**, forcing reinitialization on next boot.

---

## 📌 To-Do / Extensibility Ideas

- Add Kafka or MongoDB
- Wire up microservices with Spring Cloud Config / Eureka
- Add Flyway for migrations
- Use Traefik or Nginx for gateway proxying

---

## 🧑‍💻 Author

**TeamTrack / InnovaR**  
Made with ❤️ by Fran Roldán
