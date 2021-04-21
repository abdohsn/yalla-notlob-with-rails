class GroupsController < ApplicationController
    def new
		@group = current_user.groups
	end

	def create
        @group_params = params[:name]
		#check if the value is null
		if @group_params == ""
			@error_null = {'value': 'You have to put some data in group name'}
			render json: @error_null
		else
			#if the name exist	
			if Group.exists? name: @group_params
				@error_exist = {'value': 'This Group Name is already exist , please change the name'}
				render json: @error_exist
			else
				#it is new group
				@user = current_user
				@group = @user.groups.create(name: @group_params )		
				render json: @group
			end
		end
	end 

	def show
		@group = current_user.groups
	end

	def destroy
		@group = Group.find(params[:id])
		@group.destroy
		@group = current_user.groups
        render :show
		# redirect_to :back
	end
end	
