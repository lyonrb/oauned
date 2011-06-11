require 'uri'

class Oauned::OauthController < ApplicationController
  before_filter :oauned_check_authentication, :except => :token
  skip_before_filter :verify_authenticity_token, :only => :token
  
  def index
    return unless validate_params
    ## 
    # If the application has the no_confirmation attribute set to true, we don't ask for confirmation.
    # See https://github.com/dmathieu/oauned/wiki/Skip-Authorization
    #
    return authorize if @client.respond_to?(:no_confirmation) && @client.no_confirmation
  end
  
  def authorize
    return unless validate_params
    
    authorization = @client.authorize!(current_user)
    state_param = params[:state].blank? ? "" : "&state=#{CGI.escape(params[:state])}"
    redirect_to "#{params[:redirect_uri]}?code=#{authorization.code}&expires_in=#{authorization.expires_in}#{state_param}"
  end
  
  def token
    #
    # Deactivated for now
    # It seems if we don't have any, it's an autorization-code
    #   
    #unless ['authorization-code', 'refresh-token'].include?(params[:grant_type])
    #  render :status => :bad_request,
    #    :json => {:error => 'unsupported-grant-type', :error_description => "Grant type #{params[:grant_type]} is not supported!"}
    #  return
    #end
    
    @client = Application.find params[:client_id]
    if @client.nil? || @client.consumer_secret != params[:client_secret]
      render :status => :bad_request,
        :json => {:error => 'invalid-client-credentials', :error_description => 'Invalid client credentials!'}
      return
    end
    
    if params[:redirect_uri].nil? || URI.parse(@client.redirect_uri).host != URI.parse(params[:redirect_uri]).host
      render :status => :bad_request,
        :json => {:error => 'invalid-grant', :error_description => 'Redirect uri mismatch!'}
      return
    end
    
    if params[:grant_type] == 'refresh-token'
      original_token = Connection.where(['refresh_token LIKE ?', params[:refresh_token]]).first
      if original_token.nil? || original_token.application_id != @client.id
        render :status => :bad_request,
          :json => {:error => 'invalid-grant', :error_description => 'Refresh token is invalid!'}
        return
      end
      token = original_token.refresh
    else
      authorization = Authorization.where(['code LIKE ?', params[:code]]).first
      if authorization.nil? || authorization.expired? || authorization.application_id != @client.id
        render :status => :bad_request,
          :json => {:error => 'invalid-grant', :error_description => "Authorization expired or invalid!"}
        return
      end
      token = authorization.tokenize!
    end
    render :content_type => 'application/json', :json => {:access_token => token.access_token, :expired_in => token.expires_in}
  end
  
  private
  def validate_params
    if params[:client_id].blank?
      render :text => "You did not specify the 'client_id' parameter!", :status => :bad_request
      return false
    end
    
    #unless ['code'].include?(params[:response_type])
    #  redirect_to "#{params[:redirect_uri]}?error=unsupported-response-type"
    #  return
    #end
    
    if params[:redirect_uri].blank?
      render :text => "You did not specify the 'redirect_uri' parameter!", :status => :bad_request
      return false
    end
    
    @client = Application.find params[:client_id]
    if @client.nil?
      redirect_to "#{params[:redirect_uri]}?error=invalid-client-id"
      return false
    end
    
    if URI.parse(@client.redirect_uri).host != URI.parse(params[:redirect_uri]).host
      redirect_to "#{params[:redirect_uri]}?error=redirect-uri-mismatch"
      return false
    end
    
    true
  end
  
  def oauned_check_authentication
    return if !!current_user
    session[:redirect_uri] = request.fullpath
    redirect_to self.respond_to?(:new_user_session_url) ? new_user_session_url : '/'
  end
end
