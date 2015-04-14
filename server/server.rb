require 'sinatra'
require 'haml'
require_relative 'doc_diff'

class DocDiffApp < Sinatra::Base
  set :views, "#{File.dirname(__FILE__)}/../views"

  get '/' do
    haml :diff
  end

  post '/diff' do
    tempfiles = params[:files].map { |f| f[:tempfile] }

    @doc_diff = DocDiff.new(tempfiles[0], tempfiles[1])
    @doc_diff.build_html_diff

    haml :diff
  end
end