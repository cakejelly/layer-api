require 'spec_helper'

require 'pry'


describe Layer::Api::Announcements do
  before do
    @layer = Layer::Api::Client.new(
      api_token: ENV['LAYER_API_TOKEN'],
      app_id: ENV['LAYER_APP_ID']
    )
  end

  describe ".send_announcement" do
    it "should send an announcement" do
      VCR.use_cassette('announcement') do
        announcement = @layer.send_announcement(announcement_params)

        expect(announcement["id"]).to_not be_nil
        expect(announcement["url"]).to_not be_nil
        expect(announcement["sent_at"]).to_not be_nil
        expect(announcement["recipients"]).to match_array(announcement_params[:recipients])
      end
    end
  end
end
