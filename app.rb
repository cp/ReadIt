%w(sinatra httparty json).each { |x| require x }

enable :sessions

get '/' do
	redirect '/login' if session[:email].nil?
  auth = { username: session[:email], password: session[:password] }
  @posts = HTTParty.get("https://api.feedbin.me/v2/entries.json?read=false", basic_auth: auth)

  erb :index
end

get '/read/:id' do
  redirect '/login' if session[:email].nil?
  auth = { username: session[:email], password: session[:password] }
  HTTParty.post("https://api.feedbin.me/v2/unread_entries/delete.json", 
    body: { 'unread_entries' => params[:id] }.to_json, 
    headers: { 'Content-Type' => 'application/json' },
    basic_auth: auth)
  redirect '/'
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