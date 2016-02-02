require 'spec_helper'

describe Layer::Resource do
  describe ".class_name" do
    it "should return class name with module names omitted" do
      expected_name = "Resource"
      class_name = Layer::Resource.class_name

      expect(class_name).to eq(expected_name)
    end
  end

  describe ".pluralized_name" do
    it "should return the class name pluralized" do
      expected_name = "Resources"
      pluralized_name = Layer::Resource.pluralized_name

      expect(pluralized_name).to eq(expected_name)
    end
  end

  describe ".url" do
    it "should return the pluralized class name in lowercase" do
      expected_url = "resources"
      url = Layer::Resource.url

      expect(url).to eq(expected_url)
    end
  end

  describe ".client" do
    it "should return instance of Layer::Api::HttpClient" do
      client = Layer::Resource.client

      expect(client).to be_instance_of(Layer::HttpClient)
    end
  end

  describe "#new" do
    it "should assign attributes to the resource" do
      attributes = {one: "one", two: "two"}
      resource = Layer::Resource.new(attributes)

      expect(resource.attributes).to eq(attributes)
    end
  end

  describe "#client" do
    it "should return instance of Layer::Api::HttpClient" do
      client = Layer::Resource.new({}).client

      expect(client).to be_instance_of(Layer::HttpClient)
    end
  end

  describe "#url" do
    it "should return url from attributes" do
      attributes = {"url" => "http://api.layer.com/url"}
      url = Layer::Resource.new(attributes).url

      expect(url).to eq(attributes["url"])
    end
  end

  describe "#uuid" do
    it "should return resource id without layer prefix" do
      uuid = "7f4a44f2-8f98-4990-88ea-1b7e6c087d4b"
      id = "layer:///conversations/#{uuid}"
      resource = described_class.new({"id" => id})

      expect(resource.uuid).to eq(uuid)
      expect(resource.id).to eq(id)
    end

    it "should return nil if no id exists" do
      resource = described_class.new({})

      expect(resource.uuid).to be_nil
    end
  end

  describe "#method_missing" do
    context "when key exists in attributes" do
      it "should return the value for that key" do
        key = "key"
        value = "value"
        resource = Layer::Resource.new({key => value})

        expect(resource.key).to eq(value)
      end
    end
    context "when key doesn't exist in attributes" do
      it "should raise NoMethodError" do
        resource = Layer::Resource.new({})
        expect{resource.blah}.to raise_error(NoMethodError)
      end
    end
  end
end
