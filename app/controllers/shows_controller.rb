class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :analytics]
  before_action :require_band_login, only: [:new, :destroy]

  def index
    @shows = Show.all
  end

  def show
  end

  def analytics
  end
  # def gaticket
  #   @test = 1
  #   binding.pry
  #   # Ticket.create(show_id: @show.id, guest_id: #need guest session data, price: @show.price, type: 'General Admission')
  #   # redirect_to guests_path(#need guestID )
  # end
  #
  # def vipticket
  #   @test1 = 2
  #   binding.pry
  #   # Ticket.create(show_id: @show.id, guest_id: #need guest session data, price: @show.price*1.5, type: 'VIP')
  #   # redirect_to guests_path(#need guestID )
  # end


  def new
    @show = Show.new
  end
  def create
    date = params[:show]["date(1i)"]+ "-" +
      params[:show]["date(2i)"] + "-" +
      params[:show]["date(3i)"] + " " +
      params[:show]["date(4i)"] + ":" +
      params[:show]["date(5i)"]
    @show = Show.new(
      name: params[:show][:name],
      venue_id: params[:show][:venue_id],
      price: params[:show][:price],
      band_id: session[:user]["id"],
      date: date.to_datetime
    )
    if @show.valid?
      @show.save
      redirect_to show_path(@show)
    else
      render :new
    end
  end

  def destroy
    @show = Show.find(params[:id])
    @show.destroy
    redirect_to band_path(session[:user]["id"].to_i)
  end





  private

  def set_show
    @show = Show.find(params[:id])
  end

  def show_params
    params.require(:show).permit()
  end

  def require_band_login
    if session[:user]["bandmates"]
      true
    else
      redirect_to sessions_new_path
    end
  end
end
