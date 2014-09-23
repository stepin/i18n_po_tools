require 'get_pomo'
require 'i18n_po_tools/utils/po'
require 'i18n_po_tools/utils/data'
require 'i18n_po_tools/plural_message'

module I18nPoTools
  module Formats
    class PoFormat < BaseFormat
      def initialize(options = {})
        @pot = options.fetch(:pot, false)
      end

      def read(input_filename)
        content = read_file(input_filename)

        translations = GetPomo::PoFile.parse(content)
        h = {}
        translations.each do |t|
          t.fix_after_read

          key = t.msgctxt
          if key.blank?
            if t.msgid.present?
              STDERR.puts "WARNING: #{msgid} can not be imported (empty key in the msgctxt field)"
            end
            next
          end

          if t.plural?
            if @pot
              h[key] = PluralMessage.new(translations: t.msgid)
              STDERR.puts "WARNING: Plural forms for #{key} can be trancated (only 2 forms for msgid, format limitation)"
            else
              h[key] = PluralMessage.new(translations: t.msgstr)
            end
          else
            if @pot
              h[key] = t.msgid
            else
              h[key] = t.msgstr
            end
          end
        end
        h
      end

      def write_with_options(data, base_data, options)
        @options = options

        translations = []
        translations << header_entity(@pot)

        if @pot
          data.each do |k,v|
            translations << message_entity(k,v,nil)
          end
        else
          base_data.each do |k,v|
            translations << message_entity(k,v,data[k])
          end
        end

        po = GetPomo::PoFile.new(:translations=>translations)
        content = po.to_text
        write_file(options[:output_filename], content)
      end

      private
      def message_entity(key,base,translated)
        base = base.presence || key

        msg = GetPomo::Translation.new
        msg.msgctxt = key
        if base.is_a?(PluralMessage)
          msg.msgid = base.to_a
          if translated.present?
            msg.msgstr = translated.is_a?(PluralMessage) ? translated.to_a : [translated]
          else
            msg.msgstr = nil
          end
        else
          msg.msgid = base
          msg.msgstr = translated
        end
        msg.fix_before_save
        msg
      end

      def header_entity(pot)
        headers = {}
        headers["X-Generator"] = banner_msg
        headers["Project-Id-Version"] = "PACKAGE VERSION"
        headers["POT-Creation-Date"] = Time.now
        headers["PO-Revision-Date"] = "YEAR-MO-DA HO:MI+ZONE"
        headers["Last-Translator"] = "FULL NAME <EMAIL@ADDRESS>"
        unless pot
          headers["Language"] = options[:language]
          language_data = Data.load_languages[options[:language]]
          if language_data.present?
            plural_rule = language_data["po_plural_rule"]
            headers["Plural-Forms"] = plural_rule if plural_rule.present?
          end
        end
        headers["MIME-Version"] = "1.0"
        headers["Content-Type"] = "text/plain; charset=UTF-8"
        headers["Content-Transfer-Encoding"] = "8bit"

        header = GetPomo::Translation.new
        header.as_header(headers)
        header.fix_before_save
        header
      end
    end
  end
end
