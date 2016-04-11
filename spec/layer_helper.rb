module LayerHelper
  def conversation_params
    params = {
      participants: [
        "1234",
        "5678"
      ],
      distinct: false,
      metadata: {
        background_color: "#3c3c3c"
      }
    }
  end

  def announcement_params
    {
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
  end

  def message_params
    {
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
  end

  def webhook_params
    {
      version: "1.0",
      target_url: "https://mydomain.com/my-webhook-endpoint",
      events: ["conversation.created", "message.sent"],
      secret: "1697f925ec7b1697f925ec7b",
      config: {:key1=>"value1", :key2=>"value2"}
    }
  end

  def user_identity_params
    {
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
  end
end
