class TestsController < Simpler::Controller

  def index
    @time = Time.now

    status 200
    headers['Some-Header'] = 'Some-Text'
    render plain: "Time is now #{@time}"
  end

  def create

  end

  def show
    set_test
    status 200
  end

  private

  def set_test
    @id = params['id']
  end

end
