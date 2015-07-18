module Layer
  module Api
    module Users
      def get_blocklist(user_id)
        get("users/#{user_id}/blocks")
      end

      def block_user(owner_id, user_id)
        params = { user_id: user_id }
        post("users/#{owner_id}/blocks", body: params.to_json)
      end

      def unblock_user(owner_id, user_id)
        connection.delete("users/#{owner_id}/blocks/#{user_id}")
      end
    end
  end
end
