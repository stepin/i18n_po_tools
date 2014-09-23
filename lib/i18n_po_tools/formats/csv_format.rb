require 'csv'

module I18nPoTools
  module Formats
    class CsvFormat < BaseFormat
      def read(input_filename)
        content = read_file(input_filename)
        h = {}
        first = true
        CSV.parse(content) do |row|
          if first
            first = false
          else
            h[row[0]] = row[1]
          end
        end
        h
      end

      def write(output_filename, data)
        content = CSV.generate do |csv|
          csv << ["Key","Translation"]
          data.each_pair do |k,v|
            csv << [k,v]
          end if data.present?
        end
        write_file(output_filename, content)
      end
    end
  end
end
