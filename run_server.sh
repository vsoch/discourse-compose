#!/bin/bash
sleep 3

#bundle exec rake db:drop
bundle exec rake db:create db:migrate
bundle exec rake assets:precompile
bundle exec rails s --port 3000 --environment=production --binding 0.0.0.0
tail -f /dev/null
