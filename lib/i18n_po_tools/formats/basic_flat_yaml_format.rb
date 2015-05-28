# coding: utf-8
require 'yaml'

module I18nPoTools
  module Formats
    class BasicFlatYamlFormat < BaseFormat
      def read(input_filename)
        content = read_file(input_filename)
        flat_hash = YAML.load(content)
      end

      def write(output_filename, data)
        content  = "# "+ banner_msg + "\n"
        content += data.to_yaml
        write_file(output_filename, content)
      end
    end
  end
end
