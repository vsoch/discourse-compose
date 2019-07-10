#!/bin/bash

PARAMS="$@"

read -p "Would you like to make an admin account? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    docker exec -it discourse /bin/bash -c "cd /usr/src/app && rake admin:create"
fi

CMD="cd /usr/src/app && USER=discourse RUBY_GLOBAL_METHOD_CACHE_SIZE=131072 LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so RAILS_ENV=production bin/unicorn -p 80 $PARAMS"
docker exec -it discourse /bin/bash -c "$CMD"
