%w(sinatra feedbin json).each { |x| require x }

enable :sessions


class Readit < Sinatra::Application

  helpers do

    def feedbin
      FeedbinAPI.new(session[:email], session[:password])
    end

  end

  get '/' do
    redirect '/login' if session[:email].nil?
    @entries = feedbin.entries(read: false)
    entry_count = @entries.count
    @count = entry_count == 0 ? "no" : entry_count
    redirect '/login' unless @entries.code == 200
    erb :index
  end

  get '/entry/:id' do
    redirect '/login' if session[:email].nil?
    @entry = feedbin.entry(params[:id])
    redirect '/login' unless @entry.code == 200
    erb :entry
  end

  get '/read/all' do
    unread = feedbin.entries(read: false)
    unread.map! { |post| post["id"]}
    response = feedbin.mark_as_read(unread)
    response == 200 ? redirect('/') : "#{response}! Please try again."
  end

  post '/read/:id' do
    feedbin.mark_as_read(params[:id])
  end

  get '/login' do
    erb :login
  end

  post '/subscribe' do
    response = feedbin.subscribe(params[:url])
    if response == 201 || 200
      redirect '/'
    response == 302
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

end
