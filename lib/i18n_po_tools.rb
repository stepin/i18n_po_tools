# -*- coding: utf-8 -*-

require 'active_support'
require 'active_support/core_ext/object/blank'

dir = File.expand_path(File.dirname(__FILE__))
$:.unshift(dir) unless $:.include?(dir)

require "i18n_po_tools/version"
require "i18n_po_tools/core_ext/dotted_hash"
require "i18n_po_tools/formats"

module I18nPoTools
  FORMATS = %w[rails_yaml flat_yaml po pot ios android csv]

  EXT_TO_FORMAT = {
    :yml => :rails_yaml,
    :po => :po,
    :pot => :pot,
    :strings => :ios,
    :xml => :android,
    :csv => :csv
  }
end
