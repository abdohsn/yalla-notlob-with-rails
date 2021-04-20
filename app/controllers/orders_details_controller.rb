class OrdersDetailsController < ApplicationController
  def index
    # @ownerId = Order.where(id: params[:order_id]).take.user_id
    @orderJoins = UserOrderJoin.where(order_id: params[:order_id])
    # .push(@ownerId)
    # @orderUsersIds.push(@ownerId)
    # abort @orderJoins.length().inspect
    if @orderJoins.pluck(:user_id).include? current_user.id
      @order_id = params[:order_id]
      @order = Order.find(params[:order_id])
      # abort @order.user_id.inspect
    else
      redirect_to orders_path
    end    
  end

  def create
    @order_users=[]
    @newItem = OrderDetail.new(details_params)
    if @newItem.save
      @order = Order.find(params[:order_id])
      @order.user_order_joins.each do |order_join|
        @order_users.push(order_join.user_id)
      end

      @itemDetails = {:name => current_user.full_name, :item_name => details_params[:item_name],:amount => details_params[:amount], :price=>details_params[:price],:comment=>details_params[:comment]}
       ActionCable.server.broadcast("notification_channel", {header: "new item", users: @order_users , order_id: params[:order_id], orderItem: @itemDetails})
    else
      redirect_to orders_path
    end
end

  private
  def details_params
    @joinsId = UserOrderJoin.where(order_id: params[:order_id],user_id: current_user.id).take.id
    params.require(:item).permit(:item_name,:amount,:price,:comment).merge!(
      user_order_join_id: @joinsId
    )
  end
end
