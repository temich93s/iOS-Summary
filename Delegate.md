# Делегаты в Swift

## 1. Создаем протокол делегата
 
- В протоколе описываем все методы, которыми должен обладать делегат (**структура №2**) и которые **структура №1** сможет вызывать у **структуры №2**

```Swift
protocol WeatherModelDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
```

## 2. Создаем структуру №1 

- Эта **структура №1**, сможет вызывать метод у делегата (**структуры №2**) и передавать ему свои данные
- У данной структуры обязательно должна быть **опциональная переменная**, которая может быть любым типом, главное что бы она соотвествовала **протоколу делегата**
- У **классов** для предотвращения цикла сильных ссылок, делегаты должны быть помечены как слабые (**weak**) ссылки.

```Swift
struct WeatherManager {
    // создаем опциональное свойство делегата, что бы структура №2 могла себя установить в эту переменную и тем самым дать доступ структуре №1 к методам/свойствам структуры №2 
    var delegate: WeatherModelDelegate?

    // При необходимости в коде можно вызвать метод у делегата (у структуры №2), передав ему свои данные (из структуры №1)
    delegate?.didUpdateWeather(self, weather: weather)
    
    // При необходимости в коде можно вызвать метод у делегата (у структуры №2) обрабатывающий ошибку
    delegate?.didFailWithError(error: error)
}
```

## 3. Создаем структуру №2

- Создаем экземпляр **структруры №1** внутри **структуры №2**, что бы у **структуры №2** была возможность установить себя делегатом **структруры №1**
- В **структуре №2** устанавливаем ее (**структуру №2**) в качестве делегата **структруры №1**

```Swift
class WeatherViewController: UIViewController {
    // Создаем экземпляр weatherManager (экземпляр структуры №1)
    var weatherManager = WeatherManager()
    
    // устанавливаем WeatherViewController в качестве делегата
    weatherManager.delegate = self
}
```

## 4. Создаем расширение подписывающее структуру №2 под протокол делегата

- Описываем функционал методов, которые сможет вызывать **структрура №1** у **структуры №2**

```Swift
extension WeatherViewController: WeatherModelDelegate {   
    // функция которая вызывается, когда данные о погоде были успешно получены
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        // обновляем UI, поскольку это функция вызывается из completionHandler и так как мы обновляем UI, то мы должны выполнять код по обновлению UI в основном потоке
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    // функция которая вызывается, если во время запроса/получения данных о погоде возникла ошибка
    func didFailWithError(error: Error) {
        print(error)
    }
}
```

## 5. Пример делегата между классами

### ProductDelegate

```Swift
protocol ProductDelegate: AnyObject {
    func addProduct(product: String)
}
```

### ViewController1

```Swift
class ViewController1: UIViewController {
    let secondVC = ViewController2()
    
    override func viewDidLoad() {
        super.viewDidLoad()  
        secondVC.delegate = self
    }
}

extension ViewController1: ProductDelegate {
    func addProduct(product: String) {
        label.text = product
    }
}
```

### ViewController2
```Swift
class ViewController2: UIViewController {
    weak var delegate: ProductDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()  
        delegate?. addProduct(product: "Продукт")
    }
}
```
