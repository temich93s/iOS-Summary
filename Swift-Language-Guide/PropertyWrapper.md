# Обертки для свойств

- Обертка свойства добавляет слой разделения между кодом, который определяет как свойство хранится и кодом, который определяет само свойство. Например, если у вас есть свойства, которые предоставляют потокобезопасную проверку или просто хранят данные в базе данных, то вы должны писать сервисный код для каждого свойства. Когда вы используете обертку, то вы пишете управляющий код один раз, а затем определяете обертку, которую можете переиспользовать для необходимых свойств.
- Для того, чтобы определить обертку, вы создаете структуру, перечисление или класс, который определяет свойство **wrappedValue**. 

```Swift
@propertyWrapper
struct TwelveOrLess {
    private var number = 0
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}
```

- Вы применяете обертку для свойства написав имя обертки перед свойством в виде атрибута. 

```Swift
struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var rectangle = SmallRectangle()
print(rectangle.height)
// Выведет "0"

rectangle.height = 10
print(rectangle.height)
// Выведет "10"

rectangle.height = 24
print(rectangle.height)
// Выведет "12"
```

- Когда вы применяете обертку к свойству, то компилятор синтезирует код, который предоставляет хранилище для обертки, а так же код, который предоставляет доступ к свойству через эту обертку. Вы можете написать код, который использует поведение обертки свойства, не используя преимущества специального синтаксиса атрибутов.

```Swift
struct SmallRectangle {
    private var _height = TwelveOrLess()
    private var _width = TwelveOrLess()
    var height: Int {
        get { return _height.wrappedValue }
        set { _height.wrappedValue = newValue }
    }
    var width: Int {
        get { return _width.wrappedValue }
        set { _width.wrappedValue = newValue }
    }
}
```

## Установка исходных значений для оберток свойств

- Для поддержки установки начального значения или другой настройки обертка свойств должна добавить инициализатор.

```Swift
@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int

    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, maximum) }
    }

    init() {
        maximum = 12
        number = 0
    }
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }
}
```

- Когда вы применяете обертку к свойству и не указываете начальное значение, Swift использует инициализатор init() для настройки обертки

```Swift
struct ZeroRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int
}

var zeroRectangle = ZeroRectangle()
print(zeroRectangle.height, zeroRectangle.width)
// Выведет "0 0"
```

- Когда вы указываете начальное значение для свойства, Swift использует инициализатор init(wrappedValue: ) для настройки обертки.

```Swift
struct UnitRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber var width: Int = 1
}

var unitRectangle = UnitRectangle()
print(unitRectangle.height, unitRectangle.width)
// Выведет "1 1"
```

- Когда вы пишете аргументы в скобках после настраиваемого атрибута, Swift использует инициализатор, который принимает эти аргументы, для настройки обертки. Например, если вы указываете начальное значение и максимальное значение, Swift использует инициализатор init(wrappedValue: maximum: )

```Swift
struct NarrowRectangle {
    @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
    @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
}

var narrowRectangle = NarrowRectangle()
print(narrowRectangle.height, narrowRectangle.width)
// Выведет "2 3"

narrowRectangle.height = 100
narrowRectangle.width = 100
print(narrowRectangle.height, narrowRectangle.width)
// Выведет "5 4"
```
- Включая аргументы в обертку свойства, вы можете настроить начальное состояние в обертке или передать другие параметры обертке при ее создании. Этот синтаксис является наиболее общим способом использования обертки свойства. Вы можете предоставить атрибуту любые необходимые аргументы, и они будут переданы инициализатору.
- Когда вы включаете аргументы обертки свойства, вы также можете указать начальное значение с помощью присваивания. Swift обрабатывает присвоение как аргумент wrappedValue и использует инициализатор, который принимает включенные вами аргументы. 

```Swift
struct MixedRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber(maximum: 9) var width: Int = 2
}

var mixedRectangle = MixedRectangle()
print(mixedRectangle.height)
// Выведет "1"

mixedRectangle.height = 20
print(mixedRectangle.height)
// Выведет "12"
```

## Проецирование значения из обертки свойства

- В дополнение к обернутому значению обертка свойства может предоставлять дополнительные функциональные возможности, определяя проецируемое значение, например, обертка свойства, которая управляет доступом к базе данных, может предоставлять метод flushDatabaseConnection() для ее проецируемого значения. Имя проецируемого значения такое же, как и значение в обертке, за исключением того, что оно начинается со знака доллара (**$**). Поскольку ваш код не может определять свойства, начинающиеся с символа $, проецируемое значение никогда не влияет на свойства, которые вы определяете.
- Приведенный ниже код добавляет свойство **projectedValue** в структуру SmallNumber, чтобы отслеживать, скорректировала ли обертка свойства новое значение свойства перед сохранением этого нового значения.
- Обертка свойства может возвращать значение любого типа в качестве своего проецируемого значения. Обертка, которая должна предоставлять больше информации, может вернуть экземпляр какого-либо другого типа данных или может вернуть self, чтобы предоставить экземпляр обертки в качестве его проецируемого значения.

```Swift
@propertyWrapper
struct SmallNumber {
    private var number = 0
    var projectedValue = false
    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }
}
struct SomeStructure {
    @SmallNumber var someNumber: Int
}
var someStructure = SomeStructure()

someStructure.someNumber = 4
print(someStructure.$someNumber)
// Выведет "false"

someStructure.someNumber = 55
print(someStructure.$someNumber)
// Выведет "true"
```

- Когда вы получаете доступ к проецируемому значению из кода, который является частью типа, например, для метода получения свойства или метода экземпляра, вы можете опустить self. перед именем свойства, как при доступе к другим свойствам.
- Поскольку синтаксис обертки свойства - это просто синтаксический сахар для свойства с геттером и сеттером, доступ к высоте и ширине ведет себя так же, как доступ к любому другому свойству.

```Swift
enum Size {
    case small, large
}

struct SizedRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int

    mutating func resize(to size: Size) -> Bool {
        switch size {
        case .small:
            height = 10
            width = 20
        case .large:
            height = 100
            width = 100
        }
        return $height || $width
    }
}
```
