require 'fileutils'
require 'yaml'

module I18nPoTools
  class LocfileUtils
    attr_accessor :translations_dir,
                  :dirname,
                  :project_name,
                  :template_locales,
                  :locales,
                  :locales_indexes,
                  :translation_files,
                  :src_filename_template,
                  :pot_filename_path,
                  :po_filename_path,
                  :verbose

    def initialize(dirname)
      @translations_dir = ENV["I18N_YML_TRANSLATIONS_DIR"]
      @verbose = true

      @dirname = File.expand_path(dirname)
      config = YAML.load_file(File.join(dirname, 'Locfile'))

      @project_name = config["project_name"]
      @template_locales = config["template_locales"]
      @locales = config["locales"]
      @locales_indexes = config["locales_indexes"]

      @translation_files = config["translation_files"]
      @src_filename_template = config["src_filename_template"]
      @pot_filename_path = config["pot_filename_path"].gsub('%{project_name}', project_name)
      @po_filename_path = config["po_filename_path"].gsub('%{project_name}', project_name)
    end

    def my_command(cmd)
      puts cmd if verbose
      system(cmd)
    end

    def create_dirs()
      template_locales.each do |locale|
        name = File.join(translations_dir, pot_filename_path.gsub('%{locale}',locale))
        my_command("mkdir -p #{name}")
      end
      locales.each do |(locale, base_locale)|
        name = File.join(translations_dir, po_filename_path.gsub('%{locale}',locale))
        my_command("mkdir -p #{name}")
      end
    end

    def generate_pot(locale)
      src_path = File.join(dirname, src_filename_template_with_locale(locale))
      pot_path = File.join(translations_dir, pot_filename_path.gsub('%{locale}',locale))

      translation_files.each_pair do |src_name, pot_name|
        src_filename = src_path.gsub('%{src_filename}',src_name)
        pot_filename = File.join(pot_path, pot_name+".pot")

        cmds = []
        cmds << "i18n-po "\
          "--input #{src_filename} "\
          "--output #{pot_filename} "\
          "#{generate_pot_extra(locale, src_filename, pot_filename)}"
        my_command( cmds.join(';') )
      end
    end

    def merge_pot(locale, base_locale, pot_name)
      pot_filename = File.join(translations_dir, pot_filename_path.gsub('%{locale}',base_locale),pot_name+".pot")
      po_filename = File.join(translations_dir, po_filename_path.gsub('%{locale}',locale),pot_name+".po")
      my_command("msgmerge -U #{po_filename} #{pot_filename}")
    end

    def merge_pot_all()
      locales.each do |(locale, base_locale)|
        translation_files.each_pair do |src_name, pot_name|
          merge_pot(locale, base_locale, pot_name)
        end
      end
    end

    def convert_from_po_to_src(locale)
      src_path = File.join(dirname, src_filename_template_with_locale(locale))
      po_path = File.join(translations_dir, po_filename_path.gsub('%{locale}',locale))

      translation_files.each_pair do |src_name, pot_name|
        src_filename = src_path.gsub('%{src_filename}',src_name)
        po_filename = File.join(po_path, pot_name+".po")

        cmds = []
        cmds << "i18n-po "\
          "--output #{src_filename} "\
          "--input #{po_filename} "\
          "#{convert_from_po_to_src_extra(locale, src_filename, po_filename)}"
        my_command( cmds.join(';') )
      end
    end

    def convert_from_src_to_po(locale, base_locale)
      base_path = File.join(dirname, src_filename_template_with_locale(base_locale))
      src_path = File.join(dirname, src_filename_template_with_locale(locale))
      po_path = File.join(translations_dir, po_filename_path.gsub('%{locale}',locale))

      translation_files.each_pair do |src_name, pot_name|
        base_filename = base_path.gsub('%{src_filename}', src_name)
        src_filename = src_path.gsub('%{src_filename}', src_name)
        po_filename = File.join(po_path, pot_name+".po")

        cmds = []
        cmds << "i18n-po "\
          "--output #{po_filename} "\
          "--input #{src_filename} "\
          "--language #{locale} "\
          "--base #{base_filename} "\
          "#{convert_from_src_to_po_extra(locale, base_locale, base_filename, src_filename, po_filename)}"
        my_command( cmds.join(';') )
      end
    end

    def src_filename_template_with_locale(locale)
      src_filename_template.gsub('%{locale}',locale)
    end

    def generate_pot_extra(locale, src_filename, pot_filename)
      ''
    end
    def convert_from_po_to_src_extra(locale, src_filename, po_filename)
      ''
    end
    def convert_from_src_to_po_extra(locale, base_locale, base_filename, src_filename, po_filename)
      ''
    end

    def export_messages()
      create_dirs()
      template_locales.each do |locale|
        generate_pot(locale)
      end

      #merge new strigns to po files
      puts
      puts
      puts "WARNING:"
      puts "Ensure that currently translators do not update your project translations."
      puts
      puts "Press [Enter] key to start export new strings from POT to PO-files..."
      gets
      merge_pot_all()
    end

    def import_translations()
      locales.each do |(locale, base_locale)|
        convert_from_po_to_src(locale)
      end
    end

    def export_initial_translations()
      locales.each do |(locale, base_locale)|
        convert_from_src_to_po(locale, base_locale)
      end
    end
  end
end
