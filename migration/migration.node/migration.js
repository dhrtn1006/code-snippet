import dotenv from 'dotenv';
import mysql from 'mysql';
import pg from 'pg';
import cliProgress from 'cli-progress';
import { migrateDomain } from './migrations/domain.js';

dotenv.config();
const { Pool } = pg;
let postgresClient = null;

// MariaDB 연결 설정
const mariadbConnection = mysql.createConnection({
    host: process.env.MARIADB_HOST,
    user: process.env.MARIADB_USER,
    password: process.env.MARIADB_PASSWORD,
    database: process.env.MARIADB_DATABASE,
});

// PostgreSQL 연결 설정
const postgresPool = new Pool({
    host: process.env.POSTGRES_HOST,
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DBNAME,
    idleTimeoutMillis: 0
});

async function migrate() {
    try {
        mariadbConnection.connect();
        postgresClient = await postgresPool.connect();

        // 마이그레이션 함수 호출
        await migrateDomain(mariadbConnection, postgresClient, cliProgress);
    } catch (e) {
        console.error(`Connection error occurred: ${e.message}`);
    } finally {
        mariadbConnection.end();
        if (postgresClient) postgresClient.release();
    }
}

migrate();