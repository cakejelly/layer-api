module Layer
  module Api
    module Announcements
      def send_announcement(announcement = {})
        response = connection.post("announcements", announcement.to_json)
        JSON.parse(response.body)
      end
    end
  end
end
