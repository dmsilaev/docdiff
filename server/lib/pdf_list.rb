require 'prawn'
require 'pry'

class PdfList
  def initialize(options={})
    @paragraphs = options.fetch(:paragraphs, [])
  end

  def generate_document(max_font_size)
    pdf = Prawn::Document.new background: background, page_size: 'A4',
                              margin: [145,30,145,30]
    pdf.font_size max_font_size

    @paragraphs.each do |p|
      pdf.text p
      pdf.move_down(5)
    end

    if pdf.page_count > 1
      return false if pdf.font_size == 1
      return generate_document(max_font_size - 1)
    end

    pdf
  end

  protected

  def background
    File.expand_path('../pdf_list/bg1.jpg', __FILE__)
  end
end