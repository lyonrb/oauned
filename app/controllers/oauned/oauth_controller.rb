require 'uri'

class Oauned::OauthController < ApplicationController
  before_filter :validate_params
  before_filter :oauned_check_authentication, :except => :token
  skip_before_filter :verify_authenticity_token, :only => :token

  def index
    ##
    # If the application has the no_confirmation attribute set to true, we don't ask for confirmation.
    # See https://github.com/dmathieu/oauned/wiki/Skip-Authorization
    #
    return authorize if client.respond_to?(:no_confirmation) && client.no_confirmation
  end

  def authorize
    authorization = client.authorize!(current_user)
    state_param = params[:state].blank? ? "" : "&state=#{CGI.escape(params[:state])}"
    redirect_to "#{params[:redirect_uri]}?code=#{authorization.code}&expires_in=#{authorization.expires_in}#{state_param}"
  end

  def token
    if refresh_token?
      original_token = Oauned::Models['connection'].where(['refresh_token LIKE ?', params[:refresh_token]]).first
      if original_token.nil? || original_token.application_id != client.id
        return render_error("Refresh token is invalid", "invalid-grant")
      end
      token = original_token.refresh
    else
      authorization = Oauned::Models['authorization'].where(['code LIKE ?', params[:code]]).first
      if authorization.nil? || authorization.expired? || authorization.application_id != client.id
        return render_error("Authorization expired or invalid", "invalid-grant")
      end
      token = authorization.tokenize!
    end

    render :json => {
      :access_token => token.access_token,
      :refresh_token => token.refresh_token,
      :expired_in => token.expires_in
    }
  end

  private
  def client
    @client ||= Oauned::Models['application'].find params[:client_id]
  end

  def validate_params
    validate_client && validate_uri
    !performed?
  end

  def validate_client
    if params[:client_id].blank? || (action_needs_client_secret? && client.try(:consumer_secret) != params[:client_secret])
      render_error "Invalid client credentials", "invalid-client-credentials"
    elsif client.nil?
      render_error "Invalid client id", "invalid-client-id"
    end
    !performed?
  end

  def validate_uri
    if params[:redirect_uri].blank?
      render_error "You did not specify the 'redirect_uri' parameter", "invalid-redirect-uri"
    elsif URI.parse(client.redirect_uri).host != URI.parse(params[:redirect_uri]).host
      render_error "The redirect_uri mismatch the one in the application", "redirect-uri-mismatch"
    end
    !performed?
  end

  def oauned_check_authentication
    return if !!current_user
    session[:redirect_uri] = request.fullpath
    redirect_to self.respond_to?(:new_user_session_url) ? new_user_session_url : '/'
  end

  def render_error(message, code)
    if action_needs_client_secret? || !params[:redirect_uri]
      render :status => :bad_request,
        :json => {:error => code, :error_description => message}
    else
      redirect_to "#{params[:redirect_uri]}?error=#{code}"
    end
  end

  def action_needs_client_secret?
    params[:action] == "token"
  end

  def refresh_token?
    params[:grant_type] == 'refresh_token'
  end
end
