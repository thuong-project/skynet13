class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    generic_callback('facebook')
  end

  def google_oauth2
    generic_callback('google_oauth2')
  end

  def generic_callback(provider)
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    params = request.env['omniauth.params']
    I18n.locale = params['locale']

    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else

      flash[:errors] = flash[:errors].to_a.concat @user.errors.full_messages
      session["devise.#{provider}_data"] = request.env['omniauth.auth'].uid # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
