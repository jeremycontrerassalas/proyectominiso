@echo off
REM Prepare backend: copy .env.example to .env, start postgres (docker), install deps and start server
cd /d %~dp0
if not exist .env (
  copy .env.example .env
  echo Created .env from .env.example. Please edit .env with your DB credentials if needed.
)
echo Starting local Postgres via Docker Compose (if docker installed)...
docker compose up -d
echo Installing npm dependencies...
npm install
echo Starting backend (dev mode)...
npm run start:dev
pause
