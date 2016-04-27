require 'google/apis/translate_v2'

translate = Google::Apis::TranslateV2::TranslateService.new
translate.key = 'AIzaSyDJtrBnGjEo1XvaqlIuYUG4d1MWzMGYikQ'
result = translate.list_translations('Hello world!', 'es', source: 'en')
puts result.translations.first.translated_text
