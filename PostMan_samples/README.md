### чтобы не забыть при использовании PostMan

1) использование переменных: https://learning.postman.com/docs/sending-requests/variables/
2) написание скриптов в среде postman (язык javascript) https://learning.postman.com/docs/writing-scripts/script-references/postman-sandbox-api-reference/#scripting-with-response-data
3) испорт коллекции выполняется так: https://learning.postman.com/docs/getting-started/importing-and-exporting/importing-and-exporting-overview/
4) можно тестировать под нагрузкой

### Пример в коллекции [webabap_1](https://github.com/OlegBash599/WebABAP_samples/blob/master/PostMan_samples/webaabap_1.postman_collection.json):
1) простой запрос метаданных и сущности (GET_ENTITY и GET_ENTITYSET)
2) проверка на значение через postman-скрипт
3) отправка POST-запроса с получением csrf-токена в  pre-request части
4) использование переменных для HOST / PORT / username/password и т.д.
