class TestsController < Simpler::Controller

  def index
    @time = Time.now

    status 200
    render plain: "Time is now #{@time}"
  end

  def create

  end

end
