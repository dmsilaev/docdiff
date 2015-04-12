require 'bundler'
Bundler.require

require './doc_diff'

class Server < Sinatra::Base
  get '/' do
    haml :diff
  end

  # Обработку ошибок всяких не делаю, просто в лоб.
  post '/diff' do
    @diff_html = DocDiff.build params[:files].map { |f| f[:tempfile] }

    haml :diff
  end
end