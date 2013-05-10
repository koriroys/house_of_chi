##Dev setup:

```
touch config/initializers/_ENV.rb
echo "ENV['FACEBOOK_KEY'] = your_fb_key" >> config/initializers/_ENV.rb
echo "ENV['FACEBOOK_SECRET'] = your_fb_secret" >> config/initializers/_ENV.rb
echo "ENV['GOOGLE_API_KEY'] = your_google_api_key" >> config/initializers/_ENV.rb
rails s
```

Then go to localhost:3000/login to login with Facebook, so I can poll the group
I am a part of for music they are linking.

Then:

```
rake hoc:tracks
```

to load the latest tracks from Facebook group.
