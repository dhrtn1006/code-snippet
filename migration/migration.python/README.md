## 로컬 환경 구성

### Python 버전

```bash
python3 --version
# Python 3.11.6

pip3 --version
# pip 23.3.1 from /opt/homebrew/lib/python3.11/site-packages/pip (python 3.11)
```

### 환경변수 설정

|환경변수|설명|
|---|---|
|MARIADB_USER|기존 DB USER|
|MARIADB_PASSWORD|기존 DB PASSWORD|
|MARIADB_HOST|기존 DB HOST|
|MARIADB_DATABASE|기존 DB DATABASE|
|POSTGRES_USER|신규 DB USER|
|POSTGRES_PASSWORD|신규 DB PASSWORD|
|POSTGRES_HOST|신규 DB HOST|
|POSTGRES_DBNAME|신규 DB DATABASE|

### 모듈 설치

```bash
pip3 install -r requirements.txt
```

### 마이그레이션 실행

```bash
python3 migration.py
```

## 마이그레이션 추가

migrations 디렉터리 내부에 마이그레이션 파일 추가 후 migration.py 파일에 import 하여 마이그레이션을 추가 할 수 있습니다.

다음은 product 테이블의 마이그레이션을 추가하는 예시입니다.

```python
# migrations/product.py

def migrate_product(tqdm, mariadb_cursor, postgres_cursor):
    # MariaDB에서 데이터 읽기
    mariadb_cursor.execute('SELECT * FROM product')
    rows = mariadb_cursor.fetchall()

    print(f'Total Read Product rows to process: {len(rows)}')

    # 데이터 변환 로직

    # PostgreSQL로 데이터 쓰기
    for row in tqdm(rows, desc='Migrating product'):
        postgres_cursor.execute(
            'INSERT INTO product (column_1, column_2, column_3 ...) VALUES (%s, %s, %s ...)',
            row
        )
```

```python
# migration.py

from migrations.products import migrate_product # 마이그레이션 파일 import

...

mariadb_cursor = mariadb_connection.cursor()
postgres_cursor = postgres_connection.cursor()

# 마이그레이션 함수 호출
try:
    ...
    migrate_product(tqdm, mariadb_cursor, postgres_cursor) # 마이그레이션 함수 추가
    postgres_connection.commit()
except Exception as e:
    postgres_connection.rollback()
    print(f"An error occurred: {e}")

...

```