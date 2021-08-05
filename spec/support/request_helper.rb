# frozen_string_literal: true

module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end

  module HeaderHelpers
    def headers(token)
      {
        Authorization: "Bearer #{token}"
      }
    end
  end

  module AuthenticateHelpers
    def authenticate(username, password)
      post sessions_path, params: { username: username, password: password }
      json['token']
    end
  end
end
