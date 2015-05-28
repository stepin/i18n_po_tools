# coding: utf-8
require 'optparse'

module I18nPoTools
  class CLI
    def parse_options(options)
      opt_parser = OptionParser.new do |opt|
        opt.banner = "Usage: i18n-po [OPTIONS]"
        opt.separator  ""
        opt.separator  "Utils to convert translations from source formats to PO/POT Gettex and vise"
        opt.separator  "versa. It allows to separate translations from development of apps."
        opt.separator  ""
        opt.separator  "Supported input/output formats:"
        opt.separator  "* iOS and OS X String Resources"
        opt.separator  "* Android String XML"
        opt.separator  "* Gettext PO/POT"
        opt.separator  "* Rails YAML"
        opt.separator  "* Basic flat YAML"
        opt.separator  "* Java properties"
        opt.separator  "* CVS for easy exchange with other apps"
        opt.separator  ""
        opt.separator  "Direct converation between any formats supported."
        opt.separator  ""
        opt.separator  "Rails YAML and PO supports plural forms of messages."
        opt.separator  ""
        opt.separator  ""
        opt.separator  "Options"


        opt.on("-i","--input FILENAME","input filename (default STDIN)") do |input_filename|
          options[:input_filename] = input_filename
        end
        opt.on("-b","--base FILENAME","base language input filename (only for po output mode)") do |base_filename|
          options[:base_filename] = base_filename
        end
        opt.on("-o","--output FILENAME","output filename (default STDOUT)") do |output_filename|
          options[:output_filename] = output_filename
        end

        opt.on("-f","--from FORMAT", FORMATS, "input file format (default is autodetect by ext)", "(#{FORMATS.join(', ')})") do |input_format|
          options[:input_format] = input_format
        end

        opt.on("-t","--to FORMAT", FORMATS, "output file format (default is autodetect by ext)", "(#{FORMATS.join(', ')})") do |output_format|
          options[:output_format] = output_format
        end

        opt.on("-l","--language LANGUAGE","input file language (only for po or rails_yaml output mode)") do |language|
          options[:language] = language
        end

        opt.on("-h","--help","help") do
          puts opt_parser
          exit(0)
        end

        opt.separator  ""
        opt.separator  "Examples:"
        opt.separator  "1) First import (generation of PO file) from Rails YAML file:"
        opt.separator  "i18n-po --input   ~/projects/rails_app/config/locales/devise.en.yml --language en \\"
        opt.separator  "         --base ~/projects/rails_app/config/locales/devise.ru.yml \\"
        opt.separator  "         --output  ~/projects/translations/rails_app/devise.en.po"
        opt.separator  ""
        opt.separator  "2) Generation of translation template (POT file) from Rails YAML file:"
        opt.separator  "i18n-po --input ~/projects/rails_app/config/locales/devise.ru.yml \\"
        opt.separator  "         --output  ~/projects/translations/rails_app/devise.en.pot"
        opt.separator  ""
        opt.separator  "3) Generation of Rails YAML file from PO file:"
        opt.separator  "i18n-po --input   ~/projects/translations/rails_app/devise.en.po --language en \\"
        opt.separator  "         --output ~/projects/rails_app/config/locales/devise.en.yml"
        opt.separator  ""
        opt.separator  "4) Translation convertation from iOS to Android format:"
        opt.separator  "i18n-po --input   ~/projects/ios_app/Localizable.strings \\"
        opt.separator  "         --output ~/projects/android_app/en/strings.xml"
        opt.separator  ""
        opt.separator  "Homepage: http://github.com/stepin/i18n-po-tools"
        opt.separator  ""
      end

      opt_parser.parse!

      #default help
      if options.count == 0
        puts opt_parser
        exit(1)
      end
    end

    def check_options(options)
      if options[:input_format].blank?
        if options[:input_filename].present?
          ext = File.extname(options[:input_filename])[1..-1].to_sym
          options[:input_format] = EXT_TO_FORMAT[ext]
          if options[:input_format].blank?
            STDERR.puts "ERROR: unknown input format, please define it manually."
            exit(1)
          end
        else
          STDERR.puts "ERROR: input format should be defined for STDIN stream."
          exit(1)
        end
      end

      if options[:output_format].blank?
        if options[:output_filename].present?
          ext = File.extname(options[:output_filename])[1..-1].to_sym
          options[:output_format] = EXT_TO_FORMAT[ext]
          if options[:output_format].blank?
            STDERR.puts "ERROR: unknown output format, please define it manually."
            exit(1)
          end
        else
          STDERR.puts "ERROR: output format should be defined for STDOUT stream."
          exit(1)
        end
      end

      options[:input_format] = options[:input_format].to_sym
      options[:output_format] = options[:output_format].to_sym

      if options[:output_format] == :po
        if options[:base_filename].blank?
          STDERR.puts "ERROR: base filename should be defined for po output mode."
          exit(1)
        end
        if options[:language].blank?
          STDERR.puts "ERROR: language should be defined for po output mode."
          exit(1)
        end
      else
        if options[:base_filename].present?
          STDERR.puts "WARNING: base filename is not used in this mode."
        end
        if options[:output_format] == :rails_yaml
          if options[:language].blank?
            STDERR.puts "ERROR: language should be defined for rails_yaml output mode."
            exit(1)
          end
        else
          if options[:language].present?
            STDERR.puts "WARNING: language is not used in this mode."
          end
        end
      end


      if options[:input_format] == options[:output_format]
        STDERR.puts "ERROR: same format, just use copy command."
        exit(1)
      end
    end

    def self.start
      new.start
    end

    def start
      options = {}
      parse_options(options)
      check_options(options)

      reader = I18nPoTools::Formats::Factory.get(options[:input_format])
      writer = I18nPoTools::Formats::Factory.get(options[:output_format])

      input_data = reader.read_with_options(options[:input_filename], options, :input)
      base_data = nil
      if options[:output_format] == :po
        base_data = reader.read_with_options(options[:base_filename], options, :base)
      end
      writer.write_with_options(input_data, base_data, options)
    end
  end
end