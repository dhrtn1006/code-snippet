# CronTab Backup

본 문서는 CronTab을 사용하여 주기적으로 백업을 수행하는 Shell Script를 작성하는 방법에 대해 설명합니다.

## 1. CronTab 설정
```bash
// 매일 02시
0 2 * * * sh /절대경로/DB_AUTO_BACK.sh >> /var/log/crontab/cron.log 2>&1
0 2 * * * sh /절대경로/MONGO_AUTO_BACK.sh >> /var/log/crontab/cron.log 2>&1
0 2 * * * sh /절대경로/SOURCE_AUTO_BACK.sh >> /var/log/crontab/cron.log 2>&1
```