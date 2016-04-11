# Layer Ruby Gem
[![Build Status](https://travis-ci.org/cakejelly/layer-api.svg?branch=master)](https://travis-ci.org/cakejelly/layer-api) [![Gem Version](https://badge.fury.io/rb/layer-api.svg)](http://badge.fury.io/rb/layer-api)

Simple wrapper for Layer's Web API's

If you want to learn more, check out the [official documentation](https://developer.layer.com/docs/platform).

## Migrating from 0.3.x
Version 0.4 is not compatible with older versions. SEE [MIGRATING](MIGRATING.md) for details on how to migrate your code to the latest version.

## Installation ##

Add this line to your application's Gemfile:

```ruby
gem 'layer-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install layer-api


## Usage

### Resources
All client methods return `Resource` objects or a collection of `Resource` objects. Every attribute from a resource can be accessed by calling attribute methods:

```ruby
conversation = platform.conversations.find("fb2f3a48-523d-4449-a57f-c6651fc6612c")
#<Layer::Resources::Conversation @attributes={...}>

# Get the stripped uuid for any resource
conversation.uuid
# => "fb2f3a48-523d-4449-a57f-c6651fc6612c"

conversation.url
# => "https://api.layer.com/apps/<APP_ID>/conversations/fb2f3a48-523d-4449-a57f-c6651fc6612c"

# Retrieve all attributes
conversation.attributes
# => {"id" => "fb2f3a48-523d-4449-a57f-c6651fc6612c", "url" => "https://api.layer.com/apps/<APP_ID>/conversations/fb2f3a48-523d-4449-a57f-c6651fc6612c", ...}
```

### [Platform](https://developer.layer.com/docs/platform)
See the [Platform API docs](https://developer.layer.com/docs/platform) for additional info.

#### Authentication/setup

```ruby
platform = Layer::Platform::Client.new(api_token: "your_api_token", app_id: "your_app_id")
# => #<Layer::Platform::Client @api_token="...", @app_id="...">
```
If you have `ENV['LAYER_API_TOKEN']` and `ENV['LAYER_APP_ID']` environment variables setup, they will be used by default and don't need to be included:
```ruby
platform = Layer::Platform::Client.new
# => #<Layer::Platform::Client @api_token="...", @app_id="...">
```

#### Retrieving Conversations ####

```ruby
user = platform.users.find("user_id")
convs = user.conversations.list
# => [#<Layer::Resources::Conversation>, #<Layer::Resources::Conversation>, ...]

```

#### Retrieving A Single Conversation ####

```ruby
# For a user
user = platform.users.find("user_id")
conv = user.conversations.find("conversation_id")
# => #<Layer::Resources::Conversation @attributes={...}>

# or alternatively
conv = platform.conversations.find("conversation_id")
# => #<Layer::Resources::Conversation @attributes={...}>
```

#### Creating Conversations ####

```ruby
conversation = {
  participants: [
    "1234",
    "5678"
  ],
  distinct: false,
  metadata: {
    background_color: "#3c3c3c"
  }
}

platform.conversations.create(conversation)
# => #<Layer::Resources::Conversation @attributes={...}>
```

#### Editing Conversations ####

```ruby
conv = platform.conversations.find("conversation_id")

operations = [
  { operation: "add", property: "participants", value: "user1" },
  { operation: "add", property: "participants", value: "user2" }
]

conv.update(operations)
# => true
```
#### Deleting Conversations ####

```ruby
conv = platform.conversations.find("conversation_id")
conv.destroy
# => true

```

#### Initiating a Rich Content Upload

```ruby
conv = platform.conversations.find("conversation_id")
content = conv.content.create(mime_type: "image/png", file: File.open("image.png"))
# => #<Layer::Resources::RichContent @attributes={...}>

content.upload_url
# => "https://www.googleapis.com/upload/storage/path/to/content"
```

#### Refreshing the download URL for a Content Object

```ruby
content = conv.content.find("content_id")
# => #<Layer::Resources::RichContent @attributes={...}>

content.download_url
# => "http://google-testbucket.storage.googleapis.com/some/download/path"

content.refresh_url
"https://api.layer.com/apps/<APP_ID>/conversations/<CONVERSATION_ID>/content/<CONTENT_ID>"
```

#### Sending Messages ####

```ruby
message = {
  sender: {
    name: "t-bone"
  },
  parts: [
    {
        body: "Hello, World!",
        mime_type: "text/plain"
    },
    {
        body: "YW55IGNhcm5hbCBwbGVhc3VyZQ==",
        mime_type: "image/jpeg",
        encoding: "base64"
    }
  ],
  notification: {
    text: "This is the alert text to include with the Push Notification.",
    sound: "chime.aiff"
  }
}

conv = platform.conversations.find("conversation_id")
conv.messages.create(message)
# => #<Layer::Resources::Message @attributes={...}>
```

#### Retrieving Messages ####

```ruby
# From a specific user's perspective
conv = platform.users.find("user_id").conversations.find("conversation_id")
conv.messages.list
# => [#<Layer::Resources::Message>, #<Layer::Resources::Message>, ...]

# From the system's perspective
conv = platform.conversations.find("conversation_id")
conv.messages.list
# => [#<Layer::Resources::Message>, #<Layer::Resources::Message>, ...]
```

#### Retrieving A Single Message ####

```ruby
# From a specific user's perspective
user = platform.users.find("user_id")
messages = user.messages.find("message_id")
# => #<Layer::Resources::Message @attributes={...}>

# From the systems perspective
conv = platform.conversations.find("conversation_id")
messages = conv.messages.find("message_id")
# => #<Layer::Resources::Message @attributes={...}>
```

#### Deleting A Message

```ruby
conv = platform.conversations.find("conversation_id")
conv.messages.find("message_id").destroy
# => true
```

#### Sending Announcements ####

```ruby
announcement = {
  recipients: [ "1234", "5678" ],
  sender: {
    name: "The System"
  },
  parts: [
    {
        body: "Hello, World!",
        mime_type: "text/plain"
    }
  ],
  notification: {
    text: "This is the alert text to include with the Push Notification.",
    sound: "chime.aiff"
  }
}

platform.announcements.create(announcement)
# => #<Layer::Resources::Announcement @attributes={...}>
```

#### Modifying A Users Block List ####

```ruby
user = platform.users.find("user_id")

operations = [
    { operation: "add", property: "blocks", value: "blockMe1" },
    { operation: "add", property: "blocks", value: "blockMe2" },
    { operation: "remove", property: "blocks", value: "unblockMe" }
]

user.update(operations)
# => true
```

#### Retrieving A Users Block List

```ruby
user = platform.users.find("user_id")

blocks = user.blocks.list
# => [#<Layer::Resources::Block>, [#<Layer::Resources::Block>, ...]
```

#### Blocking Users

```ruby
# using params
owner = platform.users.find("owner")
owner.blocks.create(user_id: "blocked")
# => #<Layer::Resources::Block @attributes={...}>

# passing a User object
owner = platform.users.find("owner")
blocked = platform.users.find("blocked")

owner.blocks.create(blocked)
# => #<Layer::Resources::Block @attributes={...}>
```

#### Unblocking Users

```ruby

# using the blocked users id
owner = platform.users.find("owner")
owner.blocks.find("blocked_user").destroy
# => true

# using a User object
owner = platform.users.find("owner")
blocked = platform.users.find("blocked")

owner.blocks.find(blocked).destroy
# => true
```

#### Creating a User Identity

```ruby
identity = {
  display_name: "Frodo the Dodo",
  avatar_url: "http://sillylordoftheringspictures.com/frodo-riding-a-dodo.png",
  first_name: "Frodo",
  last_name: "Baggins",
  phone_number: "13791379137",
  email_address: "frodo@sillylordoftheringspictures.com",
  metadata: {
    level: "35",
    race: "Dodo"
  }
}

user = platform.users.find("user_id")
user.create_identity(identity)
# => true

```

#### Retrieving a User's Identity

```ruby
user = platform.users.find("user_id")
user.identity
# => {"first_name"=>"Frodo", "phone_number"=>"13791379137", "email_address"=>"frodo@sillylordoftheringspictures.com", "display_name"=>"Frodo the Dodo", "user_id"=>"jake", "last_name"=>"Baggins", "metadata"=>{"race"=>"Dodo", "level"=>"35"}, "avatar_url"=>"http://sillylordoftheringspictures.com/frodo-riding-a-dodo.png"}
```

#### Updating an Identity

```ruby
operations = [
  { operation: "set", property: "last_name", value: "Dodo" },
  { operation: "set", property: "phone_number", value: "" },
  { operation: "set", property: "metadata.level", value: "2" }
]

user.update_identity(operations)
# => true
```

#### Replacing an identity

```ruby
identity = {
  display_name: "Frodo the Dodo",
  avatar_url: "http://sillylordoftheringspictures.com/frodo-riding-a-dodo.png",
  first_name: "Frodo",
  last_name: "Baggins",
  phone_number: "13791379137",
  email_address: "frodo@sillylordoftheringspictures.com",
  metadata: {
    level: "35",
    race: "Dodo"
  }
}

user.replace_identity(identity)
# => true

```

#### Deleting a User's Identity

```ruby
user = platform.users.find("user_id")
user.destroy_identity
# => true
```

#### Setting a Users Badge

```ruby
user = platform.users.find("user_id")
user.set_badge(10)
# => true
```

#### Retrieving a Users Badge

```ruby
user = platform.users.find("user_id")
user.badge
# => { "external_unread_count" => 13, "unread_conversation_count" => 10, "unread_message_count" => 50 }
```


#### Generating Identity Tokens ####
See: [the official authentication guide](https://developer.layer.com/docs/android/guides#authentication)

Make sure the following environment variables are set:
`ENV['LAYER_KEY_ID']`
`ENV['LAYER_PROVIDER_ID']`
`ENV['LAYER_PRIVATE_KEY']`

```ruby
# Returns a valid signed identity token. #
token = platform.generate_identity_token(user_id: "1234", nonce: "your_random_nonce")
# => #<Layer::IdentityToken:0x007f89b4adb890>

token.to_s
# => "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsInR.cCI6IkpXVCIsImN0eSI6ImxheWVyLWVpdDt2PTEiLCJraWQiOiJhNz.5YTE0MC02YzY3LTExZTUtYjM0Mi1jZGJmNDAwZTE5NDgifQ"
```

### [Webhooks](https://developer.layer.com/docs/webhooks)
See the [Webhooks API docs](https://developer.layer.com/docs/webhooks) for additional info.

#### Authentication/setup

```ruby
client = Layer::Webhooks::Client.new(api_token: "your_api_token", app_id: "your_app_id")
# => #<Layer::Webhooks::Client @api_token="...", @app_id="...">
```
If you have `ENV['LAYER_API_TOKEN']` and `ENV['LAYER_APP_ID']` environment variables setup, they will be used by default and don't need to be included:
```ruby
client = Layer::Webhooks::Client.new
# => #<Layer::Webhooks::Client @api_token="...", @app_id="...">
```

#### Registering Webhooks

```ruby
client.webhooks.create(
  version: "1.0",
  target_url: "https://mydomain.com/my-webhook-endpoint",
  events: ["conversation.created", "message.sent"],
  secret: "1697f925ec7b1697f925ec7b",
  config: {:key1=>"value1", :key2=>"value2"}
)
# => #<Layer::Resources::Webhook @attributes={...}>
```

#### Listing Webhooks

```ruby
client.webhooks.list
# => [#<Layer::Resources::Webhook>, #<Layer::Resources::Webhook>, ...]
```

#### Retrieving Webhooks

```ruby
client.webhooks.find("webhook_id")
# => #<Layer::Resources::Webhook @attributes={...}>
```

#### Activating Webhooks

```ruby
webhook = client.webhooks.find("webhook_id")
webhook.activate
```

#### Deactivating Webhooks

```ruby
webhook = client.webhooks.find("webhook_id")
webhook.deactivate
```

#### Deleting Webhooks

```ruby
webhook = client.webhooks.find("webhook_id")
webhook.destroy
```


## Development ##

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing ##

Bug reports and pull requests are welcome on GitHub at https://github.com/cakejelly/layer-api.
