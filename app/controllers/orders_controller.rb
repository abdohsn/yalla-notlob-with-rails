class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]



  def index
    @orders = Order.all
    @userOrder=UserOrderJoin.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
    @order=Order.find(params[:id])
    @order.update(status: 'finished')
    @order.users.each do |user|
      if user.id != @order.user_id
        @msg = current_user.full_name + ' marked his order ' + @order.orderType + ' as finished' 
        ActionCable.server.broadcast("notification_channel", { body: @msg, userId: user.id})
        @notificationDict  =  { :body => @msg, :user => user , :notificationType => "order finished",:seen => false}

        @notification = Notification.new(@notificationDict)
        @notification.save
      end
    end
    redirect_to orders_path
  end




  def create
  
    @order=Order.new
    @order.orderType=order_params[:orderType]
    @order.user_id=order_params[:user_id]
    @order.orderFrom=order_params[:orderFrom]
    @order.menuImage=order_params[:menuImage]
    @order.status="unfinished";
    notValidEmails=[]
    @order.save
    usersToAdd=order_params[:friendsToAdd].split(" ")
    
    usersToAdd.each do |user|
            @currentFriend=User.find_by(email:user)
      @dict  =  { :user =>@currentFriend , :order => @order}
      @userOrder=UserOrderJoin.new(@dict)
      @userOrder.save
    end
    @currentUser=User.find(order_params[:user_id])
    @dict  =  { :user =>@currentUser , :order => @order}
      @userOrder=UserOrderJoin.new(@dict)
      @userOrder.save

    uploaded_io = params[:order][:menuImage]
File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
  file.write(uploaded_io.read)
end
@order.menuImage=uploaded_io.original_filename

    respond_to do |format|
      if @order.save 
        @order.users.each do |user|
          if user.id != @order.user_id
            @msg = current_user.full_name + ' add you to his order ' + @order.orderType 
            ActionCable.server.broadcast("notification_channel", { body: @msg, userId: user.id})
            @notificationDict  =  { :body => @msg, :user => user , :notificationType => "add new order",:seen => false}
    
            @notification = Notification.new(@notificationDict)
            @notification.save
          end
        end
        format.html { redirect_to orders_path, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end


def update    
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order.users.each do |user|
      if user.id != @order.user_id
        @msg = current_user.full_name + ' deleted his order ' + @order.orderType 
        ActionCable.server.broadcast("notification_channel", { body: @msg, userId: user.id})
        @notificationDict  =  { :body => @msg, :user => user , :notificationType => "order deleted",:seen => false}

        @notification = Notification.new(@notificationDict)
        @notification.save
      end
    end
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:orderType, :orderFrom, :menuImage,:user_id,:friendsToAdd)
    end


end
