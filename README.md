# Exercise Ritchie Buitre

Ruby on Rails exercise for Montani.
The XYZ bookstore listing books, authors and publishers.

## Prerequisites

* Ruby 3.0.1
* Rails 6.1.7
* SQLite

## Development Setup

On your commandline run the following:

Install Ruby gems:

    $ bundle install

Setup the database:

    $ rails db:setup

Run the test:

    $ rspec --format doc

## Demo

Run the server:

    $ rails server -p 3000

Then open on your browser [http://localhost:3000](http://localhost:3000)

To view a book type the ISBN-13 code under books endpoint:

    $ curl http://localhost:3000/books/978-1-891830-85-3

To convert ISBN-13 to ISBN-10 and vice versa type the code under convert endpoint:

    $ curl http://localhost:3000/convert/978-1-891830-85-3

## Author

[@RichOrElse](github.com/richorelse) Ritchie Paul Buitre <ritchie@richorelse.com>
