# :red_square: Playground

- **import PlaygroundSupport** - Делитесь данными игровой площадки, управляйте интерактивными представлениями и контролируйте выполнение игровой площадки.
- **PlaygroundPage.current.needsIndefiniteExecution** - Указывает, должна ли страница playground выполняться бесконечно. Значение этого свойства по умолчанию равно false, но страницы игровых площадок с живыми представлениями автоматически установят для этого значение true.

```Swift
// нужно для PlaygroundPage
import PlaygroundSupport

// устанавливаем что бы Playgraund выполнялся бесконечно, что бы наши потоки/очереди не завершались когда Playgraund дойдет до посленей строки
PlaygroundPage.current.needsIndefiniteExecution = true
```

# :red_square: class Operation: NSObject

# :red_square: class BlockOperation: Operation

- BlockOperation - это конкретный подкласс Operation, который управляет параллельным выполнением одним или несколькиими блоками. Вы можете использовать этот объект для выполнения нескольких блоков одновременно без необходимости создавать отдельные объекты операции для каждого. 
- При выполнении нескольких блоков сама операция считается завершенной только тогда, когда все блоки завершили выполнение.
- Блоки, добавленные в BlockOperation, отправляются с приоритетом по умолчанию в соответствующую рабочую очередь. Сами блоки не должны делать никаких предположений о конфигурации своей среды выполнения.
- **BlockOperation** - По сути это группировка нескольких операций вместе, что бы их потом пачкой передать в OperationQueue.
- Операции внутри блока выполняются ВСЕГДА параллельно даже если они добавлены в мейн очередь
```Swift
// создание блока операций
let blockOperation = BlockOperation()

// создание блока операций
let blockOperation1 = BlockOperation {
    print("BO1")
}

// Добавление операций в блок
blockOperation1.addExecutionBlock {
    print("BO2")
}

// var executionBlocks: [() -> Void] { get }
// .executionBlocks - это массив блоков добавленых в BlockOperation
print(blockOperation1.executionBlocks.count) // = 2
```

### !Операции внутри блока выполняются ВСЕГДА параллельно даже если они добавлены в мейн очередь
```Swift
// Результат: 1 2 BO1 BO2 3 BO3
let blockOperation = BlockOperation {
    print("3")
    sleep(1)
    print("BO3")
}

let blockOperation1 = BlockOperation {
    print("1")
    sleep(1)
    print("BO1")
}

blockOperation1.addExecutionBlock {
    print("2")
    sleep(1)
    print("BO2")
}

OperationQueue.main.addOperation(blockOperation1)
OperationQueue.main.addOperation(blockOperation)
```

# :red_square: class OperationQueue: NSObject

- OperationQueue - Очередь, которая регулирует выполнение операций.
- OperationQueue организует и вызывает свои операции в соответствии с их готовностью, уровнем приоритета и зависимостями взаимодействия. Если все операции в очереди имеют один и тот же приоритет очереди и свойство isReady возвращает true, очередь вызывает их в том порядке, в котором вы их добавили. В противном случае очередь операций всегда вызывает операцию с наивысшим приоритетом по сравнению с другими готовыми операциями.

### ! Ниже по тексту описаны не все методы и свойства OperationQueue, надо будет доразобраться

## Заметки (надо доразобраться почему так):
- Нельзя одну и туже операцию добавлять в разные очереди (вылетает ошибка)
- Нельзя одну и туже операцию добавлять несколько раз в одну и туже очередь, что поочередного выполнения что для одновремменного выполнения


### Основное
```Swift
// Создание очереди операций - всегда ПАРАЛЛЕЛЬНАЯ
let operattionQueue = OperationQueue()

// результат: 333 444 111
operationQueue.addOperation { sleep(1); print("111") }
operationQueue.addOperation { print("333") }
print("444")

// Основная очередь - всегда ПОСЛЕДОВАТЕЛЬНАЯ
OperationQueue.main

// результат: 111 333 444 
OperationQueue.main.addOperation { sleep(1); print("111") }
OperationQueue.main.addOperation { print("333") }
print("444")

// говорит в какой очереди мы сейчас находимся
// глобально 'NSOperationQueue Main Queue'
print(OperationQueue.current)
```

### var qualityOfService: QualityOfService
```Swift
// var qualityOfService: QualityOfService { get set }
// Установка приоритета у очереди с которой будут выполнятся операции
// Значение этого свойства по умолчанию зависит от того, как вы создали очередь:
// - OperationQueue() - Background
// - OperationQueue.main - UserInteractive
// по экспериментам у OperationQueue.main приоритет не меняется, всегда максимум
operationQueue.qualityOfService = .userInteractive
operationQueue.qualityOfService = .userInitiated
operationQueue.qualityOfService = .utility
operationQueue.qualityOfService = .background
operationQueue.qualityOfService = .default
```

