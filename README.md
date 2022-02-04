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

### Slight deviations/troubleshooting/making things visible


I added the mailcatcher gem (https://mailcatcher.me/) to get local emails when the app sends them, tested locally a few times, sure enough, I'm now sending confirmation emails when a user signs up. Clicking the confirmation URL in the email doesn't do anything, but I can tell that it hits the confirmations controller in the logs.

OK, also, I added to the `application.html.erb` the `render flash` default code, so now clicking the email confirmation link says `your account is confirmed`

```diff
--- a/app/views/layouts/application.html.erb
+++ b/app/views/layouts/application.html.erb
@@ -11,6 +11,11 @@
   </head>

   <body>
+    <% flash.each do |type, msg| %>
+      <div>
+        <%= msg %>
+      </div>
+    <% end %>
     <%= yield %>
   </body>
 </html>
```

And added a link to `sign_up` on the home page:

```diff
--- a/app/views/static_pages/home.html.erb
+++ b/app/views/static_pages/home.html.erb
@@ -1,2 +1,4 @@
 <h1>StaticPages#home</h1>
 <p>Find me in app/views/static_pages/home.html.erb</p>
+
+<%= link_to "Sign Up", sign_up_path %>
```

Now, I can "exercise" the whole application, and see it all working at every step. 

I added these two things here: https://github.com/josh-works/rails-authentication-from-scratch/commit/8fe14286c01f3e46f0aaef8c6d1d1bee814cee1f

## [Step 6: Create Current Model and Authentication Concern](https://stevepolito.design/blog/rails-authentication-from-scratch/#step-6-create-current-model-and-authentication-concern)

Easy! Great explanations. Learning lots of good stuff, like `session fixation` and more.

## Steps 7 & 8

Humming right along. This is a great guide, after every step I stop and make some predictions in my head about how the application has changed, then I validate that.

Clicking around, logging in, clicking various confirmation links in emails, reading flash messages, etc. This guide is great.

## [Step 9: Add Password Reset Functionality](https://stevepolito.design/blog/rails-authentication-from-scratch/#step-9-add-password-reset-functionality)

[took a long break, at least a week, between the last entry, doing steps 7 and 8, and starting 9. This is evidence and proof positive for my own detailed note taking. I can jump right in, read a minute, and I'm good to start working.]

oops forgot to commit step 9, I'm actually on step 10

## Step 10

I think I was halfway through step 10 when I stopped last time. So much for setting myself up EXACTLY for success. Should have written a note to myself. 

Done with step 10 - I was close. This is good refreshing for rails routes, and hooking them up to forms.

## Step 11

straight forward

(adding this from a few steps later - I've had trouble with the "unconfirmed email" part, as you're about to see...)

## Step 12

this is great. learning lots here.

I'm _basically_ done, but now visiting all my routes, testing all the subtle stuff. Adding little links for myself.

When visiting /sign_up, getting:
```
Unconfirmed email is invalid
Unconfirmed email can't be blank
Unconfirmed email has already been taken
```

so I've got problems with that unconfirmed email stuff. NBD. 

Other stuff seems to be working well. This has been super educational.

When I come back, I'll visit http://localhost:3000/sign_up, and see why I cannot currently create new users.

From the logs:

```
Started POST "/sign_up" for 127.0.0.1 at 2022-02-01 23:54:03 -0700
Processing by UsersController#create as HTML
  Parameters: {"authenticity_token"=>"[FILTERED]", "user"=>{"email"=>"j@j.j", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]"}, "commit"=>"Sign Up"}
  TRANSACTION (0.9ms)  BEGIN
  ↳ app/controllers/users_controller.rb:6:in `create'
  User Exists? (0.9ms)  SELECT 1 AS one FROM "users" WHERE "users"."email" = $1 LIMIT $2  [["email", "j@j.j"], ["LIMIT", 1]]
  ↳ app/controllers/users_controller.rb:6:in `create'
  User Exists? (2.3ms)  SELECT 1 AS one FROM "users" WHERE "users"."unconfirmed_email" IS NULL LIMIT $1  [["LIMIT", 1]]
  ↳ app/controllers/users_controller.rb:6:in `create'
  TRANSACTION (1.6ms)  ROLLBACK
  ↳ app/controllers/users_controller.rb:6:in `create'
  Rendering layout layouts/application.html.erb
  Rendering users/new.html.erb within layouts/application
  Rendered shared/_form_errors.html.erb (Duration: 1.8ms | Allocations: 1439)
  Rendered users/new.html.erb within layouts/application (Duration: 3.2ms | Allocations: 2319)
[Webpacker] Everything's up-to-date. Nothing to do
  Rendered shared/_header.html.erb (Duration: 0.1ms | Allocations: 39)
  Rendered layout layouts/application.html.erb (Duration: 13.9ms | Allocations: 7077)
Completed 422 Unprocessable Entity in 318ms (Views: 20.5ms | ActiveRecord: 5.6ms | Allocations: 11602)

```

I commented out the validations on the `unconfirmed_email` column/attribute on the `user` model. That helped. Once I did that, all was groovy. I wonder what I did wrong - I spent a while working on it.

# Step 13

easy

# Step 14

Ran into problems with the migration. I've got lots of data in the DB from seeding, making my own users, so it's possible that if I ran all these migrations front to back without data, they'd all work. Or not.

```ruby
add_column :users, :remember_token, :string, null: false
add_index :users, :remember_token, unique: true
```
Running it as is, gets me:

```
PG::NotNullViolation: ERROR:  column "remember_token" contains null values
```

So, maybe I set the default value to an empty string, but that conflicts w/the uniqueness index:

```ruby
add_column :users, :remember_token, :string, null: false, default: ""
add_index :users, :remember_token, unique: true
```

```
PG::UniqueViolation: ERROR:  could not create unique index "index_users_on_remember_token"
DETAIL:  Key (remember_token)=() is duplicated.
```

So... ended up mixing together the `add_column ` calls, and updating the migration to add data to the column, one at a time, so all the values would be different:

```ruby
# db/timestamp_add_remember_token_to_users.rb
require 'securerandom'
class AddRememberTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :remember_token, :string, null: false, default: ""
    User.find_each do |u|
      u.update_columns(remember_token: SecureRandom.hex)
    end
    add_index :users, :remember_token, unique: true
  end
end
```
And you can confirm with quick digging in the rails console:

```ruby
User.all.pluck(:remember_token).sort
# visually check that it looks unique. It does.
User.all.pluck(:remember_token).sort.count
# 114
User.all.pluck(:remember_token).sort.uniq.count
# 114, LGTM
```

Looks like it worked. Onward.

I'm done for now, when I come back, updating the Authentication Concern (step 15)

## Step 15

Straightforward, I think. I made the changes, more-or-less followed along. Sure wouldn't be able to do this _without_ the guide, but I'm loving it.

## Step 16

Phew. Sorted out a lot of stuff.

I'd missed adding additional code to the `Authentication` module:

```diff
diff --git a/app/controllers/concerns/authentication.rb b/app/controllers/concerns/authentication.rb
index 21b2039..1cfdc4a 100644
--- a/app/controllers/concerns/authentication.rb
+++ b/app/controllers/concerns/authentication.rb
@@ -2,9 +2,14 @@ module Authentication
   extend ActiveSupport::Concern

   included do
+    helper_method :authenticate_user!
+    helper_method :login
     before_action :current_user
     helper_method :current_user
     helper_method :user_signed_in?
+    helper_method :redirect_if_authenticated
+    helper_method :forget
+    helper_method :remember
   end
```

that got me most of the way. I explored some cookie stuff in my browser, clicking around the app, creating it and deleting it, etc. Intresting.

I'd also started having problems with `current_user` in one of my partials. 

I bet that came from messing with the `current_user` method in the `Authentication` module.

## Step 17 (typo w/step 15): Add Friendly Redirects

...

ok, done with step 17. I want to test it, which means I need some data and specific pages.

Lets say we have this "funny quotes" list, and users can visit any funny quote's show page. 

If I log out, then log back in, and show up on that page (like `/quotes/43`), I'll know it worked. Also, an exercise at how quickly I can get this scaffolded up. Should take like 3 minutes, right?

Well shit, shoulda timed. I'll commit all this real quick, but I've got it working:

https://share.getcloudapp.com/YEuB4Qm7
