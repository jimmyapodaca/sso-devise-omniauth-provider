class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_omniauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      #this will throw if @user is not activated
      sign_in_and_redirect @user, :event => :authentication 
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
