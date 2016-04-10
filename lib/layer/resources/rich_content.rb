module Layer
  module Resources
    class RichContent < Layer::Resource
      def self.create(client, url, params = {})
        mime_type = params[:mime_type]
        file = params[:file]

        headers = {
          "Upload-Content-Type" => mime_type,
          "Upload-Content-Length" => file.size.to_s
        }

        response = client.post(url, body: params.to_json, headers: headers)
        response.merge!("mime_type" => mime_type)

        new(response, client).upload(file)
      end

      def upload(file)
        file_header = { "Content-Length" => file.size.to_s }
        client.put(upload_url, body: file, headers: file_header)
        self
      end
    end
  end
end
