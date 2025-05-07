#!/usr/bin/env sh

if [ $# -ne 2 ]; then
  echo "Usage: $0 <code> <platform_version>"
  exit 1
fi

code="$1"
platform_version="$2"
url="https://www.odoo.com/zh_CN/thanks/download?code=${code}&platform_version=${platform_version}"
echo "> The download is starting from ${url}" >&2

download_url=$(curl -L "${url}" | sed -n "s/.*<a[^>]*href='\([^']*\)[^>]*class='start_download'.*/\1/p")
echo "> The download url is ${download_url}" >&2

encoded_filename=$(curl -sI "${download_url}" | grep -i '^content-disposition:' | sed "s/.*filename\*=[^']*''//")
decoded_filename=$(printf '%s' "$encoded_filename" | perl -pe 's/%([0-9A-Fa-f]{2})/chr(hex($1))/ge')
echo "> The file will be saved as ${decoded_filename}" >&2

curl -L -o "${decoded_filename}" "${download_url}"

echo "${decoded_filename}"
