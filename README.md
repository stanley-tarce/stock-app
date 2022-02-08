



# Stock App

Stock App is a Rails API only app for the Stock App.
### Live 
To access the live website, click this [link](https://stock-app-react.vercel.app/) 

### Frontend Repository
To access the frontend repository click this [link](https://github.com/stanley-tarce/stock-app-react) 

### Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

Clone the repository inside your local directory and change your directory to the root of the file

```
git clone https://github.com/stanley-tarce/stock-app.git
```
### Prerequisites
Make sure to have Ruby, Rails, NodeJs, Postgresql, and Yarn installed. The versions I used are as listed: 

    Rails 6.1.4.4
    ruby-3.0.2
    node v17.0.1
    yarn 1.22.17
    psql (PostgreSQL) 14.1 
  ### Installing
To get the API running, run the following command  

    bundle install 
Enable alternate role on Postgresql

    sudo -u postgres psql 
 Type this in the postresql console
 

    ALTER USER postgres WITH PASSWORD 'postgres;
    

Setup the database by running this command

    rails db:setup

Or you can run this

    rails db:create db:migrate 

 To check the routes use this command
 

    rails routes 
### Server 
Enable the server by running this command 

    rails s 
or you could run on a different server  

    rails s -p <YOUR_CUSTOM_SERVER> *example 3001

### RSpec Test
To run the test, simply do the following: 

    rails db:migrate RAILS_ENV=test
    rspec spec or bundle exec rspec spec

**RSpec Result:**
 *Finished in 1 minute 10.43 seconds (files took 1.98 seconds to load)
73 examples, 0 failures*
### Deployment
To deploy to production, simply create an heroku account and run this on the terminal 

    heroku create
    heroku rename <YOUR_CHOSEN_NAME>
    git add -A 
    git commit -m <MESSAGE>
    git push heroku 
