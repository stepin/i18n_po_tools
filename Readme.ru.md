# i18n-po-tools

Утилы для конвертирования переводов из исходных форматов в PO/POT Gettex и обратно. Позволяет разделить перевод и разработку программ.

Поддерживаемые форматы (в обе стороны):
* [iOS и OS X String Resources][http://developer.apple.com/documentation/Cocoa/Conceptual/LoadingResources/Strings/Strings.html] (формат: ios)
* [Android String XML][http://developer.android.com/guide/topics/resources/string-resource.html] (формат: android)
* [Gettext PO/POT][http://www.gnu.org/savannah-checkouts/gnu/gettext/manual/html_node/PO-Files.html] (формат: po или pot)
* [Rails YAML][http://guides.rubyonrails.org/i18n.html] (формат: rails-yaml)
* Простой плоский формат YAML (формат: flat-yaml)
* CVS для упрощенного обмена с другими программами (формат: csv-yaml)

Возможна прямая конвертация между любыми поддерживаемыми форматами.

Почему проект получился таким каким получился можно прочитать в Design.ru.txt.

Rails YAML и PO поддерживают специальный вид строк для переводов, зависящих от чисел (plurals). Пример: 1 сообщение, 6 сообщений.


## Установка

Добавьте строчку в Gemfile:

    gem 'i18n_po_tools'

и запустите:

    $ bundle

Или установка без Gemfile:

    $ gem install i18n_po_tools


## Использование

Утила: i18n-po [Опции]

Опции
    -i, --input FILENAME             input filename (default STDIN)
    -b, --base FILENAME              base language input filename (only for po output mode)
    -o, --output FILENAME            output filename (default STDOUT)
    -f, --from FORMAT                input file format (default is autodetect by ext)
                                     (rails_yaml, flat_yaml, po, pot, ios, android, csv)
    -t, --to FORMAT                  output file format (default is autodetect by ext)
                                     (rails_yaml, flat_yaml, po, pot, ios, android, csv)
    -l, --language LANGUAGE          input file language (only for po or rails_yaml output mode)
    -h, --help                       help

Примеры:
1) Первоначальный импорт перевода (генерация po-файла) из Rails yml-файла:
i18n-po --input   ~/projects/rails_app/config/locales/devise.en.yml --language en \
         --base ~/projects/rails_app/config/locales/devise.ru.yml \
         --output  ~/projects/translations/rails_app/devise.en.po

2) Генерация шаблона для перевода (pot-файла) из Rails yml-файла:
i18n-po --input ~/projects/rails_app/config/locales/devise.ru.yml \
         --output  ~/projects/translations/rails_app/devise.en.pot

3) Генерация Rails yml-файла из переведенного po-файла:
i18n-po --input   ~/projects/translations/rails_app/devise.en.po --language en \
         --output ~/projects/rails_app/config/locales/devise.en.yml

4) Конвертация файла перевода из iOS-формата в Android:
i18n-po --input   ~/projects/ios_app/Localizable.strings \
         --output ~/projects/android_app/en/strings.xml


## Как работает механизм переводов на базе i18n-po?
Системой пользуются 2 роли пользователей: переводчики и разработчики прикладных программ.

Источником данных являются .po-файлы. Файлы в приложениях -- автосгенерированы из .po-файлов.


## Со стороны переводчиков
У переводчиков есть папка в Dropbox (или аналогичном сервисе). Они открывают папку своего языка в [PO Editor](http://poedit.net) (доступен под Windows,
Mac OS X и Linux), выбирают язык для перевода и переводят.

Структура папки:
Templates/
  ru/
    example-app/
      main.pot
  en/
    example-app/
      main.pot
Translations/
  ru/
    example-app/
      main.po    //перевод с русского на русский, для исправлений текстов нетехническими людьми
  en/
    example-app/
      main.po    //перевод с русского на английский, для исправлений текстов нетехническими людьми
  fr
    example-app/
      main.po    //перевод с английского на французский
  sp
    example-app/
      main.po    //перевод с русского на испанский

pot-файлы -- это те же файлы .po, но без переводов.

Когда обновляется перевод в программе, то обновляются только
.pot-файлы. Уже сам редактор замечает, что они обновились и предлагает
доперевести их в .po-файле. Если редакторы без этой функции, то можно автоматически обновлять и переводы, но нужно договориться в этот момент не править переводы переводчикам.

