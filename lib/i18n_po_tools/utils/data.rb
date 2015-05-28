# coding: utf-8
require 'yaml'

module I18nPoTools
  class Data
    def self.load_plurals
      filename = relative_filename('../data/plurals.rb')
      load_config_rb(filename)
    end

    def self.load_languages
      filename = relative_filename('../data/languages.yml')
      YAML.load_file(filename)
    end

    private
    def self.relative_filename(filename)
      dirname = File.expand_path(File.dirname(__FILE__))
      File.join(dirname, filename)
    end

    def self.load_config_rb(filename)
      eval(File.open(filename).read)
    end
  end
end
