class GroupsController < ApplicationController
    def new
		@group = current_user.groups
	end

	def create
        @group_params = params[:name]
		#check if the value is null
		if @group_params.empty?
			@error_null = {'value': 'You have to put some data in group name'}
			render json: @error_null
		else
			#if the name exist	
			if Group.exists? name: @group_params
				@error_exist = {'exist': 'This Group Name is already exist , please change the name'}
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


	def getName
		@group = Group.find(params[:id])
		@group_members =[]
		@group.group_members.each do |member|
			@group_members.push(User.find(member.user_id));
		end
	 	@group_data = {name: @group.name , members: @group_members}
		render json: @group_data
	end

	def addFriend
		@friendEmail = params[:email]	
			#check if it is null
		if @friendEmail.empty?
			@error_null = {'nullValue': 'Please insert some data !'}
			render json: @error_null
		else
			#check if it is wrong type
			if User.exists? email: @friendEmail
			#check if he add himself
			if @friendEmail == current_user.email	
				@error_addSelf = {'same': 'You can not add your self !'}
				render json: @error_addSelf
			  else	
			#check if the user exist in the group itself before
				@fid = User.find_by(email: params[:email])
				@current_group = Group.find(params[:groupId])
				if @current_group.group_members.exists? user_id: @fid.id  	  
					@error_addExist = {'addExist': 'This user is already assigned to this group !'}
					render json: @error_addExist
				else
					#check if this user in friendship list or not
					@fid = User.find_by(email: params[:email])
					@user = current_user
					if @user.friendships.exists? friend_id: @fid.id
					@fid = User.find_by(email: params[:email])
					@gid = params[:groupId]
					@group = @fid.group_members.create(group_id: @gid)
					render json: @fid
				    else
					@error_notFriend = {'notFriend': 'This user is not currently in your friend list!'}
					render json: @error_notFriend				    	
				    end
				end					
				
			
			end	
			else
			#it is a robot
			@error_notExist = {'notExist': 'This user is not exist !'}
			render json: @error_notExist
			end	
		end		
		
	
	end #function 

	def deletefriend
		@friend = User.find_by(id: params[:friendId])
		@group_member = GroupMember.find_by(group_id: params[:groupId],user_id: params[:friendId])
		@group_member.destroy
		render json: @friend
	end

	private
	def group_params
		params.require(:group).permit(:name)
	end
end


