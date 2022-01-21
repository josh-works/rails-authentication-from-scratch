working through https://stevepolito.design/blog/rails-authentication-from-scratch/, super excited to do so.

I love me a good tutorial, and I know they're damned hard to build. Let us begin.

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

