# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_locale
  include Pagy::Backend
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  protect_from_forgery unless: -> { request.format.js? }

  layout :layout_by_resource

  protected

  def after_sign_in_path_for(_resource)
    current_user.update(online: true)
    newsfeed_user_path(current_user) # your path
  end

  def after_sign_out_path_for(_resource)
    new_user_session_path
  end

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me name]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  around_action :switch_locale

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def layout_by_resource
    if devise_controller?
      'auth'
    else
      'application'
    end
  end
end
