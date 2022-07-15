# docker-arachni

## Welcome [Arachni-Docker Image](https://github.com/brayanperera/arachni-docker) 

## Environment variables
| Name  | Default | Options |
| ------------- | ------------- | ------------- |
| ARACHNI_ADMIN_PASSWORD | arachni | any |
| ARACHNI_USERNAME | arachni@example.com | any |
| ARACHNI_PASSWORD | arachni | any |
| DB_ADAPTER | sqlite | sqlite, postgresql |
| DB_HOST | {empty} | any |
| DB_NAME | {empty} | any |
| DB_USER | {empty} | any |
| DB_PASS | {empty} | any |
| CLI_ENABLED | false | false, true |
| TARGET_URL | https://google.com | any |
| EXCLUDE_PATTERN | arachni-report | any |
| REPORT_NAME | {empty} | any |
| LOGIN_ENABLED | false | false, true |
| LOGIN_URL | {empty} | any |
| LOGIN_PARAMS | {empty} | any |
| LOGIN_CONFIRM_PATTERN | {empty} | any |

## Usage Samples

### Building the Docker image

````bash
docker build -t arachni:<image_tag> .
docker tag arachni:<image_tag> brayanperera/arachni:<image_tag>
docker tag arachni:<image_tag> brayanperera/arachni:latest
docker push brayanperera/arachni:<image_tag>
docker push brayanperera/arachni:latest
````


### Using SQLite - Arachni Web UI

```bash
docker run -d \
  -e "ARACHNI_ADMIN_PASSWORD=sample_admin_pass" \
  -e "ARACHNI_USERNAME=arachni@example.com" \
  -e "ARACHNI_PASSWORD=arachni" \
  -p 9292:9292 \
  --name arachni \
  brayanperera/arachni:latest
```

### Using PostgreSQL - Arachni Web UI
```bash
docker run -d \
  -e "DB_ADAPTER=postgresql" \
  -e "DB_HOST=sample_host" \
  -e "DB_NAME=sample_db_name" \
  -e "DB_USER=sample_db_user" \
  -e "DB_PASS=sample_db_pass" \
  -e "ARACHNI_ADMIN_PASSWORD=sample_admin_pass" \
  -e "ARACHNI_USERNAME=arachni@example.com" \
  -e "ARACHNI_PASSWORD=arachni" \
  -p 9292:9292 \
  --name arachni \
  brayanperera/arachni:latest
```

### Using Arachni CLI -- No Login (Blackbox)

```bash
docker run -v <path_to_report_dir>:/usr/local/arachni/reports --rm \
  -e CLI_ENABLED=true \
  -e TARGET_URL=https://google.com \
  -e REPORT_NAME=google_com.report \
  -e EXCLUDE_PATTERN=logout \
  -e LOGIN_ENABLED=false \
  brayanperera/arachni:latest
```

> Note: The reports (HTML and JSON) will be generated in the `/usr/local/arachni/reports` directory.

### Using Arachni CLI -- With Login (Whitebox)

```bash
docker run -v <path_to_report_dir>:/usr/local/arachni/reports --rm \
  -e CLI_ENABLED=true \
  -e TARGET_URL=https://google.com \
  -e REPORT_NAME=google_com.report \
  -e EXCLUDE_PATTERN=logout \
  -e LOGIN_ENABLED=true \
   brayanperera/arachni:latest
```

> Note: The reports (HTML and JSON) will be generated in the `/usr/local/arachni/reports` directory.
