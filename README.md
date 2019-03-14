# Postgres DB with MIMIC III Schema

Dockerfile for creating a docker image with a Postgres database containing the MIMIC III schema. The database is initialized using scripts from [MIT-LCP](https://github.com/MIT-LCP/mimic-code/tree/master/buildmimic/postgres). 

### Running the container

Visit [docker hub](https://cloud.docker.com/repository/docker/tkolleh/mimic-iii/). Pull the latest image and run the below command:

```
docker run -td -p 5432:5432 -e POSTGRES_PASSWORD=password \
  -e MIMIC_PASSWORD=password \
  --name postgres-mimic <image>
```


