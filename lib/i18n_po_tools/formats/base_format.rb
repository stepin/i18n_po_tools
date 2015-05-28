# coding: utf-8
require 'fileutils'

module I18nPoTools
  module Formats
    class BaseFormat
      attr_accessor :options

      def read_file(input_filename)
        if input_filename.present?
          if file_encoding.index('UTF-16')
            mode = "rb:#{file_encoding}"
          else
            mode = "r:#{file_encoding}"
          end

          File.open(input_filename, mode, &:read)
        else
          $stdin.read
        end
      end

      def write_file(output_filename, data)
	      FileUtils.mkdir_p File.dirname(output_filename)
        if output_filename.present?
          File.open(output_filename, "w:"+file_encoding) do |f|
            f << data
          end
        else
          puts data
        end
      end

      def write_with_options(data, base_data, options)
        @options = options
        write(options[:output_filename], data)
      end

      def read_with_options(filename, options, mode)
        @options = options
        read(filename)
      end

      def read(filename)
        raise "Not Implemented"
      end

      def write(filename, data)
        raise "Not Implemented"
      end

      def banner_msg
        "Generated by i18n-po #{I18nPoTools::VERSION} on #{Time.now.strftime("%Y-%m-%d %H:%M:%S")} by #{ENV['USER']} on #{`hostname`.gsub("\n",'')}"
      end

      def file_encoding
        'UTF-8'
      end
    end
  end
end