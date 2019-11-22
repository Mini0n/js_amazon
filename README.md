# js_amazon
Retreive Amazon Products information by its ASIN through web scrapping (Powered by Faraday & Nokogiri :])

Retrieve and store:
- ASIN
- Name
- Category
- Ranking
- Weight
- Dimensions

# Set up
Assuming you already have a PostgreSQL installation working it's very easy:

1. `git clone <this-repo>`
2. `cd <cloned-repo-dir>` 
3. `bundle install`
4. `rake db:setup`
5. `rails s`

# How it works
In your browser go the `rails s` URL (usually `http://localhost:3000`)

You only need 2 routes:

- `URL/products`
- `URL/products/<ASIN>`

First route shows all stored products. It will start empty

Second routes lets you add new products to your DB.


# Specs

* Ruby version

  2.5.3

* System dependencies

  PostreSQL 10.10

* Configuration

  `database.yml` may need to be adjusted to suit your PostgreSQL config

* Database creation

  rake db:setup

* Database initialization

  No initialization is needed

* How to run the test suite

  Just run `rspec`

* Deployment instructions

  Ready to deploy on Heroku through CLI