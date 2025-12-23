#!/usr/bin/bash

user_name=$(whoami)
user_id=$(id -u)

work_directory=$(pwd)
docker_image_name=development
docker_work_directory=/home/$user_name/$docker_image_name

docker build --build-arg USER_NAME=$user_name --build-arg USER_ID=$user_id --build-arg DOCKER_WORK_DIRECTORY=$docker_work_directory -t $docker_image_name $work_directory/docker
docker run -it -h $docker_image_name -v $work_directory:$docker_work_directory:z $docker_image_name
