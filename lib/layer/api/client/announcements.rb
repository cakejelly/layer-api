module Layer
  module Api
    module Announcements
      def send_announcement(announcement = {})
        post("announcements", body: announcement.to_json)
      end
    end
  end
end
