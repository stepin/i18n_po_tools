# i18n-po-tools

Utils to convert translations from source formats to PO/POT Gettex and vise versa. It allows to separate translations from development of apps.

Supported input/output formats:
* [iOS and OS X String Resources](http://developer.apple.com/documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html) (format: ios)
* [Android String XML](http://developer.android.com/guide/topics/resources/string-resource.html) (format: android)
* [Gettext PO/POT](http://www.gnu.org/savannah-checkouts/gnu/gettext/manual/html_node/PO-Files.html) (format:po and pot)
* [Rails YAML](http://guides.rubyonrails.org/i18n.html) (format: rails-yaml)
* Basic flat YAML (format: flat-yaml)
* [Java properties](http://en.wikipedia.org/wiki/.properties) (format: properties)
* CVS for easy exchange with other apps (format: csv-yaml)

Direct converation between any formats supported.

About design decision you can read in the Design.txt.

Rails YAML and PO supports plural forms of messages. Example: 1 message, 2 messages.

Sorry, more info only in Russian in the Readme.ru.md file.


## Installation

Add this line to your application's Gemfile:

    gem 'i18n_po_tools'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install i18n_po_tools


## Usage

Command: i18n-po [OPTIONS]

    Options:
    -i, --input FILENAME             input filename (default STDIN)
    -b, --base FILENAME              base language input filename (only for po output mode)
    -o, --output FILENAME            output filename (default STDOUT)
    -f, --from FORMAT                input file format (default is autodetect by ext)
                                     (rails_yaml, flat_yaml, po, pot, ios, android, properties, csv)
    -t, --to FORMAT                  output file format (default is autodetect by ext)
                                     (rails_yaml, flat_yaml, po, pot, ios, android, properties, csv)
    -l, --language LANGUAGE          input file language (only for po or rails_yaml output mode)
    -h, --help                       help

    Examples:
    1) First import (generation of PO file) from Rails YAML file:
    i18n-po --input   ~/projects/rails_app/config/locales/devise.en.yml --language en \
             --base ~/projects/rails_app/config/locales/devise.ru.yml \
             --output  ~/projects/translations/rails_app/devise.en.po

    2) Generation of translation template (POT file) from Rails YAML file:
    i18n-po --input ~/projects/rails_app/config/locales/devise.ru.yml \
             --output  ~/projects/translations/rails_app/devise.en.pot

    3) Generation of Rails YAML file from PO file:
    i18n-po --input   ~/projects/translations/rails_app/devise.en.po --language en \
             --output ~/projects/rails_app/config/locales/devise.en.yml

    4) Translation convertation from iOS to Android format:
    i18n-po --input   ~/projects/ios_app/Localizable.strings \
             --output ~/projects/android_app/en/strings.xml


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
