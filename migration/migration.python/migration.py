import os
import mysql.connector
import psycopg2
from tqdm import tqdm
from dotenv import load_dotenv
from migrations.domain import migrate_domain

# .env 파일에서 환경 변수 로드
load_dotenv()

# MariaDB 연결 설정
mariadb_connection = mysql.connector.connect(
    user=os.getenv('MARIADB_USER'),
    password=os.getenv('MARIADB_PASSWORD'),
    host=os.getenv('MARIADB_HOST'),
    database=os.getenv('MARIADB_DATABASE')
)

# PostgreSQL 연결 설정
postgres_connection = psycopg2.connect(
    user=os.getenv('POSTGRES_USER'),
    password=os.getenv('POSTGRES_PASSWORD'),
    host=os.getenv('POSTGRES_HOST'),
    dbname=os.getenv('POSTGRES_DBNAME')
)

# Database 연결
mariadb_cursor = mariadb_connection.cursor()
postgres_cursor = postgres_connection.cursor()

# 마이그레이션 함수 호출
try:
    migrate_domain(mariadb_cursor, postgres_cursor, tqdm)
    postgres_connection.commit()
except Exception as e:
    postgres_connection.commit()
    print(f"An error occurred: {e}")

# 연결 종료
mariadb_cursor.close()
postgres_cursor.close()
mariadb_connection.close()
postgres_connection.close()