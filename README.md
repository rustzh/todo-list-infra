# EKS Terraform Infrastructure

이 Terraform 코드는 AWS EKS 클러스터와 관련 인프라를 구성합니다.

## 구성 요소

### 네트워크 구성
- **VPC**: 10.0.0.0/16 CIDR
- **리전**: ap-northeast-3 (오사카)
- **퍼블릭 서브넷**: 10.0.0.0/24, 10.0.1.0/24 (ALB, NAT Gateway 배치)
- **프라이빗 서브넷**: 10.0.10.0/24, 10.0.11.0/24 (EKS 워커 노드 배치)
- **NAT Gateway**: 각 가용 영역별 배치로 고가용성 보장

### EKS 클러스터
- **Kubernetes 버전**: 1.32
- **엔드포인트**: 프라이빗, 퍼블릭 서브넷 접근 허용
- **OIDC Provider**: IRSA 지원으로 세밀한 권한 제어
- **클러스터 로깅**: 활성화

### 워커 노드
- **인스턴스 타입**: t3.medium (2 vCPU, 4GB RAM)
- **오토스케일링**: 최소 1대 ~ 최대 4대
- **스토리지**: GP3 20GB (암호화 활성화)
- **배치**: 프라이빗 서브넷에만 배치

### EKS 애드온
- **AWS EBS CSI Driver**: GP3 스토리지 지원
- **VPC CNI**: 네트워크 플러그인
- **CoreDNS**: DNS 서비스
- **Kube Proxy**: 네트워크 프록시
- **AWS Load Balancer Controller**: ALB/NLB 지원
- **External DNS**: Route53 자동 DNS 관리

## 사용 방법

### 1. 사전 준비
```bash
# AWS CLI 설정 확인
aws configure list
aws sts get-caller-identity

# kubectl 설치 확인
kubectl version --client
```

### 2. 변수 파일 설정
```bash
# 예제 파일 복사
cp terraform.tfvars.example terraform.tfvars

# 환경에 맞게 수정
vim terraform.tfvars
```

### 3. Terraform 초기화 및 배포
```bash
# Terraform 초기화
terraform init

# 포맷 확인 및 검증
terraform fmt
terraform validate

# 계획 확인
terraform plan

# 인프라 배포 (자동 승인)
terraform apply -auto-approve

# 또는 승인 프롬프트와 함께 배포
terraform apply
```

### 4. kubectl 설정 및 확인
```bash
# kubeconfig 업데이트
aws eks update-kubeconfig --region ap-northeast-3 --name div4u-eks

# 클러스터 연결 확인
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

### 5. 상태 관리
```bash
# 현재 상태 확인
terraform show
terraform state list

# 특정 리소스 상태 확인
terraform state show module.eks.aws_eks_cluster.this[0]

# 출력값 확인
terraform output
terraform output cluster_endpoint
```

### 6. 업데이트 및 변경
```bash
# 변경사항 계획 확인
terraform plan

# 특정 리소스만 업데이트
terraform apply -target=module.eks

# 변경사항 적용
terraform apply
```

### 7. 인프라 삭제
```bash
# 삭제 계획 확인
terraform plan -destroy

# 인프라 삭제
terraform destroy

# 자동 승인으로 삭제
terraform destroy -auto-approve
```

## 주요 출력값

- `cluster_name`: EKS 클러스터 이름
- `cluster_endpoint`: EKS 클러스터 엔드포인트
- `vpc_id`: VPC ID
- `route53_zone_id`: Route53 호스팅 존 ID
- `acm_certificate_arn`: ACM 인증서 ARN

## 보안 고려사항

- 워커 노드는 프라이빗 서브넷에만 배치
- 최소 권한 원칙 적용된 IAM 역할
- EBS 볼륨 암호화 활성화
- 보안 그룹으로 네트워크 접근 제어

## 리소스 보존

다음 리소스들은 `terraform destroy` 시에도 삭제되지 않습니다:
- Route53 호스팅 존 (div4u.com)
- ACM 인증서 (*.div4u.com)