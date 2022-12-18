# :red_square: class DispatchQueue: DispatchObject

DispatchQueue - СТРУКТУРА ДАННЫХ. Объект, который управляет выполнением задач последовательно или одновременно в основном потоке вашего приложения или в фоновом потоке. По методу FIFO.

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

### Флаг: .barrier
- (дока) При отправке в параллельную очередь рабочий элемент с этим флагом действует как барьер. Рабочие элементы, отправленные до выполнения барьера до завершения, после чего выполняется рабочий элемент барьера. После завершения работы барьера очередь возвращается к планированию рабочих элементов, которые были отправлены после барьера.
- Все задачи выполняются в очереди у нас параллельно, но когда доходим до задачи с флагом барьер, все задачи что были до довыполняются, потом выполняется блок барьера, потом все остальные на очереди. По сути барьер блокирует выполнение последующих задач давая блоку барьеру выполнится в одного, но и при этом он начинается тогда когда все предыдущие запущенные до него задачи выполнятся
```Swift
queue.async {
    sleep(1)
    print("1")
}
queue.async {
    sleep(1)
    print("2")
}
// наша задача с барьером
queue.async(flags: .barrier) {
    sleep(1)
    print("3")
}
queue.async {
    sleep(1)
    print("4")
}
// результат: 1 2 (3 сразу не запускается, а ждет выполнение задач 1 и 2, после их выполнения запускается 3) 3 (4 не запускается сразу, а ждет выполнения задачи 3) 4
```

# :red_square: class DispatchWorkItem
- DispatchWorkItem - (дока) Работа, которую вы хотите выполнить, инкапсулирована таким образом, чтобы вы могли прикрепить дескриптор завершения или зависимости выполнения.
- DispatchWorkItem - по сути таже задача но с расширенными возможностями: 
  - ее можно отменять, до того как она еще не начала выполняться
  - есть комплишн блок (notify)

```Swift
// создаем DispatchWorkItem
let workItem = DispatchWorkItem {
    print("workItem")
}

// Передача в очередь
queue.async(execute: workItem)

// Отмена выполнения workItem
workItem.cancel()

// Комплишн блок у workItem
// можно использовать например для загрузки картинки из инета, а потом в notify установить ее в UI
workItem.notify(queue: .main) {
    print("notify")
}
```

# :red_square: class DispatchSemaphore: DispatchObject
- DispatchSemaphore - Объект, который контролирует доступ к ресурсу в нескольких контекстах выполнения с помощью традиционного семафора подсчета.
- Вы увеличиваете количество семафоров, вызывая метод signal(), и декремируете количество семафоров, вызывая wait() или один из его вариантов, который определяет тайм-аут.
- func wait() - Отнимает единицу у семафора или ждет если все занято (равно 0).
- func signal() -> Int - добавляет единицу у семафора. Эта функция возвращает ненулевое (как я понял единицу) значение, если поток пробужден. В противном случае возвращается ноль.

```Swift
// создаем семафор, указывая сколько потоков могут проходить через него (одновременно работать)
let semaphore = DispatchSemaphore(value: 2)

// будут выполняться только 2 задачи за раз
queue.async {
    // декремент. тоесть у DispatchSemaphore(value: 2) отнимается 1
    semaphore.wait() // -1
    sleep(1)
    print("method 1")
    // инкремент. тоесть у DispatchSemaphore(value: 2) прибавляется 1
    semaphore.signal() // +1
}
queue.async {
    semaphore.wait()
    sleep(1)
    print("method 2")
    semaphore.signal() // +1
}
queue.async {
    semaphore.wait()
    sleep(1)
    print("method 3")
    semaphore.signal() // +1
}
```

# :red_square: class DispatchGroup: DispatchObject
- DispatchGroup - Группа задач, которые вы отслеживаете как единое целое.
- Группы позволяют агрегировать набор задач и синхронизировать поведение в группе. Вы присоединяете несколько рабочих элементов к группе и планируете их асинхронное выполнение в одной очереди или разных очередях. Когда все рабочие элементы завершают выполнение, группа выполняет свой обработчик завершения. Вы также можете синхронно дождаться завершения выполнения всех задач в группе.
- .enter() - помещает блок в группу
- .leave() - говорит группе что блок выходит из группы
- .wait() - останавливает выполнение кода пока не выполнятся все задачи в группе
- .notify(queue: .main) - есть комплишн блок у очереди где указываем очередь в которой он будет выполнятся

```Swift
// создаем группу
private let groupBlack = DispatchGroup()

// добавляем следующий блок в группу
groupBlack.enter()
queue.async {
    sleep(1)
    print("1")
    // блок кода выходит из группы
    groupBlack.leave()
}

groupBlack.enter()
queue.async {
    sleep(1)
    print("2")
    groupBlack.leave()
}

// пока все не выполнится ждем
print("3")
groupBlack.wait()
print("finish_all")

groupBlack.notify(queue: .main) {
    print("groupBlack_Done")
}
// результат: 3 (потом все останавливается пока не выполнятся все задачи в группе) 2 1 finish_all groupBlack_Done
```

# :red_square: class DispatchSource: DispatchObject
- DispatchSource - Объект, который координирует обработку конкретных низкоуровневых системных событий, таких как события файловой системы, таймеры и сигналы UNIX.

```Swift
// работаем со системным таймером, который может работать и в других потоках (не только в главном)

// указываем очередь в которой будем работать
let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

// установим обработчик событий, сработает при срабатывании таймера
timer.setEventHandler {
    print("1")
}

// настраиваем таймер (его настройки)
// время когда начать и через сколько секунд повторять событие
timer.schedule(wallDeadline: .now(), repeating: 1)

// по умолчанию таймер не активирован, активируем его
timer.activate()
```
