require 'word-to-markdown'
require 'wdiff'

class DocDiff
  ACCEPTED_FORMATS = %w(.doc .docx)

  attr_accessor :before_doc, :after_doc
  attr_reader :html_diff, :errors

  def initialize(before_doc, after_doc)
    @before_doc, @after_doc = before_doc, after_doc
    @errors = []
  end

  def build_html_diff
    check_supported_formats
    return false unless @errors.empty?

    before_md, after_md = create_markdown(@before_doc), create_markdown(@after_doc)
    @html_diff = Wdiff::Helper.to_html(before_md, after_md).gsub("\n", '<br>')
  end

  protected

  def docs
    [@before_doc, @after_doc]
  end

  def check_supported_formats
    docs.each do |doc|
      extname = File.extname(doc)
      @errors.push("формат '#{extname}' не поддерживается") unless ACCEPTED_FORMATS.include?(extname)
    end
  end

  def create_markdown(doc)
    WordToMarkdown.new(doc)
  end
end
