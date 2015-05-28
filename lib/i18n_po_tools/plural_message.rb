# coding: utf-8
module I18nPoTools
  class PluralMessage

    attr_accessor :translations

    def initialize(options = {})
      @translations = options.fetch(:translations,[])
    end

    def to_a
      translations
    end

    def to_s
      translations.first.to_s
    end
  end
end
