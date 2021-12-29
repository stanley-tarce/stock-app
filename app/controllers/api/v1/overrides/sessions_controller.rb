module Api
  module V1
    module Overrides
      class SessionsController < DeviseTokenAuth::SessionsController
        def render_create_success
          render json: {data: ActiveModelSerializers::SerializableResource.new(@resource, serializer: UserSerializer).as_json}, status: 200
        end
      end
    end
  end
end