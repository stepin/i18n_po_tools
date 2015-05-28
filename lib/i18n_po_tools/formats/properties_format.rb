# coding: utf-8
require 'java-properties'

module I18nPoTools
  module Formats
    class PropertiesFormat < BaseFormat
      def read(input_filename)
        content = read_file(input_filename)
        props = JavaProperties.parse(content)
        h = {}
        props.each{|key,value| h[key.to_s]=value }
        h
      end

      def write(output_filename, data)
        content = JavaProperties.generate(hash)
        write_file(output_filename, content)
      end
    end
  end
end
