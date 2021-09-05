# GitHub Action to deploy MkDocs site to Tencent Cos
![GitHub Badge](https://github.com/aschenmaker/mkdocs-deploy-tencentcos/actions/workflows/check.yml/badge.svg)

部署Mkdocs到腾讯云COS静态网站
## Intro
推送触发，GitHub Action进行构建，并自动推送到腾讯云COS。通过设置COS域名，实现静态网站访问。

## Example
在对应的 mkdocs git仓库中创建`.github/workflows/deploy.yml`，
```yml
name: Deploy to tencent osss
on:
  push:
    branches:
      - master

jobs:
  build:
    name: Deploy docs
    runs-on: ubuntu-latest
    steps:
      - name: Checkout main
        uses: actions/checkout@v2

      - name: Deploy to tencent osss
        uses: aschenmaker/mkdocs-deploy-tencentcos@master
        env:
          CONFIG_FILE: mkdocs.yml
          SECRET_ID: ${{ secrets.SECRET_ID }}
          SECRET_KEY: ${{ secrets.SECRET_KEY }}
          BUCKET: ${{ secrets.BUCKET }}
          REGION: ap-nanjing
```

`SECRET_ID`,`SECRET_KEY`,`BUCKET`需要设置在仓库`Settings`-`Secret`中进行配置

| 参数        | 说明                  | 是否必须 |
| ----------- | --------------------- | -------- |
| CONFIG_FILE | 配置文件位置          | 否       |
| SECRET_ID   | API密钥，腾讯云中获取 | 是       |
| SECRET_KEY  | API-key，腾讯云中获取 | 是       |
| BUCKET      | 存储桶名称            | 是       |
| REGION      | 存储桶位置            | 是       |
