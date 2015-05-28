# coding: utf-8
require 'nokogiri'

module I18nPoTools
  module Formats
    class AndroidFormat < BaseFormat
      def read(input_filename)
        content = read_file(input_filename)
        doc = Nokogiri.XML(content, nil, 'UTF-8')
        h = {}
        doc.xpath('//resources/string').each do |message_token|
          h[message_token["name"]] = message_token.inner_html
        end
        h
      end

      def write(output_filename, data)
        content  = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        content += "<!-- "+banner_msg+" -->\n"
        content += "<resources>\n\n"
        data.each_pair do |k,v|
          content += "    <string name=\""+(k.nil? ? '':k)+"\">"+(v.nil? ? '':Nokogiri::HTML.fragment(v).to_html)+"</string>\n"
        end if data.present?
        content += "</resources>\n"
        write_file(output_filename, content)
      end
    end
  end
end
