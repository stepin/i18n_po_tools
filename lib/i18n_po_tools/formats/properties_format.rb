require 'java-properties'

module I18nPoTools
  module Formats
    class PropertiesFormat < BaseFormat
      def read(input_filename)
        h = JavaProperties.load(input_filename)
        h
      end

      def write(output_filename, data)
        content = JavaProperties.generate(hash)
        write_file(output_filename, content)
      end
    end
  end
end
