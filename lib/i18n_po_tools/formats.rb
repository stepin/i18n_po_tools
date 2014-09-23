require 'i18n_po_tools/formats/base_format'
require 'i18n_po_tools/formats/rails_yaml_format'
require 'i18n_po_tools/formats/basic_flat_yaml_format'
require 'i18n_po_tools/formats/po_format'
require 'i18n_po_tools/formats/ios_format'
require 'i18n_po_tools/formats/android_format'
require 'i18n_po_tools/formats/csv_format'

module I18nPoTools
  module Formats
    class Factory
      def self.get(format)
        case format
        when :rails_yaml
          RailsYamlFormat.new  
        when :flat_yaml
          BasicFlatYamlFormat.new
        when :po
          PoFormat.new
        when :pot
          PoFormat.new(:pot => true)
        when :ios
          IosFormat.new
        when :android
          AndroidFormat.new
        when :csv
          CsvFormat.new
        end
      end
    end
  end
end
