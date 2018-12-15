class QuestionsController < Simpler::Controller

  def show
    status 200
    @params = params
  end

end
