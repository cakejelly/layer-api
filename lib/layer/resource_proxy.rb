module Layer
  class ResourceProxy
    attr_accessor :url

    def initialize(client, base, resource)
      @client = client
      @base = base
      @resource = resource
      @url = get_url(base, resource)
    end

    def get_url(base, resource)
      base.nil? ? resource.url : "#{base.url}/#{resource.url}"
    end

    def method_missing(method, *args, &block)
      @resource.public_send(method, *([@client, @url] + args), &block)
    end

    def respond_to_missing?(method, include_private = false)
      @resource.respond_to?(method) || super
    end
  end
end
