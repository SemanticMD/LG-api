class LionsController < ApiController
  def show
    @lion = Lion.find(params[:id])

    render json: LionSerializer.new(@lion)
  end

  def index
    @lions = Lion.where(search_params)

    render json: LionsSerializer.new(@lions)
  end

  private

  def search_params
    params.permit(:age, :gender)
  end
end
