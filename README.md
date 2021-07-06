# LRCerebro
This is the GVSU Language Resource Center's faculty, student and staff portal for managing the LRC's resources.

# Installation requires:

* Rails 4.1.6
* Ruby 2.1.5p273
* PostgreSQL 9.3.6
* Elasticsearch 2.4.1

## Installing things

Use **homebrew** on OS X.

- `brew install homebrew/versions/postgresql94` (9.4.9_1)
- `brew install homebrew/versions/elasticsearch24` (2.4.1)

## Launching services

Use **lunchy** (`gem install lunchy`) on OS X.

Copy application plist files for lunchy:

- `cp /usr/local/Cellar/postgresql/9.4.9_1/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/`
- `cp /usr/local/Cellar/elasticsearch24/2.4.1/homebrew.mxcl.elasticsearch24.plist ~/Library/LaunchAgents/`

Then just launch with `lunchy start postgres` and `lunchy start elasticsearch`.

## Environment Variables (development)

- `export GOOGLE_APPLICATION_CREDENTIALS=/PATH/TO/LRCerebro/config/GOOGLE_API_SERVICE_DEVELOPMENT.json`
- `export GOOGLE_CALENDAR_RESERVATION_CAL_ID=7niit4bglqaq74la04jee8ddc4@group.calendar.google.com`
- `export GOOGLE_CALENDAR_PROJECT_PUBLISHING_CAL_ID=knk6vm0gs72glbt1smh03t0pp0@group.calendar.google.com`
- `export GOOGLE_CALENDAR_VIDCAM_CAL_ID=igtb6hfuheekma5vmdmk2niius@group.calendar.google.com`

in `~/.bash_profile`. `GOOGLE_API_SERVICE_DEVELOPMENT.json` is a JSON credential file that needs to be obtained before running the app.
The other exports are the calendars used in development mode, separate from the production calendars.

### Import new MLL data

1. `mkdir current/db/MLL_data`
2. `cp ../lrc-feed/lrc_ppl.txt current/db/MLL_data/`
3. `cp ../lrc-feed/lrc_crs.txt current/db/MLL_data/`
4. `cp ../lrc-feed/lrc_enr.txt current/db/MLL_data/`
5. `vim` each of the lrc_*.txt documents and remove empty lines at the end of the file
5. `cd current`
6. `bundle exec rake db:import_mll_data`

### Start the Delayed::Job daemon and get jobs working

`bundle exec rake jobs:work` will work jobs currently in the queue.

`RAILS_ENV=production bin/delayed_job start` will start the job service locally, 
`sudo /usr/sbin/service lrcerebro-delayed-job start` will start it on the production server.

### Start the Elasticsearch service

`sudo /usr/sbin/service elasticsearch start` (`restart` and `stop` also)

If Elasticsearch has the following index write error:

> `Elasticsearch::Transport::Transport::Errors::Forbidden: [403] {"error":{"root_cause":[{"type":"cluster_block_exception","reason":"blocked by: [FORBIDDEN/12/index read-only / allow delete (api)];"}],"type":"cluster_block_exception","reason":"blocked by: [FORBIDDEN/12/index read-only / allow delete (api)];"},"status":403}`

([source](https://stackoverflow.com/a/57675654/1986871)) clear up disk space to < 95% threshold, and run the following commands:

```bash
curl -XPUT -H "Content-Type: application/json" http://localhost:9200/_cluster/settings -d '{ "transient": { "cluster.routing.allocation.disk.threshold_enabled": false } }'
curl -XPUT -H "Content-Type: application/json" http://localhost:9200/_all/_settings -d '{"index.blocks.read_only_allow_delete": null}'
```

### Restoring database from LRC

1. create dump file: `ssh lrcerebro@lrcerebro.mll.gvsu.edu` --> `pg_dump lrcerebro > lrc.dump`
2. SCP dump file to localhost: `scp lrcerebro@lrcerebro.mll.gvsu.edu:lrc.dump ~/lrc.dump`, then `rm lrc.dump` from the server
3. run on localhost `rake db:drop db:create && psql lrcerebro_development < lrc.dump && rake searchkick:reindex:all`