# ecs-with-terraform

## Notes

ECS documentation :  
[Running Logstash on Docker](https://www.elastic.co/guide/en/logstash/current/docker.html)  
[Using Amazon ECS Exec for debugging](https://docs.aws.amazon.com/en_en/AmazonECS/latest/userguide/ecs-exec.html)  
[Using data volumes in tasks : Bind mounts](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/bind-mounts.html)  
[Using the awslogs log driver](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html#specify-log-config)  
[CPU and memory acceptable values](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)  

Docker images :  
[Dockerhub - debian](https://hub.docker.com/_/debian)  
[Dockerhub - alexeiled/stress-ng](https://hub.docker.com/r/alexeiled/stress-ng/)  

## WIP

[Hashicorp Demo App](https://github.com/hashicorp/demo-consul-101/tree/master)  
https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/networking-connecting-services.html  

## Examples

### ECS Exec

From the console gather the ecs cluster name, the task id and the container you want to exec into, then issue the following command :  

```
aws ecs execute-command --cluster <cluster_name> \
    --task <task_id> \
    --container <container_name> \
    --interactive \
    --command "/bin/sh"
```

```
aws ecs execute-command --cluster ecsWithTf-dev \
    --task 32f4aaa9555f4a188789226094c70485 \
    --container myapp \
    --interactive \
    --command "/bin/sh"
```