### var maxConcurrentOperationCount: Int { get set }
```Swift
// var maxConcurrentOperationCount: Int { get set }
// Максимальное количество операций в очереди, которые могут выполняться одновременно.
// результат: opSleep2Sec opSleep5Sec opSleep4Sec (т.к. выполнятся могут только 2 одновременно, то opSleep4Sec запустится когда opSleep2Sec закончит свое выполнение)
operationQueue.maxConcurrentOperationCount = 2
operationQueue.addOperation(opSleep5Sec)
operationQueue.addOperation(opSleep2Sec)
operationQueue.addOperation(opSleep4Sec)
```

### func addOperation(Operation)
```Swift
// func addOperation(Operation)
// добавление операции в OperationQueue
operattionQueue.addOperation(OperationA)
OperationQueue.main.addOperation(OperationB)
```

### func addOperation(() -> Void)
```Swift
// func addOperation(() -> Void)
// Обертывает указанный блок в операцию и добавляет его к OperationQueue.
operattionQueue.addOperation {
    print("Operation")
}
```

### func addOperations([Operation], waitUntilFinished: Bool)
```Swift
// func addOperations([Operation], waitUntilFinished: Bool)
// Добавляет несколько операций в OperationQueue. 
// waitUntilFinished - говорит нужно ли приостановить выполнение кода. 
// !При этом приостанавливает ВЕСЬ КОД после этой строки, а не только последующие операции в очереди. 
// ! Выполнение кода возобновляется после выполнения операций что были добавлены ИМЕННО В ЭТОМ МЕТОДЕ, а не все предыдущие что есть и выполняюся на данный момент в OperationQueue

// результат: opSleep1Sec opSleep2Sec (тут пауза код дальше не выполняется opSleep1Sec opSleep2Sec) print opSleep0Sec opSleep5Sec
operationQueue.addOperation(opSleep5Sec)
operationQueue.addOperations([opSleep2Sec, opSleep1Sec], waitUntilFinished: true)
print("print")
operationQueue.addOperation(opSleep0Sec)
```

### func addBarrierBlock(() -> Void)
```Swift
// func addBarrierBlock(() -> Void)
// Вызывает блок, когда очередь завершает все операции, поставленные в очередь, и предотвращает запуск последующих операций до тех пор, пока блок не будет завершен.
// останавливает именно операции в текущей очереди, а не во всех очередях, код что вне очереди продолжится выполненятся

// результат: 444 111 222 333
OperationQueue.main.addOperation { sleep(1); print("111") }
OperationQueue.main.addBarrierBlock {
    print("222")
}
OperationQueue.main.addOperation { print("333") }
print("444")

// результат: 444 111 222 333
operationQueue.addOperation { sleep(1); print("111") }
operationQueue.addBarrierBlock {
    print("222")
}
operationQueue.addOperation { print("333") }
print("444")
```

### func cancelAllOperations()
```Swift
// func cancelAllOperations()
// Этот метод вызывает метод cancel() для всех операций, находящихся в настоящее время в очереди. И устанавливает isCancelled в true (устанавливает именно в унаследованном родительском методе cancel()). Поэтому ВАЖНО! если мы переопределяем метод cancel() то в этом методе надо вручную задать значение isCancelled = true
// Мы в мейне должны создать бесконечный цикл в котором будет постоянно проверятся условие isCancelled, и если оно true то срабатывает наш написанный код на случай отмены, если false то выполняется наша необходимая операция.
// Пу сути отменая всегда происходит в мейне, так как именно там мы создаем проверку условия, и если операция отменена до ее выполнения она все равно равно зайдет в мейн и там выполнит наш код отмены при isCancelled = true
// Даже при отмененной операции всегда срабатывае КОМПЛИШН блок, прежде чем она будет удалена из очереди
operationQueue.cancelAllOperations()
```

### func waitUntilAllOperationsAreFinished()
```Swift
// func waitUntilAllOperationsAreFinished()
// Блокирует весь последующий код после этой строки, поток до тех пор, пока ВСЕ оперции выполняемые операции в OperationQueue не завершат выполнение.

// результат: -1- opSleep2Sec opSleep5Sec (тут пауза код дальше не выполняется пока не выполнятся opSleep2Sec opSleep5Sec) -2- -3- opSleep1Sec
operationQueue.addOperation(opSleep5Sec)
operationQueue.addOperation(opSleep2Sec)
print("-1-")
operationQueue.waitUntilAllOperationsAreFinished()
print("-2-")
operationQueue.addOperation(opSleep1Sec)
print("-3-")
```
