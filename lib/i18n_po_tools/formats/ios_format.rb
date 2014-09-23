require 'i18n_po_tools/utils/ios_strings'

module I18nPoTools
  module Formats
    class IosFormat < BaseFormat
      def read(input_filename)
        content = read_file(input_filename)
        IosStrings.strings_to_hash(content)
      end

      def write(output_filename, data)
        content = IosStrings.hash_to_strings(data,banner_msg)
        write_file(output_filename, content)
      end
    end
  end
end