import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductsModule } from './products/products.module';
import { DataSourceOptions } from 'typeorm';
import * as dotenv from 'dotenv';

dotenv.config();

const useSsl = (process.env.DB_SSL || 'false').toLowerCase() === 'true';
const databaseUrl =
  process.env.MYSQL_URL ||
  process.env.MYSQL_PUBLIC_URL ||
  process.env.DATABASE_URL;

const ormConfig: DataSourceOptions = {
  type: 'mysql',
  entities: [__dirname + '/**/*.entity{.ts,.js}'],
  synchronize: true,
  ...(databaseUrl
    ? {
        url: databaseUrl,
      }
    : {
        host: process.env.MYSQLHOST || process.env.DB_HOST || 'localhost',
        port: parseInt(process.env.MYSQLPORT || process.env.DB_PORT || '3306', 10),
        username: process.env.MYSQLUSER || process.env.DB_USER || 'root',
        password:
          process.env.MYSQLPASSWORD || process.env.DB_PASS || process.env.MYSQL_ROOT_PASSWORD || '',
        database: process.env.MYSQLDATABASE || process.env.DB_NAME || 'railway',
      }),
  // Support Railway-managed MySQL. When DB_SSL=true we'll set SSL options for secure connections.
  ...(useSsl
    ? { ssl: { rejectUnauthorized: false } }
    : {}),
};

@Module({
  imports: [TypeOrmModule.forRoot(ormConfig), ProductsModule],
})
export class AppModule {}
