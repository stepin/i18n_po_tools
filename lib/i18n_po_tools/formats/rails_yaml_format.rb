require 'yaml'

module I18nPoTools
  module Formats
    #NOTE: Yaml preformatted mode (: | ) do not work
    #TODO: plurals support
    class RailsYamlFormat < BaseFormat
      def read(input_filename)
        content = read_file(input_filename)
        rails_yaml = YAML.load(content)

        locales = rails_yaml.keys
        if locales.length > 1
          raise "Only one language per file supported"
        end

        flat_hash = rails_yaml[locales.first].implode
        #TODO: plurals
        flat_hash
      end

      def write(output_filename, data)
        content  = "# "+banner_msg+"\n"

        data_with_locale = {}
        data_with_locale[options[:language]] = data.explode
        content += data_with_locale.to_yaml
        write_file(output_filename, content)
      end
    end
  end
end