class OrderMembersController < ApplicationController
  def create
   if params[:email][0]=="#"
    @groupName=params[:email][1..params[:email].length()]

    if Group.where(name: @groupName,user_id:current_user.id).any?
     
      @usersInGroup=Group.where(name: @groupName,user_id:current_user.id)[0].users
      ActionCable.server.broadcast("notification_channel", {header: "validate email", body: "group valid" , userId: current_user.id ,groupName: @usersInGroup})
      @usersInGroup.each do |user|
        validateEmail(user[:email])
               
    end

    else
      ActionCable.server.broadcast("notification_channel", {header: "validate email", body: "group invalid" , userId: current_user.id ,groupName: @groupName})
   end
   else
     validateEmail(params[:email])

  end

    # ActionCable.server.broadcast("notification_channel", {header: "validate email", body: params[:email] , userId: current_user.id})
  end
  def validateEmail(email)
    if !email.match(/^[a-z]+[0-9\._a-z]+@[a-z]+\.com$/)
      ActionCable.server.broadcast("notification_channel", {header: "validate email", body: "email is not valid" , userId: current_user.id})



    elsif User.where(email: email).take!= nil && User.where(email: email).take.id ==current_user.id
      ActionCable.server.broadcast("notification_channel", {header: "validate email", body: "you can't add yourself" , userId: current_user.id})

    else
      @my_friend_user = User.find_by(email:email)
      @user = User.find(current_user.id)
      @existed_friend  = Friendship.where(user_id: @user,friend_id: @my_friend_user)

      if @existed_friend == []
        ActionCable.server.broadcast("notification_channel", {header: "validate email", body: "you don't have this friend " , userId: current_user.id , email:email})
      else
        ActionCable.server.broadcast("notification_channel", {header: "validate email", body: "valid" , userId: current_user.id , email:email , friend: @existed_friend} )
        end

    end
  end
end
