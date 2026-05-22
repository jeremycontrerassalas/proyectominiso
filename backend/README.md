# Retail Products Backend (NestJS)

Contains a minimal NestJS + TypeORM backend that connects to Railway MySQL.

SQL to create the table if you prefer migrations instead of `synchronize`:

```sql
CREATE TABLE products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

Run locally (option A: connect to Railway/Supabase/Postgres; option B: use local Postgres via Docker)

Option A — Connect to Railway MySQL

1. copy `.env.example` to `.env`
2. If Railway gives you `MYSQL_URL`, paste it there
3. If you prefer separate values, set `MYSQLHOST`, `MYSQLPORT`, `MYSQLUSER`, `MYSQLPASSWORD`, and `MYSQLDATABASE`
4. npm install
5. npm run start:dev

Option B — Run a local Postgres with Docker Compose and use it for development

1. Ensure Docker is running.
2. Start local Postgres:

```bash
cd backend
docker compose up -d
```

3. Create `.env` with the following values (example):

```
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=products_db
PORT=3000
```

4. Install and run the server:

```bash
npm install
npm run start:dev
```

The server will be available at `http://localhost:3000`.

## Railway deploy

If you deploy this repository as a monorepo, set the Railway service root directory to `backend`.

Recommended Railway settings for the backend service:

- Root directory: `backend`
- Build command: `npm run build`
- Start command: `npm run start`

The backend folder also includes `railway.json`, so Railway can read the build and start commands from the app code once the service root points to `backend`.
