
![Ruby](https://img.shields.io/badge/ruby-%23CC342D.svg?&style=for-the-badge&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/rails%20-%23CC0000.svg?&style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?&style=for-the-badge&logo=postgresql&logoColor=white)

In this system, user can upload videos and see other user contents.

<p float="left" align="center">
  <img src="public/images/profile.png" width="200"/>
  <img src="public/images/elearningsystem.png" width="200" />
  <img src="public/images/courses.png" width="200"> 
  <img src="public/images/categories.png" width="200"> 
</p>


## Run the Project in Development

First we need to setup Rails environment in our system. If you have already setup rails environment, please move to the next section.

**Steps to setup Rails environment:**

1. Install Ruby
1. Install Ruby Package Manager ( [rbenv](https://github.com/rbenv/rbenv) (preferred) / rvm )
1. Install Bundler
1. Setup PostgreSQL Database
1. Setup Git

Details guide to setup rails environment can be found here: https://gorails.com/setup

**Clone the Project**

```bash
git clone git@github.com:shuvra-mbstu/ELEARNING.git
```

Switch to the `ELEARNING` branch

```bash
git checkout ELEARNING
```

After that, run the following commands from project root directory to get up and running.

**Commands to run rails project locally**

1. `bundle install`
2. `rails db:create`
3. `rails db:migrate`
4. `rails db:seed`
5. `rails server`

🌟 You are all set!

Visit: [http://localhost:3000/](http://localhost:3000/)

**Login with Credentials**

email: `admin@gmail.com` <br>
password: `secret`

## Commonly Used Rails Commands

- Create New Rails App: `rails new myapp -d postgresql`
- Create Database: `rails db:create`
- Run Migration: `rails db:migrate`
- Seed Database: `rails db:seed`
- Run Server: `rails server`
- Run Server With Port: `rails server --port <portNumber>`
- See Rails Routes: `rails routes`
- Rails Console: `rails c`
- Drop Database: `rails db:drop`
- Reset Database: `rails db:reset`
- Load Structure SQL: `rails db:structure:load`
- Rollback Last Migration: `rails db:rollback`
- Run RSpec: `rspec spec`
- Reset Seed: `rails db:seed:replant`
- Rails Database Console: `rails dbconsole`
