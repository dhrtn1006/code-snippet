def migrate_domain(mariadb_cursor, postgres_cursor, tqdm):
    # MariaDB에서 데이터 읽기
    mariadb_cursor.execute(
        '''SELECT * FROM table'''
    )
    rows = mariadb_cursor.fetchall()

    print(f'Total Read Address rows to process: {len(rows)}')

    # PostgreSQL로 데이터 쓰기
    for row in tqdm(rows, desc='Migrating Address'):
        postgres_cursor.execute(
            '''INSERT INTO table (
                column_1, 
                column_2,
                column_3
                ) VALUES (%s, %s, %s)''',
            ['uuid_' + str(row[0]), *row[1:]]
        )