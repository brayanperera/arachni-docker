#!/bin/bash

PATH_ARACHNI="/usr/local/arachni"
FILE_DB_PGSQL_TEMPLATE="${PATH_ARACHNI}/.system/arachni-ui-web/config/database.yml.pgsql"
FILE_DB="${PATH_ARACHNI}/.system/arachni-ui-web/config/database.yml"

setupPostgresqlDB()
{
  sed -i 's|\[DB_HOST\]|'${DB_HOST}'|' ${FILE_DB_PGSQL_TEMPLATE}
  sed -i 's|\[DB_NAME\]|'${DB_NAME}'|' ${FILE_DB_PGSQL_TEMPLATE}
  sed -i 's|\[DB_USER\]|'${DB_USER}'|' ${FILE_DB_PGSQL_TEMPLATE}
  sed -i 's|\[DB_PASS\]|'${DB_PASS}'|' ${FILE_DB_PGSQL_TEMPLATE}
  rm ${FILE_DB}
  mv ${FILE_DB_PGSQL_TEMPLATE} ${FILE_DB}

  ${PATH_ARACHNI}/bin/arachni_web_task db:setup
}


print_usage()
{
  echo "Usage: $0 <URL> <Report_Name> <Exclude_URL_Pattern> <Login_Required true|false>"
  echo "  <Login URL | If Login_Required true> <Login Params> <Logon Check Pattern>"
}

if [ "postgresql" = "${DB_ADAPTER}" ]; then
  setupPostgresqlDB
fi

if [[ -z $1 ]]; then
  cd $PATH_ARACHNI
  bin/arachni_web
else

  if [[ -z $4 ]]; then
    print_usage
    exit 1
  fi

  url=$1
  report_name=$2
  exclude_pattern=$3
  login_required=$4

  if [[ "$login_required" == "true" ]]; then
    if [[ -z $5 ]]; then
      print_usage
      exit 1
    fi

    login_url=$5
    login_params=$6
    login_check=$7
    cd $PATH_ARACHNI
    bin\arachni ${url} --plugin=autologin:url=${login_url},parameters="${login_params}",check="${login_check}" \
    --scope-exclude-pattern=${exclude_pattern}  --audit-links --audit-forms --audit-cookies --audit-nested-cookies \
    --audit-headers --audit-jsons --audit-xmls --audit-ui-forms --report-save-path reports

  else
    cd $PATH_ARACHNI
    bin\arachni ${url} --scope-exclude-pattern=${exclude_pattern}  --audit-links --audit-forms \
    --audit-cookies --audit-nested-cookies --audit-headers --audit-jsons --audit-xmls --audit-ui-forms \
    --report-save-path reports
  fi

fi



