# class OmniauthController < ApplicationController
class OmniauthController < Devise::OmniauthController
    # <--- LESSON --->
    # Step Seventeen:
    # Write a method to handle assigning oauth data to user and error handling.
    
      # def facebook
      # @user = User.create_from_provider_data(request.env['omniauth.auth'])
      #   if @user.persisted?
      #     sign_in_and_redirect @user
      #   else
      #     flash[:error] = 'There was a problem signing you in through Facebook. Please register or try signing in later.'
      #     redirect_to new_user_registration_url
      #   end
      # end
      
      def facebook
        
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.connect_to_facebook(request.env["omniauth.auth"], current_user)
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
          set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
        else
          session["devise.facebook_oauth_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
      # def github
      # @user = User.create_from_provider_data(request.env['omniauth.auth'])
      #   if @user.persisted?
      #     sign_in_and_redirect @user
      #   else
      #     flash[:error] = 'There was a problem signing you in through Github. Please register or try signing in later.'
      #     redirect_to new_user_registration_url
      #   end
      # end
      def github
        
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.connect_to_github(request.env["omniauth.auth"], current_user)
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
          set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
        else
          session["devise.github_oauth_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
  
      # def google_oauth2
      # @user = User.create_from_provider_data(request.env['omniauth.auth'])
      # puts "xxxxxxxxxxxxxxxxxxxxxxxx"
      # puts @user 
      # puts "xxxxxxxxxxxxxxxxxxxxxxxx"
  
      # if @user.persisted?
      #     sign_in_and_redirect @user
      #   else
      #     flash[:error] = 'There was a problem signing you in through Google. Please register or try signing in later.'
      #     redirect_to new_user_registration_url
      #   end
      # end
      def google_oauth2
        
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.connect_to_gmail(request.env["omniauth.auth"], current_user)
        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
          set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
        else
          session["devise.google_oauth2_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
  
      def failure
        flash[:error] = 'There was a problem signing you in. Please register or try signing in later.'
        redirect_to new_user_registration_url
      end
    end