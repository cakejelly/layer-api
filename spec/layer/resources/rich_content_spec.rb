require "spec_helper"
require "webmock/rspec"

describe Layer::Resources::RichContent do
  let(:client) { Layer::Platform::Client.new.client }
  let(:url) { "conversations/1234/content" }
  let(:file) { File.open("spec/layer/fixtures/image.png") }
  let(:content_response) { File.read("spec/layer/fixtures/rich_content.json") }
  let(:uploaded_content_response) { File.read("spec/layer/fixtures/google_storage.json") }

  describe "#create" do
    before do
      stub_request(:post, /content/).
        to_return(body: content_response)

      stub_request(:put, /www.googleapis.com/ ).
        to_return(body: uploaded_content_response)
    end

    it "should initiate rich content upload" do
      content = described_class.create(client, url, {mime_type: "image/png", file: file})
      expect(content).to be_instance_of(Layer::Resources::RichContent)
      expect(content.upload_url).to_not be_nil
    end
  end
end
