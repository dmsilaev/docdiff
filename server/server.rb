require 'sinatra'
require 'slim'
require_relative 'lib/doc_diff'
require_relative 'lib/pdf_list'
require_relative 'lib/pdf_form'

class DocDiffApp < Sinatra::Base
  set :views, "#{File.dirname(__FILE__)}/../views"

  get '/' do
    slim :index
  end

  get '/diff' do
    slim :diff
  end

  post '/diff' do
    tempfiles = params[:files].map { |f| f[:tempfile] }

    @doc_diff = DocDiff.new(tempfiles[0], tempfiles[1])
    @doc_diff.build_html_diff

    slim :diff
  end

  get '/pdf' do
    slim :pdf
  end

  post '/pdf' do
    content_type 'application/pdf'

    @pdf_list = PdfList.new(paragraphs: params[:fields])
    @doc = @pdf_list.generate_document(16)
    raise 'Невозможно сгенерировать одну страничку, даже с минимальным размером шрифта' unless @doc

    @doc.render
  end

  post '/pdf-form' do
    pdf_form = PdfForm.new params
    pdf_file = pdf_form.generate_document!

    "/files/#{pdf_form.name}"
  end

  get '/files/:file' do
    send_file(File.expand_path("../../files/#{params[:file]}", __FILE__), :disposition => 'inline')
  end
end