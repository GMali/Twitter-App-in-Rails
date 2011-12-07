class SessionsController < ApplicationController

  def new
    consumer = OAuth::Consumer.new(APP_CONFIG[:twitter][:consumer_key], APP_CONFIG[:twitter][:consumer_secret], {:site=>"http://twitter.com" })
    req_token = consumer.get_request_token( :oauth_callback => ('http://' + request.env['HTTP_HOST'] + '/authenticate') )
    session[:request_token] = req_token.token
    session[:request_token_secret] = req_token.secret
    
    redirect_to req_token.authorize_url
  end

  def create 
    if params["denied"]
      redirect_to root_path, :notice => "Sign in failed!"
    else
      consumer = OAuth::Consumer.new(APP_CONFIG[:twitter][:consumer_key], APP_CONFIG[:twitter][:consumer_secret], {:site=>"http://twitter.com" })
      req_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
      access_token = req_token.get_access_token
      
      Twitter.configure do |config|
        config.consumer_key = APP_CONFIG[:twitter][:consumer_key]
        config.consumer_secret = APP_CONFIG[:twitter][:consumer_secret]
        config.oauth_token = access_token.token
        config.oauth_token_secret = access_token.secret
      end

      client ||= Twitter::Client.new 
      reset_session
      session[:user_id] = client.user.id
      redirect_to root_path, :notice => "Signed in!"
    end
  end

  def destroy  
    reset_session
    redirect_to root_url, :notice => "Signed out!"  
  end 
end
