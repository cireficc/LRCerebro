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

 - `export GOOGLE_APPLICATION_CREDENTIALS=/home/ubuntu/secrets/GOOGLE_AUTH_DEVELOPMENT.json`
 - `export GOOGLE_CALENDAR_RESERVATION_CAL_ID=7niit4bglqaq74la04jee8ddc4@group.calendar.google.com`
 
 in `~/.bash_profile`.
