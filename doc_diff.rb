require 'wdiff'

class DocDiff
  class Error < StandardError; end

  class << self
    ACCEPTED_FORMATS = %w(.doc .docx)

    def build(tmp_files)
      @tmp_files = tmp_files

      fail DocDiff::Error, 'несоответствие форматов' if File.extname(before_tmp) != File.extname(after_tmp)
      fail DocDiff::Error, 'неверный формат' unless ACCEPTED_FORMATS.include?(File.extname(before_tmp))

      tmp_files_to_md!
      md_diff!.gsub "\n", '<br>'
    end

    def tmp_files_to_md!
      @before_md = WordToMarkdown.new(before_tmp.path)
      @after_md = WordToMarkdown.new(after_tmp.path)
    end

    def md_diff!
      Wdiff::Helper.to_html @before_md.to_s, @after_md.to_s
    end

    private

    def before_tmp
      @tmp_files.first
    end

    def after_tmp
      @tmp_files.last
    end
  end
end
