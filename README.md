# word_combo

Prerequisite.

  - Ruby ~> 2.4.x

##### Follow along:
```
$ gem install bundler
$ bundle install
$ rake db:create
$ rake db:migrate
$ rails s 


// If you want to run on some specific port then apend -p {portnumber} 
```

Default port will be '3000'
You may access the application at:

http://localhost:3000

### APIs

To process and import data:

`curl -i -X POST -H "Content-Type: multipart/form-data" -F "import_file=YouFileHere"  'http://localhost:3000/api/v1/dictionaries/import'`

* Replace YouFileHere with the full file path

Get a list of processed data:

`curl -i GET 'http://localhost:3000/api/v1/dictionaries?page=1'`

There is a limit of `100` records at a time and you have to increase the page number to get the next record

