#
# Fixes for pomo gem
#
module GetPomo
  class Translation
    def add_comment(value)
      @comment += "\n" if @comment.present?
      @comment += value.strip
    end

    def as_header(headers)
      self.msgctxt = nil
      self.msgid = ""
      self.msgstr = headers.map{|(k,v)| k.to_s+": "+v.to_s+"\\n\n" }.join('')
    end

    def fix_after_read
      self.msgctxt = unescape(@msgctxt)

      self.msgid = if @msgid.is_a?(Array)
        @msgid.map do |msgid|
          unescape(msgid)
        end
      else
        unescape(@msgid)
      end

      self.msgstr = if @msgstr.is_a?(Array)
        @msgstr.map do |msgstr|
          unescape(msgstr)
        end
      else
        unescape(@msgstr)
      end
    end

    def fix_before_save
      self.msgctxt = escape(@msgctxt)

      self.msgid = if @msgid.is_a?(Array)
        @msgid.map do |msgid|
          wrap_and_escape(msgid)
        end
      else
        wrap_and_escape(@msgid)
      end

      self.msgstr = if @msgstr.is_a?(Array)
        @msgstr.map do |msgstr|
          wrap_and_escape(msgstr)
        end
      else
        wrap_and_escape(@msgstr)
      end
    end

    private
    def escape(str)
      return nil if str.nil?
      return str if header?
      #TODO: better \ escapes?
      str.gsub('"','\"').gsub('\\','\\\\\\')
    end

    def unescape(str)
      return nil if str.nil?
      str.gsub('\\\\','\\').gsub('\"','"')
    end

    def wrap_and_escape(str, line_width = 80)
      return nil if str.nil?

      lines = str.split(/\n|\r\n/).map do |line|
        if line.length > line_width
          line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1 \n")[0...-2]
        else
          line
        end
      end.join("\n").split("\n")
      if lines.count > 1
        "\"\n\""+lines.map{|line| escape(line) }.join("\"\n\"")
      else
        escape(str)
      end
    end
  end
end
