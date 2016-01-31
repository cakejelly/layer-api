module Layer
  class ResourceProxy
    def initialize(base, resource)
      @base = base
      @resource = resource
    end

    def url
      @base.nil? ? @resource.url : "#{@base.url}/#{@resource.url}"
    end

    def method_missing(method, *args, &block)
      @resource.public_send(method, *([url] + args), &block)
    end

    def respond_to_missing?(method, include_private = false)
      @resource.respond_to?(method) || super
    end
  end
end
