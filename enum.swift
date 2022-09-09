// Ассоциированные параметры
// У каждого из членов перечисления могут быть ассоциированные с ним значения, то есть его характеристики. Они указываются для каждого члена точно так же, как входящие аргументы функции, то есть в круглых скобках с указанием имен и типов, разделенных двоеточием. Набор ассоциированных параметров может быть уникальным для каждого отдельного члена.
enum DollarCountries {
    case usa
    case canada
    case australia
}
enum AdvancedCurrencyUnit {
    case rouble(сountries: [String], shortName: String)
    case euro(сountries: [String], shortName: String)
    case dollar(nation: DollarCountries, shortName: String)
}
var dollarCurrency: AdvancedCurrencyUnit = .dollar( nation: .usa, shortName: "USD" )

// Вложенные перечисления
// Перечисления могут быть частью других перечислений, то есть могут быть опре- делены в области видимости родительских перечислений.
enum AdvancedCurrencyUnit1 {
    enum DollarCountries {
        case usa
        case canada
        case australia
    }
    case rouble(сountries: [String], shortName: String)
    case euro(сountries: [String], shortName: String)
    case dollar(nation: DollarCountries, shortName: String)
}
let australia: AdvancedCurrencyUnit1.DollarCountries = .australia

// Оператор switch для перечислений
// Для анализа и разбора значений перечислений можно использовать оператор switch.
switch dollarCurrency {
    case .rouble:
        print("Рубль")
    case let .euro(countries, shortname):
        print("Евро. Страны: \(countries). Краткое наименование: \(shortname)")
    case .dollar(let nation, let shortname):
        print("Доллар \(nation). Краткое наименование: \(shortname)")
 }

// Связанные значения членов перечисления
// Как альтернативу ассоциированным параметрам для членов перечислений им можно задать связанные значения некоторого типа данных (например, String, Character или Int). В результате вы получаете член перечисления и постоянно привязанное к нему значение.
enum Smile: String {
    case joy = ":)"
    case laugh = ":D"
    case sorrow = ":("
    case surprise = "o_O"
}

// Связанные значения и ассоциированные параметры не одно и то же. Первые устанавливаются при определении перечисления, причем обязательно для всех его членов и в одинаковом типе данных. Ассоциированные параметры могут быть различны для каждого перечисления и устанавливаются лишь при инициализации члена перечисления в качестве значения.

// Если в качестве типа данных перечисления указать Int, то исходные значения создаются автоматически путем увеличения значения на единицу для каждого последующего члена
enum Planet: Int {
      case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune, pluto = 999
}

// Доступ к связанным значениям
// При создании экземпляра перечисления можно получить доступ к исходному значению члена этого экземпляра перечисления. Для этого используется свойство rawValue.
let iAmHappy = Smile.joy
iAmHappy.rawValue // ":)"

// Инициализатор
// При объявлении структуры в ее состав обязательно входит специальный метод- инициализатор. Более того, вам даже не требуется его объявлять, так как эта возможность заложена в Swift изначально.
// Перечисления имеют всего один инициализатор init(rawValue:). Он позволяет передать связанное значение, соответствующее требуемому члену перечисления. Таким образом, у нас есть возможность инициализировать параметру конкретный член перечисления по связанному с ним значению.
// Данный метод не описан в теле перечисления, — он существует там всегда по умолчанию и закреплен в исходном коде языка Swift.
// Инициализатор init(rawValue:) возвращает опционал, поэтому если вы укажете несуществующее связанное значение, вернется nil.

let myPlanet = Planet.init(rawValue: 3) // earth
var anotherPlanet = Planet.init(rawValue: 11) // nil

// Свойства в перечислениях
// Свойство в перечислении — это хранилище, аналогичное переменной или кон- станте, объявленное в пределах перечисления, доступ к которому осуществляется через экземпляр перечисления.
// В Swift существует определенное ограничение для свойств в перечислениях: в качестве их значений не могут выступать фиксиро- ванные значения-литералы, только замыкания. Такие свойства называются вы- числяемыми. При каждом обращении к ним происходит вычисление присвоенного замыкания с возвращением получившегося значения.
// Вычисляемое свойство должно быть объявлено как переменная (var). В против- ном случае (если используете оператор let) вы получите сообщение об ошибке.
// С помощью оператора self внутри замыкания вы получаете доступ к текущему члену перечисления, при этом его использование не является обязательным.
enum Smile1: String {
    case joy = ":)"
    case laugh = ":D"
    case sorrow = ":("
    case surprise = "o_O"
    // вычисляемое свойство
    var description: String { return self.rawValue }
}
let mySmile: Smile1 = .sorrow
mySmile.description // ":("

// Методы в перечислениях
// Перечисления могут группировать в себе в том числе и методы.
enum Smile2: String {
    case joy = ":)"
    case laugh = ":D"
    case sorrow = ":("
    case surprise = "o_O"
    var description: String {return self.rawValue}
    func about() {
        print("Перечисление содержит список смайликов")
    }
}
var otherSmile = Smile2.joy
otherSmile.about()

// Оператор self
// Для организации доступа к текущему значению перечисления внутри этого перечисления используется оператор self. Данный оператор возвращает указатель на текущий конкретный член перечисления, инициализированный параметру.
enum Smile3: String {
    case joy = ":)"
    case laugh = ":D"
    case sorrow = ":("
    case surprise = "o_O"
    var description: String { return self.rawValue }
    func about() {
        print("Перечисление содержит список смайликов")
    }
    func descriptionValue() -> Smile3 {
        return self
    }
    func descriptionRawValue() -> String {
        // использование self перед rawValue не является обязательным
        return rawValue
    }
}
var otherSmile3 = Smile3.joy
otherSmile3.descriptionValue() // joy
otherSmile3.descriptionRawValue() // ":)"

// Рекурсивные перечисления
// Вы можете наделить перечисление функциональностью анализа собственного значения и вычисления на его основе выражений.
enum ArithmeticExpression {
    // указатель на конкретное значение
    case number( Int )
    // указатель на операцию сложения
    indirect case addition( ArithmeticExpression, ArithmeticExpression )
    // указатель на операцию вычитания
    indirect case subtraction( ArithmeticExpression, ArithmeticExpression )
    // метод, проводящий операцию
    func evaluate( _ expression: ArithmeticExpression? = nil ) -> Int {
        // определение типа операнда (значение или операция)
        switch expression ?? self {
            case let .number( value ):
                return value
            case let .addition( valueLeft, valueRight ):
                return evaluate( valueLeft ) + evaluate( valueRight )
            case .subtraction( let valueLeft, let valueRight ):
                return evaluate( valueLeft ) - evaluate( valueRight )
} }
}
let hardExpr = ArithmeticExpression.addition( .number(20), .subtraction( .number(10), .number(34) ) )
hardExpr.evaluate() // -4
