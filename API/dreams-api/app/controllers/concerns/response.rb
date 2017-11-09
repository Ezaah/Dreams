module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def plain_response(object, status = :ok)
    render plain: object, status: status
  end
end
