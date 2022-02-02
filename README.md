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