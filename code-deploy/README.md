# AWS Code Deploy

본 문서는 Github Actions와 AWS Code Deploy를 이용하여 CI/CD 파이프라인을 구축하는 방법에 대해 설명합니다.

## 배포 과정

1. Git Repository에 코드가 Merge되면 Github Actions가 실행됩니다.
2. Repository에 있는 코드를 압축하여 S3에 업로드합니다.
3. appspec.yml 파일을 참조하여 Code Deploy를 통해 EC2 인스턴스에 배포합니다.