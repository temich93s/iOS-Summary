# Closure

- Ниже пример, где мы создаем замыкание в первом VC, и которое мы можем передавать между VС, присваиваивая ссылку (замыкания ссылочный тип) на нее другим свойствам-замыканиям в других классах. Затем вызвав это передаваемое замыкание в другом классе выполнится код замыкания описанный в первом VC, так как они все содержали по сути ссылку на замыкание в первом VC

### Сокращение (typealias)

```Swift
typealias Closure = ((Person) -> ())
```

### Модель

```Swift
struct Person {
    var name: String
    var lastName: String
}
```

### ViewController1

```Swift
class ViewController1: UIViewController {
    lazy var closureVC1: Closure? = { [weak self] person in
        guard let self = self else { return }
        self.label1.text = person.name
        self.label2.text = person.lastName
    }

    override func viewDidLoad() {
        super.viewDidLoad()  
        let secondVC = ViewController2()
        secondVC.closureVC2 = closureVC1
    }
}
```

### ViewController2
```Swift
class ViewController2: UIViewController {
    var closureVC2: Closure?
    let personVC2 = Person(name: "Name", lastName: "LastName")
    
    override func viewDidLoad() {
        super.viewDidLoad()  
        let secondVC = ViewController3(closure: closureVC2, person: personVC2)
    }
}
```

### ViewController3
```Swift
class ViewController2: UIViewController {
    private var closureVC3: Closure?
    private var personVC3: Person
    
    init(closure: Closure?, person: Person) {
        closureVC3 = closure
        personVC3 = person
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        personVC3.name = "NAME1"
        personVC3.lastName = "LASTNAME2"
        closureVC3?(personVC3)
    }
}
```
