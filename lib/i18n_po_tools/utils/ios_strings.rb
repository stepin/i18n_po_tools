# Format description:
# https://developer.apple.com/library/mac/documentation/macosx/conceptual/bpinternational/Articles/StringsFiles.html
#
# Example:
# /* Insert Element menu item */
# "Insert Element" = "Insert Element";
# "Windows must have at least %d columns and %d rows." =
# "Les fenêtres doivent être composes au minimum de %d colonnes et %d lignes.";
# "File %@ not found." = "Le fichier %@ n’existe pas.";
# "%@ Error! %@ failed!" = "%2$@ blah blah, %1$@ blah!";
# "File \"%@\" cannot be opened" = " ... ";
#
# Localizable.strings is a default filename.
# It is recommended that you save strings files using the UTF-16 encoding.
#
# Use /usr/bin/plutil -lint (part of Mac OS X) to check for syntax errors. 
#
class IosStrings
  DEFAULT_FILE_NAME = 'Localizable.strings'
  EXTENSION = '.strings'

  # From https://github.com/mobiata/twine/blob/master/lib/twine/encoding.rb
  def self.encoding_for_path(path)
    File.open(path, 'rb') do |f|
      begin
        a = f.readbyte
        b = f.readbyte
        if (a == 0xfe && b == 0xff)
          return 'UTF-16BE'
        elsif (a == 0xff && b == 0xfe)
          return 'UTF-16LE'
        end
      rescue EOFError
      end
    end

    'UTF-8'
  end

  def self.strings_to_hash(data)
    data = data.encode('UTF-8')
    h = {}

    #remove comments
    data.gsub!(/\/\*.*\*\//,'') # /* lala */
    data.gsub!(/^\s*\/\/.*/,'') # // lala

    regexp = /"((?:[^"\\]|\\.)+)"\s*=\s*"((?:[^"\\]|\\.)*)"/
    data.split("\n").each do |line|
      match = regexp.match(line)
      next unless match

      key = unescape(match[1])
      value = unescape(match[2])

      h[key] = value
    end

    h
  end

  def self.hash_to_strings(h, comment = '')      
    content = ""
    content = "/* "+comment.gsub('*/','* /')+" */\n" if comment.present?

    h.each_pair do |k,v|
      key = escape(k)
      value = escape(v)
      content += %Q{"#{key}" = "#{value}";\n}
    end unless h.nil?

    content
  end

  private
  def self.escape(s)
    (s||"").gsub('"','\"')
  end

  def self.unescape(s)
    (s||"").gsub('\"','"')
  end
end