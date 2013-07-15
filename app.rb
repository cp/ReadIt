%w(sinatra feedbin httparty json).each { |x| require x }

enable :sessions

get '/' do
	redirect '/login' if session[:email].nil?
  auth = { username: session[:email], password: session[:password] }
  @posts = HTTParty.get("https://api.feedbin.me/v2/entries.json?read=false", basic_auth: auth)
  redirect '/login' if @posts.code != 200
  erb :index
end

get '/read/all' do
  fb = Feedbin::API.new(session[:email], session[:password])
  posts = HTTParty.get("https://api.feedbin.me/v2/entries.json?read=false", basic_auth: { username: session[:email], password: session[:password] })
  to_delete = posts.map { |post| post["id"]}
  response = fb.mark_as_read(to_delete)
  if response.code == 200
    redirect '/'
  else
    "#{posts.code}! Please try again."
  end
end

get '/read/:id' do
  fb = Feedbin::API.new(session[:email], session[:password])
  response = fb.mark_as_read(params[:id])
  if response.code == 200
    redirect '/'
  else
    "#{posts.code}! Please try again."
  end
end

get '/login' do
  erb :login
end

post '/login' do
  redirect '/login' if params[:email].nil? || params[:password].nil? 
  session[:email] = params[:email]
  session[:password] = params[:password]
  redirect '/'
end

get '/logout' do
  redirect '/login' if session[:email].nil?
  session[:email] = nil
  session[:password] = nil
  redirect '/'
end