# :red_square: GCD


### Тип очереди:
- .serial – последовательная очередь. Все задачи в очереди выполняются последовательно друг за другом (по типу FIFO), пока текущая задача не выполнится в очереди, к следующей очередь не начнет выполнять. 
- .concurrent – параллельная очередь. Все задачи в этой очереди выполняются параллельно/одновременно (пока есть свободные ресурсы у очереди на выполнение нескольких задач)

```Swift
// создаем последовательную очередь со своим названием
private let serialQueue = DispatchQueue(label: "serialTest")

// создание параллельной очереди
private let concurrentQueue = DispatchQueue(label: "concurrentTest", attributes: .concurrent)

// глобальная очередь - ПАРАЛЛЕЛЬНАЯ
private let globalQueue = DispatchQueue.global()

// главная очередь - ПОСЛЕДОВАТЕЛЬНАЯ (тут UI, имеет максимальный приоритет)
private let mainQueue = DispatchQueue.main
```

###  Тип задания относительно текущей очереди, (той очереди, что запускает (размещает) задачу):
- .sync – текущая очередь, что запускает задачу, после запуска задачи будет приостановлена пока запускаемая задача не выполнится полностью.
- .async – текущая очередь, что запускает задачу, после запуска задачи продолжает выполнять свой код дальше не дожидаясь выполнения запущенной задачи.


### Пример очереди при загрузки картинки из интернета
```Swift
let queue = DispatchQueue.global(qos: .userInteractive)

// ставим задачу загрузки из инета асинхронно
queue.async {
    if let data = try? Data(contentsOf: imageURL) {
    // UI всегда ставим в основной очереди, UI всегда в мейн потоке
    DispatchQueue.main.async {
        self.image.image = UIImage(data: data)
        }
    }
}
```
### class func concurrentPerform(iterations: Int, execute: (Int) -> Void)
- выполнение одного блока код, где каждая итерация выполняется в паралельных потоках 

```Swift
// выполнять будет во всех возможных очередях и в мейн и в глобале
DispatchQueue.concurrentPerform(iterations: 200) { number in
    print(number)
    print(Thread.current)
}

// выполнять будет только в глобале
let queue = DispatchQueue.global(qos: .utility)
queue.async {
    DispatchQueue.concurrentPerform(iterations: 200) { number in
        print(number)
        print(Thread.current)
    }
}
```

### func asyncAfter(deadline: DispatchTime, execute: DispatchWorkItem)
- выполняет код асинхронно в заданное время и сразу же возвращает результат как он готов

```Swift
// задача начнет выполняться в очереди через 2 секунды после того как дойдет до данной строчки
queue.asyncAfter(deadline: .now() + .seconds(2)) {
    print("done")
}
```

### Аттрибут: .initiallyInactive
- обычно при добавление задачи в очередь она сразу начинает выполняться. При аттрибуте .initiallyInactive задача сразу не начнет выполняться, а начнет после .activate()
- .activate() - запускает выполнение задач в очереди
- .suspend() - приостанавливает выполнение задач в очереди. Останавливает не многовено часть успеет довыполнится
- .resume() - возобнавляет выполнение задач в очереди

```Swift
    let inactiveQueue = DispatchQueue(label: "Inac", attributes: [.concurrent, .initiallyInactive])
    inactiveQueue.async {
        for i in 1...10 {
            print(i)
        }
    }
    print("not_start")
    inactiveQueue.activate()
    print("active")
    inactiveQueue.suspend()
    print("suspend")
    inactiveQueue.resume()
    print("resume")
// Результат: not_start active 1 2 3 suspend 4 5 6 resume 7 8 9 10
```


