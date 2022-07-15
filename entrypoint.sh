#!/usr/bin/env bash

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

if [[ "$CLI_ENABLED" == "false" ]]; then
  cd $PATH_ARACHNI
  bin/arachni_web -o 0.0.0.0
else

  if [[ "$LOGIN_ENABLED" == "true" ]]; then
    if [[ -z $LOGIN_URL ]] || [[ -z $LOGIN_PARAMS ]] || [[ -z $LOGIN_CONFIRM_PATTERN ]]; then
      print_usage
      exit 1
    fi

    cd $PATH_ARACHNI
    bin/arachni ${TARGET_URL} --plugin=autologin:url=${LOGIN_URL},parameters="${LOGIN_PARAMS}",check="${LOGIN_CONFIRM_PATTERN}" \
    --scope-exclude-pattern=${EXCLUDE_PATTERN}  --audit-links --audit-forms --audit-cookies --audit-nested-cookies \
    --audit-headers --audit-jsons --audit-xmls --audit-ui-forms --report-save-path reports

  else
    cd $PATH_ARACHNI
    bin/arachni ${TARGET_URL} --scope-exclude-pattern=${EXCLUDE_PATTERN}  --audit-links --audit-forms \
    --audit-cookies --audit-nested-cookies --audit-headers --audit-jsons --audit-xmls --audit-ui-forms \
    --report-save-path reports

    report_file=$(ls -t reports/*.afr  | head -n 1)

    bin/arachni_reporter --reporter "html:outfile=${REPORT_NAME}.zip" reports/${report_file}
  fi

fi



