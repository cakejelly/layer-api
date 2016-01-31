require 'spec_helper'

describe Layer::Resources::Announcement do
  let(:client) { Layer::Platform::Client.new }

  describe ".create" do
    it "should send an announcement" do
      VCR.use_cassette("announcement") do
        announcement = client.announcements.create(announcement_params)

        expect(announcement.id).to_not be_nil
        expect(announcement.url).to_not be_nil
        expect(announcement.sent_at).to_not be_nil
        expect(announcement.recipients).to match_array(announcement_params[:recipients])
      end
    end

    it "should instantiate an Announcement" do
      VCR.use_cassette("announcement") do
        announcement = client.announcements.create(announcement_params)

        expect(announcement).to be_instance_of(described_class)
      end
    end

    context "with invalid params" do
      it "should raise Layer::Error" do
        VCR.use_cassette("announcement_error") do
          expect{client.announcements.create}.to raise_error(Layer::Error)
        end
      end
    end
  end
end
