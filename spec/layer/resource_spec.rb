require 'spec_helper'

describe Layer::Api::Resource do
  describe ".class_name" do
    it "should return class name with module names omitted" do
      expected_name = "Resource"
      class_name = Layer::Api::Resource.class_name

      expect(class_name).to eq(expected_name)
    end
  end

  describe ".pluralized_name" do
    it "should return the class name pluralized" do
      expected_name = "Resources"
      pluralized_name = Layer::Api::Resource.pluralized_name

      expect(pluralized_name).to eq(expected_name)
    end
  end

  describe ".url" do
    it "should return the pluralized class name in lowercase" do
      expected_url = "resources"
      url = Layer::Api::Resource.url

      expect(url).to eq(expected_url)
    end
  end

  describe ".client" do
    it "should return instance of Layer::Api::HttpClient" do
      client = Layer::Api::Resource.client

      expect(client).to be_instance_of(Layer::Api::HttpClient)
    end
  end

  describe "#new" do
    it "should assign attributes to the resource" do
      attributes = {one: "one", two: "two"}
      resource = Layer::Api::Resource.new(attributes)

      expect(resource.attributes).to eq(attributes)
    end
  end

  describe "#client" do
    it "should return instance of Layer::Api::HttpClient" do
      client = Layer::Api::Resource.new({}).client

      expect(client).to be_instance_of(Layer::Api::HttpClient)
    end
  end

  describe "#url" do
    it "should return url from attributes" do
      attributes = {"url" => "http://api.layer.com/url"}
      url = Layer::Api::Resource.new(attributes).url

      expect(url).to eq(attributes["url"])
    end
  end

  describe "#method_missing" do
    context "when key exists in attributes" do
      it "should return the value for that key" do
        key = "key"
        value = "value"
        resource = Layer::Api::Resource.new({key => value})

        expect(resource.key).to eq(value)
      end
    end
    context "when key doesn't exist in attributes" do
      it "should raise NoMethodError" do
        resource = Layer::Api::Resource.new({})
        expect{resource.blah}.to raise_error(NoMethodError)
      end
    end
  end
end
