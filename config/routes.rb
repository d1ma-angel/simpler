Simpler.application.routes do
  get '/tests', 'tests#index'
  post '/tests', 'tests#create'
  get '/tests/:test', 'tests#show'
  get '/tests/:test/questions/:question', 'questions#show'
  get '/tests/:test/questions/:question/:search/', 'questions#show'
end
