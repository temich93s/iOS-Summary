## Пример получения данных из сети:

```Swift
func performRequest(with urlString: String) {
        // 1. Cоздаем URL
        if let url = URL(string: urlString) {
            // 2. Cоздаем URL-сессию
            let session = URLSession(configuration: .default)
            // 3. Создаем задачу с заданным URL и с обработчиком (замыкание) принимаемых данных. Замыкание это - completionHandler
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    // обрабатываем пришедшие данные (safeData) от API
                    }
                }
            }
            // 4. Запускаем задачу по получению данных с API
            task.resume()
        }
    }
```
