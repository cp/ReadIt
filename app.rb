%w(sinatra feedbin json).each { |x| require x }

enable :sessions

get '/' do
  redirect '/login' if session[:email].nil?
  FB = FeedbinAPI.new(session[:email], session[:password])
  @posts = FB.entries(read: false)
  redirect '/login' unless @posts.code == 200
  erb :index
end

get '/read/all' do
  unread = FB.entries(read: false)
  unread.map! { |post| post["id"]}
  response = FB.mark_as_read(to_delete)
  if response == 200
    redirect '/'
  else
    "#{posts}! Please try again."
  end
end

get '/read/:id' do
  response = FB.mark_as_read(params[:id])
  if response == 200
    redirect '/'
  else
    "#{response}! Please try again."
  end
end

get '/login' do
  erb :login
end

post '/subscribe' do
  response = FB.subscribe(params[:url])
  if response == 201 || 200
    redirect '/'
  elsif response == 302
    "You have already subscribed to this feed."
  elsif response == 300
    "There are multiple feeds at this URL. We do not support choosing yet."
  else
    "#{response}! Please try again."
  end
end

post '/login' do
  redirect '/login' if params[:email].nil? || params[:password].nil? 
  session[:email], session[:password] = params[:email], params[:password]
  redirect '/'
end

get '/logout' do
  redirect '/login' if session[:email].nil?
  session[:email] = params[:password] = nil, nil
  redirect '/'
end
