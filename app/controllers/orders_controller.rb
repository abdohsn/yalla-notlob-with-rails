class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
    @userOrder=UserOrderJoin.all
  end


  # GET /orders/new
  def new
    @order = Order.new
  end



  # POST /orders or /orders.json
  def create
  
    @order=Order.new
    @order.orderType=order_params[:orderType]
    @order.user_id=order_params[:user_id]
    @order.orderFrom=order_params[:orderFrom]
    @order.menuImage=order_params[:menuImage]
    @order.status="unfinished";

    @order.save
  
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
        format.html { redirect_to orders_path, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
    end
  end


  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:orderType, :orderFrom, :menuImage,:user_id,:friendsToAdd)
  end


end









