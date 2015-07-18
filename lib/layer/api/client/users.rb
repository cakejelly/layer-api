module Layer
  module Api
    module Users
      def get_blocklist(user_id)
        JSON.parse(connection.get("users/#{user_id}/blocks").body)
      end

      def block_user(owner_id, user_id)
        params = { user_id: user_id }
        connection.post("users/#{owner_id}/blocks", params.to_json)
      end

      def unblock_user(owner_id, user_id)
        connection.delete("users/#{owner_id}/blocks/#{user_id}")
      end
    end
  end
end
