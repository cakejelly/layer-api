require "spec_helper"

describe Layer::ResourceProxy do
  let(:client) { Layer::Platform::Client.new.client }

  describe "#new" do
    it "should assign a HttpClient instance" do
      http_client = Layer::Platform::Client.new.client
      proxy = described_class.new(http_client, nil, nil)

      expect(proxy.instance_variable_get("@client")).to eq(http_client)
    end

    it "should assign a base resource" do
      base = Class.new
      proxy = described_class.new(nil, base, nil)

      expect(proxy.instance_variable_get("@base")).to eq(base)
    end

    it "should assign a target resource" do
      target = Class.new
      proxy = described_class.new(nil, nil, target)

      expect(proxy.instance_variable_get("@resource")).to eq(target)
    end

    it "should require a base resource" do
      expect {described_class.new}.to raise_error(ArgumentError)
    end

    it "should require a target resource" do
      expect {described_class.new(nil)}.to raise_error(ArgumentError)
    end
  end

  describe "#url" do
    context "with base resource present" do
      it "should return combination of base & target resource urls" do
        base_url = "base"
        target_url = "target"
        base_resource = Layer::Resource.new({"url" => base_url}, client)
        target_resource = Layer::Resource.new({"url" => target_url}, client)

        resource_proxy = Layer::ResourceProxy.new(client, base_resource, target_resource)

        expect(resource_proxy.url).to eq("#{base_url}/#{target_url}")
      end
    end

    context "with no base resource present" do
      it "should return target resource url" do
        target_resource = Layer::Resource
        resource_proxy = Layer::ResourceProxy.new(client, nil, target_resource)

        expect(resource_proxy.url).to eq(target_resource.url)
      end
    end
  end

  describe "#method_missing" do
    context "when target resource has method" do
      it "should pass method call to target resource" do
        target_resource = Layer::Resource
        resource_proxy = Layer::ResourceProxy.new(client, nil, target_resource)

        expect(target_resource).to receive(:create)
        resource_proxy.create
      end
    end

    context "when target resource doesn't have method" do
      it "should raise NoMethodError" do
        target_resource = Layer::Resource
        resource_proxy = Layer::ResourceProxy.new(client, nil, target_resource)

        expect {resource_proxy.blah}.to raise_error(NoMethodError)
      end
    end
  end
end
