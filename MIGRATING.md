# Migrating from version `0.3.x` to `0.4`

`0.4` introduces a pretty significant overhaul to the codebase, which isn't backwards compatible. There are a couple of reasons:

* This gem was originally built with the purpose of only wrapping the [Platform API](https://developer.layer.com/docs/platform). Since then, Layer have added REST & Websocket API's, Webhook support, as well as adding more functionality to the Platform API.
* While the existing code in `0.3.x` was fairly basic, it wasn't written in a way that is easily maintainable and extensible with all of Layer's API's

If you are starting from `0.4` upwards, you can discard all of this.

## Authentication
In `0.3.x` authentication & setup would be done using the following:

```ruby
layer = Layer::Api::Client.new(
  api_token: "your_api_token",
  app_id: "your_app_id"
)
```

In `0.4`, the following is required:

```ruby
layer = Layer::Platform::Client.new(api_token: "your_api_token", app_id: "your_app_id")
```

## Resources
In `0.3.x`, each function returned a Hash containing a parsed JSON representation of each resource.

`0.4` introduced `Resource` - A base class used to encapsulate each JSON response.

`Resource` can allow attributes to be accessed by calling the attribute name on the instance. Alternatively, you can return a Hashed version of the resource using `Resource.attributes`. For example:

```ruby

conv = layer.conversations.find("conversation_id")
=> #<Layer::Resources::Conversation:0x007fea8b2be508 @attributes={...}>"

conv.url
=> "https://api.layer.com/apps/<APP_ID>/conversations/<CONV_ID>"

conv.attributes
=> {...}
```

## Retrieving conversations
In `0.3.x` a conversation could be retrieved with:

```ruby
layer.get_conversation("conversation_id")
```

In `0.4`, the same result can be achieved with:

```ruby
conv = layer.conversations.find("conversation_id")
conv.attributes

```

## Editing conversations

In `0.3.x`:

```ruby
operations = [
  {operation: "add", property: "participants", value: "user1"},
  {operation: "add", property: "participants", value: "user2"}
]

layer.edit_conversation("conversation_id", operations)
```

In `0.4`:

```ruby
conv = layer.conversations.find("conversation_id")
conv.update(operations)
```

## Sending messages

In `0.3.x`:

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

layer.send_message("conversation_id", message)
```

In `0.4`:

```ruby
conv = layer.conversations.find("conversation_id")
conv.messages.create(message)
```

## Sending announcements

In `0.3.x`:

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

layer.send_announcement(announcement)
```

In `0.4`:

```ruby
layer.announcements.send(announcement)
```

## Retrieving a users block list

In `0.3.x`:

```ruby
layer.get_blocklist("user_id")
```

In `0.4`:

```ruby
user = layer.users.find("user_id")
user.blocks.list
```

## Adding a user to a block list

In `0.3.x`:

```ruby
layer.block_user("owner_id", "user_id")
```

In `0.4`:

```ruby
owner = layer.users.find("owner_id")
owner.blocks.create(user_id: "user_id")
```

## Remove a user from another users block list

In `0.3.x`:

```ruby
layer.unblock_user("owner_id", "user_id")
```

In `0.4`:

```ruby
block = layer.users.find("owner_id").blocks.find("user_id")
block.destroy


```

## Generating identity tokens

In `0.3.x`:

```ruby
layer.generate_identity_token(user_id: "1234", nonce: "your_random_nonce")
```

In `0.4.`:

```ruby
token = layer.generate_identity_token(user_id: "1234", nonce: "your_random_nonce")
token.to_s
```