Первоначальный импорт уже созданных переводов так же можно сделать, что уже было переведено не пропадет.

Зачем пользоваться специальным программами, если можно открыть .po-файл в текстовом редакторе?
1) Всегда корректный синтаксис файла, случайно "не сломаешь" его.
2) В редакторах, как правило, есть база перевода. Позволит аналогично переводить похожие сообщения.
3) Через некоторое время осознаешь и другие преимущества использования специализированной программы (удобный интерфейс именно для переводов, статистика и т.п.)


## Со стороны разработчиков
Готовите переводы в стандартных для своей платформы форматах.
Затем с помощью i18n-po переводите в po-файлы. Кол-во po-файлов
соответствует количеству исходных файлов.

В папке Dropbox должны присутствовать только файлы форматов .po и .pot,
чтобы не путать переводчиков.

Добавляете скрипты (или другим образом оформляете задачи) извлечения переводов
из исходников (в po-файлы) и выгрузки в исходники (в Rails yml,
iOS/MacOSX .strings, Android .xml). Используется консольная
утилитиа i18n-po. Так же они копируют новые шаблоны для переводов в Dropbox.

Рекомендуется, чтобы разработчики имели доступ к этому репозитарию и папке
Dropbox. Тогда они сами смогут обновлять шаблоны для переводов и импортировать
новые переводы.

При подготовке строк для перевода рекомендуется следовать https://techbase.kde.org/Development/Tutorials/Localization/i18n_Mistakes .

Источником переводов может быть несколько любых языков.

Первоначальное добавление языков в код своего проекта -- на стороне разработчиков, т.к. сильно зависит от программной платформы проекта и самого проекта. Для iOS, Mac OS X и Android -- это создание соотв. папок.


Замечания по сторонним программным продуктам
============================================
1) Вместо Dropbox можно использовать другие аналогичные решения. Переводчикам проще обращаться с таким решением, чем с полноценными репозитариями (например Git).

2) Вместо poedit.net можно использовать Localize из KDE http://l10n.kde.org/docs/translation-howto/gui-specialized-apps.html#lokalize . Его ставить сложнее, но по функционалу лучше.

3) Формат po-файлов позволяет использовать множество утил и программ, он известен практически всем, кто занимается переводами программ. Более того утила i18n-po поддеживает конвертацию во множество форматов, включая CSV.


Особенности реализации конвертации из Rails
===========================================
Редакторы не поддерживают конструкции вида %{count}. Для plural сообщений используется автоматическая конвертация в C-format: %d <--> %{count}. В остальных случаях ничего не делается.


## Интересные проекты
1) https://github.com/mrmans0n/localio
Сделан для перевода через гуглотаблицы. Содержит некоторые другие форматы (JSON). Из минусов: не поддерживает plurals, некоторые форматы (po). Возможны проблемы с escaping'ом.

2) https://github.com/netbe/Babelish
Основой является текстовый файл в csv формате. Соотв., нет поддержки PO и plurals.

3) https://github.com/mobiata/twine
Основой является текстовый файл в ini-подобном формате.
Поддерживает экспорт во множество форматов.

4) http://olshansk.github.io/ios_localizer/
Осуществляет автоматический перевод ios-файлов с помощью Google Translate.
Если вдруг нужно сделать плохой (зато дешевый -- $20 per 1M characters) автоматический перевод. Далее с помощью i18n-po преобразовать в любой нужный формат.

5) https://localise.biz/free/converter/yml
Online-конвертор файла в разные форматы. Пока что бесплатно. Плюсы -- множество форматов. Минус -- в любой момент может стать платным или перестать работать. Так же нет генерации po-файла из 2х исходных файлов (перевод человеческого текста, не ключей).

6) http://pology.nedohodnik.net/
Библиотека на Python для автоматизации манипуляций с po-файлами. Интересно, если писать дополнительные утилы манипуляций с переводами.

7) https://github.com/grosser/get_pomo
Если для автоматизации больше нравится Ruby, то эта библиотека поможет.

8) https://github.com/pejuko/i18n-translators-tools
Интересный, но заброшенный проект. К сожалению, вмешивается в то как Rails читает файлы переводов и в каком формате они должны быть.

9) https://github.com/airbnb/polyglot.js
Интересный проект для переводов web-части приложений. Пока что не поддерживается i18n-po, но есть все шансы.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

