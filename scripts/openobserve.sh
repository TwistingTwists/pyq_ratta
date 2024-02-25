mkdir -p data_openobserve

docker run -v $PWD/data_openobserve:/data -e ZO_DATA_DIR="/data" -p 5080:5080 \
    -e ZO_ROOT_USER_EMAIL="someworks456@gmail.com" -e ZO_ROOT_USER_PASSWORD="openhakunamata" \
    public.ecr.aws/zinclabs/openobserve:latest
