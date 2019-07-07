#!/bin/bash
sleep 3

# Not being honored from Dockerfile?
export DISCOURSE_REDIS_HOST=redis

#bundle exec rake db:drop
#RAILS_ENV=test bundle exec rake db:drop

bundle exec rake db:create db:migrate
RAILS_ENV=test bundle exec rake db:create db:migrate

bundle exec rake admin:create
bundle exec rails s -b 0.0.0.0 # open browser on http://localhost:3000 and you should see Discourse

#bundle exec rake autospec
#bundle exec rake server --trace
#tail -f /dev/null
