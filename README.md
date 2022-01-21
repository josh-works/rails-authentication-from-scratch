working through https://stevepolito.design/blog/rails-authentication-from-scratch/, super excited to do so.

I love me a good tutorial, and I know they're damned hard to build. Let us begin.

## Step 1: Build User Model

[link](https://stevepolito.design/blog/rails-authentication-from-scratch/#step-1-build-user-model)

Steps so far:

```shell
$ rails _6.1.3_ new rails-authentication-from-scratch -d postgresql
# this worked, but generated an error as it ran `rails  webpacker:install`

nvm alias default 16 # set default node version to 16, instead of 8. 🤦‍♀️

cd rails-authentication-from-scratch

rails webpacker:install

# still errors

nvm use 16 # maybe in addition to setting the default, I also had to change
# the current version

rails webpacker:install # now this worked
```

Now ready to carry onward with the tutorial!

[...]

did `rails g model User email:string`, then to practice generating fake data, making sure everything works, even without tests, I'm adding two gems. `pry-rails` in the `development` and `test` group, and `faker`. 

```diff
# Gemfile

+gem 'faker'

 group :development, :test do
   # Call 'byebug' anywhere in the code to stop execution and get a debugger console
   gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
+  gem 'pry-rails'
 end

```

```ruby
# seeds.rb
20.times do 
  User.create(email: Faker::Internet.email)
end
```

Run `rails db:seed`, boot up the rails console, and if you call `User.all`, you'll see them there.

Onward.

## Step 2: Add Confirmation and Password Columns to Users Table

[link](https://stevepolito.design/blog/rails-authentication-from-scratch/#step-2-add-confirmation-and-password-columns-to-users-table)

```
$ rails g migration add_confirmation_and_password_columns_to_users confirmed_at:datetime password_digest:string
```

Followed the instructions for updating the `User` model, and updated my `seeds.rb` as well:

```ruby
20.times do 
  p User.create(email: Faker::Internet.email, password: "password")
end
```

## Step 3: Create Sign Up Pages

[link](https://stevepolito.design/blog/rails-authentication-from-scratch/#step-3-create-sign-up-pages)

```
rails g controller StaticPages home
```

followed the rest of the steps. Smooth sailing.

## Step 4: Create Confirmation Pages

easy! Pausing this session of work to go make lunch, and then picking up with:

## Step 5: Create Confirmation Mailer

[link](https://stevepolito.design/blog/rails-authentication-from-scratch/#step-5-create-confirmation-mailer)
