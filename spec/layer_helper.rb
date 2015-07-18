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
end
