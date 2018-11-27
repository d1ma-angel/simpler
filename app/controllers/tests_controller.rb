class TestsController < Simpler::Controller

  def index
    @time = Time.now

    render plain: "Time is now #{@time}"
  end

  def create

  end

end
