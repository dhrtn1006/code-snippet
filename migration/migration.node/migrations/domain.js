import Scrypt from "scrypt-kdf"

export async function migrateDomain(mariadbConnection, postgresClient, cliProgress) {
    try {
        const progressBar = new cliProgress.MultiBar({
            format: ' {bar} | {percentage}% | DURATION: {duration}s | {value}/{total} | {name}',
        }, cliProgress.Presets.shades_classic);

        await postgresClient.query('BEGIN');

        // MariaDB에서 데이터 읽기
        mariadbConnection.query(
            `SELECT * FROM domain`,
            async (error, rows) => {
                if (error) throw error;
                const bar = progressBar.create(rows.length, 0);
                bar.update({name: "Domain"});

                try {
                    // PostgreSQL로 데이터 쓰기
                    for (let row of rows) {
                        const hashPassword = await Scrypt.kdf(row.password, { logN: 1, r: 1, p: 1 });
                        await postgresClient.query(
                            `INSERT INTO domain (column_1, column_2, column_3) VALUES ($1, $2, $3)`,
                            [hashPassword.toString("base64"), ...Object.values(row).slice(1)]
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
