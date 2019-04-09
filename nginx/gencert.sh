#! /bin/bash

FILE_PREFIX=pan.itop.vip
RSA_BITS_NUM=2048
VALID_DAYS=3650

PASS_RSA=hanxianzhai
PASS_P12=hanxianzhai
PASS_JKS=hanxianzhai

CRT_ALIAS=hanxianzhai
CRT_COUNTRY_NAME=CN
CRT_PROVINCE_NAME=Beijing
CRT_CITY_NAME=Beijing
CRT_ORGANIZATION_NAME=hanxianzhai
CRT_ORGANIZATION_UNIT_NAME=hanxianzhai
CRT_DOMAIN=pan.itop.vip
CRT_EMAIL=hanxianzhai@163.com
CRT_EXTRA_CHALLENGE_PASSWD=hanxianzhai
CRT_EXTRA_OPTINAL_COMPANY_NAME=hanxianzhai

# 2.1 生成私钥
echo -e "\n----------------------------------------------------------\n生成私钥\n"
openssl genrsa -des3 -passout pass:$PASS_RSA -out $FILE_PREFIX.pem $RSA_BITS_NUM

# 2.2 除去密码口令
echo -e "\n----------------------------------------------------------\n除去密码口令\n"
openssl rsa -in $FILE_PREFIX.pem -out $FILE_PREFIX.key -passin pass:$PASS_RSA

# 2.3 生成证书请求
echo -e "\n----------------------------------------------------------\n生成证书请求\n"
openssl req -new -days $VALID_DAYS -key $FILE_PREFIX.key -out $FILE_PREFIX.csr << EOF
$CRT_COUNTRY_NAME
$CRT_PROVINCE_NAME
$CRT_CITY_NAME
$CRT_ORGANIZATION_NAME
$CRT_ORGANIZATION_UNIT_NAME
$CRT_DOMAIN
$CRT_EMAIL
$CRT_EXTRA_CHALLENGE_PASSWD
$CRT_EXTRA_OPTINAL_COMPANY_NAME
EOF

# 2.4 生成证书
echo -e "\n\n----------------------------------------------------------\n生成证书\n"
openssl x509 -req -days $VALID_DAYS -signkey $FILE_PREFIX.key -in $FILE_PREFIX.csr -out $FILE_PREFIX.crt

# 2.5 crt转为p12证书
echo -e "\n----------------------------------------------------------\ncrt转为p12证书\n"
openssl pkcs12 -export -in $FILE_PREFIX.crt -inkey $FILE_PREFIX.key -name $CRT_ALIAS -passout pass:$PASS_P12 -out $FILE_PREFIX.p12