module ActiveMatchers
  module Matchers
    module ResponseMatchers
      class SuccessMatcher
        def matches?(response)
          @response = response
          response.success?
        end
        
        def failure_message
          "Response should have succeeded, but returned with code #{@response.response_code}."
        end
        
        def negative_failure_message
          "Response should not have succeeded, but did."
        end
      end
      
      class NotFoundMatcher
        def matches?(response)
          @response = response
          response.response_code == 404
        end
        
        def failure_message
          "Response should have had a status of 404 Not Found, but had #{@response.response_code}."
        end
        
        def negative_failure_message
          "Response should not have a status of 404 Not Found, but does."
        end
      end
      
      class RedirectMatcher
        def initialize
          @action = :what
        end
        
        def matches?(response)
          @response = response
          case @action
          when :what
            @response.redirect?
          when :where
            @response.redirect? && @response.redirect_url = @url
          else
            false
          end
        end
        
        def to(url)
          @action = :where
          @url = url
          self
        end
        
        def failure_message
          case @action
          when :what
            "Response should have redirected, but didn't."
          when :where
            "Response should have redirected to #{@url}, but didn't."
          end
        end
        
        def negative_failure_message
          case @action
          when :what
            "Response shouldn't have redirected, but did."
          when :where
            "Response shouldn't have redirected to #{@url}, but did."
          end
        end
      end
    end
  end
end