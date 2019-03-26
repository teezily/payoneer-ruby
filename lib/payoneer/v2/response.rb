module Payoneer
  module V2
    class Response
      def initialize(response)
        @response = response
      end

      def raw_response
        @response
      end

      def success?
        @response['description'].try(:downcase) == 'success'
      end
    end
  end
end
