 module SpreeRefineryAuth
  class AuthenticationFailureRedirection < Devise::FailureApp
    # When a user hits a page that they're unauthorised to access, redirect them to the spree login page
    def redirect_url
      spree.login_path
    end

    # Visiting /refinery results in a return_to path of "//refinery", which when redirected to,
    # lands the user at http://refinery. To avoid this, remove the duplicate '/'.
    def store_location!
      session["#{scope}_return_to"] = attempted_path.gsub('//', '/') if request.get? && !http_auth?
    end

    def respond
      if http_auth?
        http_auth
      else
        redirect
      end
    end
  end
end
