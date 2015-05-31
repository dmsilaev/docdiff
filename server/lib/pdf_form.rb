require 'prawn'
require 'prawn/table'
require 'pry'

class PdfForm
  attr_reader :name

  def initialize(options={})
    @first_name = options[:first_name]
    @last_name = options[:last_name]
    @middle_name = options[:middle_name]
    @gender = options[:gender]
    @dob = Date.parse(options[:dob]) if options[:dob] != ""
    @name = "#{Time.now.to_i}.pdf"
  end

  def generate_document!
    pdf = Prawn::Document.new page_size: 'A4',
                              margin: [145,30,145,30]

    pdf.text "Personal Information"
    pdf.table(table_data)

    path = File.expand_path("../../../files/#{@name}", __FILE__)
    pdf.render_file(path)
  end

  protected

  def table_data
    [ ["Name", "#{@first_name} #{@middle_name.upcase} #{@last_name}"],
      ["Gender", "#{@gender}"],
      ["Date of birth", "#{@dob.strftime("%B %d, %Y") unless @dob.nil? }"] ]
  end
end