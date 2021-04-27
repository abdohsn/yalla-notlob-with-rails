class FriendsController < ApplicationController
    before_action :authenticate_user!

    def new
		@friend_to_user = current_user.friends
	end
	
	def create
		@parameter = params[:email]
		
		if  @parameter.empty?
			@error_null = {'value': 'You have to enter some data'}
			render json: @error_null
		else 
            if User.exists? email: @parameter              	
                if @parameter == current_user.email 
                    @error_addSelf = {'same': 'You can not add your self !'}
                    render json: @error_addSelf
                else
                    @fid = User.find_by(email: params[:email])
                    @user = current_user
                    if @user.friendships.exists? friend_id: @fid.id
                        @error_addExist = {'exist': 'You already added this friend !'}
                        render json: @error_addExist
                    else
                        @user = current_user
                        @friend = Friendship.create(user_id: current_user.id, friend_id: @fid.id)
                        render json: @fid
                    end					
                end
            else
                @error_notValid = {'notValid': 'This user is not exist !'}
                render json: @error_notValid				
            end	
		end
			
	end 

	def show
        @friend_to_user = current_user.friends
	end

	def destroy
		@friend = Friendship.find_by(user_id: current_user.id,friend_id: params[:param2])
		@friend.destroy
        @friend_to_user = current_user.friends
		render :show
        # redirect_to root_path
	end
end
