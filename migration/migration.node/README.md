## 로컬 환경 구성

### Node 버전

```bash
node -v
# v21.2.0

npm -v
# 10.2.3
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
npm install
```

### 마이그레이션 실행

```bash
npm run start
```

## 마이그레이션 추가

migrations 디렉터리 내부에 마이그레이션 파일 추가 후 migration.js 파일에 import 하여 마이그레이션을 추가 할 수 있습니다.

다음은 product 테이블의 마이그레이션을 추가하는 예시입니다.

```js
// migrations/product.js

export async function migrateProduct(mariadbConnection, postgresClient, cliProgress) {
    try {
        const progressBar = new cliProgress.MultiBar({
            format: ' {bar} | {percentage}% | DURATION: {duration}s | {value}/{total} | {name}',
        }, cliProgress.Presets.shades_classic);

        await postgresClient.query('BEGIN');

        // MariaDB에서 데이터 읽기
        mariadbConnection.query(
            `SELECT * FROM product`,
            async (error, rows) => {
                if (error) throw error;
                const bar = progressBar.create(rows.length, 0);
                bar.update({name: "Product"});

                try {
                    // PostgreSQL로 데이터 쓰기
                    for (let row of rows) {
                        await postgresClient.query(
                            `INSERT INTO product (column_1, column_2, column_3) VALUES ($1, $2, $3)`,
                            ...Object.values(row)
                        );
                        
                        bar.increment();
                    }
                    progressBar.stop();
                } catch (e) {
                    console.error(`Postgres Insert error occurred: ${e.message}`);
                    await postgresClient.query('ROLLBACK');
                }
            }
        );

        await postgresClient.query('COMMIT');
    } catch (e) {
        console.error(`MariaDB Read error occurred: ${e.message}`);
        await postgresClient.query('ROLLBACK');
    }
}
```

```js
// migration.js

import { migrateProduct } from './migrations/product.js'; // 마이그레이션 파일 import

...

    try {
        mariadbConnection.connect();
        postgresClient = await postgresPool.connect();

        // 마이그레이션 함수 호출
        await migrateProduct(mariadbConnection, postgresClient, cliProgress);
    } catch (e) {
        console.error(`Connection error occurred: ${e.message}`);
    } finally {
        mariadbConnection.end();
        if (postgresClient) postgresClient.release();
    }

...
```