module Layer
  module Api
    module Announcements
      def send_announcement(announcement = {})
        post("announcements", body: announcement.to_json)
      end

      def announcements
        Layer::Api::ResourceProxy.new(nil, Layer::Resources::Announcement)
      end
    end
  end
end
