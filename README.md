# 開発環境用 CloudFormation テンプレート

このリポジトリには、AWS CloudFormation を使用して開発環境を迅速にセットアップするためのテンプレートが含まれています。

## テンプレートの概要

`dev-environment.yaml` テンプレートは以下のリソースを作成します：

- **VPC** - 開発環境用の仮想プライベートクラウド
- **パブリックサブネット** - EC2インスタンスを配置するためのサブネット
- **インターネットゲートウェイ** - VPCからインターネットへの接続を提供
- **ルートテーブル** - ネットワークトラフィックの経路を定義
- **セキュリティグループ** - EC2インスタンスへのSSHアクセスを許可
- **EC2インスタンス** - 開発作業用のコンピューティングリソース

## 使用方法

### 前提条件

- AWS CLIがインストールされていること
- AWS認証情報が設定されていること
- EC2インスタンスへのSSHアクセス用のキーペアが作成されていること

### デプロイ手順

1. AWS CLIを使用してスタックを作成します：

```bash
aws cloudformation create-stack \
  --stack-name dev-environment \
  --template-body file://dev-environment.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=YOUR_KEY_PAIR_NAME
```

2. スタックの作成状況を確認します：

```bash
aws cloudformation describe-stacks --stack-name dev-environment
```

3. スタックの出力値を取得します（EC2インスタンスのパブリックIPなど）：

```bash
aws cloudformation describe-stacks --stack-name dev-environment --query "Stacks[0].Outputs"
```

### カスタマイズ

テンプレートには以下のパラメータがあり、デプロイ時にカスタマイズできます：

- `EnvironmentName` - リソース名のプレフィックス（デフォルト: Dev）
- `VpcCIDR` - VPCのCIDRブロック（デフォルト: 10.0.0.0/16）
- `PublicSubnetCIDR` - パブリックサブネットのCIDRブロック（デフォルト: 10.0.1.0/24）
- `InstanceType` - EC2インスタンスタイプ（デフォルト: t2.micro）
- `KeyName` - EC2インスタンスへのSSHアクセス用のキーペア名
- `SSHLocation` - SSHアクセスを許可するIPアドレス範囲（デフォルト: 0.0.0.0/0）

## セキュリティに関する注意

- 本番環境では、`SSHLocation`パラメータを特定のIPアドレスまたはCIDR範囲に制限することをお勧めします。
- 必要に応じて、セキュリティグループのルールを追加または変更してください。
- インスタンスタイプは開発目的に合わせて選択してください。