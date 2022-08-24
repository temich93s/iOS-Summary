# Получение данных из сети формата JSON и декодирование их

### 1. Сетевой адрес с данными в формате JSON: 

https://hn.algolia.com/api/v1/search?tags=front_page

### 2. Cоздаем структуры для парсинга пришедших из сети данных, в соотвествии со структурой JSON выдаваемого сайтом:

```Swift
struct Results: Codable {
    let hits: [Post]
}

struct Post: Codable {
    let objectID: String
    let points: Int
    let title: String
    let url: String?
}
```

### 3. Создаем переменную в которую сохраняем данные из сети:

```Swift
var posts = [Post]()
```

### 4. Получаем данные из сети и вызываем метод по декодированию их в формат JSON:

```Swift
func fetchData() {
    
    // URL - Значение, определяющее расположение ресурса, например элемент на удаленном сервере или путь к локальному файлу.
    if let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page") {
        
        // URLSession - Объект, который координирует группу связанных задач передачи данных по сети.
        let session = URLSession(configuration: .default)
        
        // .dataTask - Создает задачу, которая извлекает содержимое указанного URL-адреса, а затем вызывает обработчик по завершении.
        let task = session.dataTask(with: url) { data, response, error in
            if error == nil {
                decodeData(data: data)
            } else {
                print(error!)
            }
        }
        
        // .resume - Возобновляет задачу, если она была приостановлена.
        task.resume()
    }
}
```

### 5. Метод по декодированию пришедших данных из формата data в JSON:

```Swift
func decodeData(data: Data?) {
    
    // JSONDecoder() - Объект, который декодирует экземпляры типа данных из объектов JSON.
    let decoder = JSONDecoder()
    
    if let safeData = data {
        do {
            // .decode - Возвращает значение указанного типа, декодированное из объекта JSON.
            let results = try decoder.decode(Results.self, from: safeData)
            posts = results.hits
        } catch {
            print(error)
        }
    }
}
```
