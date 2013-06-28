## About

This is the Karate Journal web application.  Karate Journal is a wiki like tool
that organizes notes from your training.  The RDoc::Markup class in the Ruby
core library is used to perform the markup.  See the documentation on that class
for markup format documentation.

More information, including a full list of features and screenshots, can be
found at [http://johnpwood.net/projects/webapps/karate-journal/](http://johnpwood.net/projects/webapps/karate-journal/)


## Setup
* Clone the git repository
* Copy config/database.yml.template to config/database.yml and configure your database connection
* bundle install
* bundle exec rake db:create db:migrate
* bundle exec rails s


## LICENSE
MIT License.  See LICENCE for details.


## AUTHOR
Karate Journal was written by John Wood.  John can be reached at john@johnpwood.net.

