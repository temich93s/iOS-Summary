# Type Casting (Приведение типов)

- **Приведение типов** - это способ проверить тип экземпляра и/или способ обращения к экземпляру так, как если бы он был экземпляром суперкласса или подкласса откуда-либо из своей собственной классовой иерархии.

## 1. Общие сведения

- Вы можете использовать приведение типов с иерархией классов и подклассов, чтобы проверить тип конкретного экземпляра класса и преобразовать тип этого экземпляра в тип другого класса в той же иерархии. 

```Swift
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}
 
class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
// тип "library" выведен как [MediaItem]
```

## 2. Проверка типа

- Используйте оператор проверки типа (**is**) для проверки того, соответствует ли тип экземпляра типам какого-то определенного подкласса. Оператор проверки типа возвращает true, если экземпляр имеет тип конкретного подкласса, false, если нет. 

```Swift
var movieCount = 0
var songCount = 0
 
for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}
 
print("В Media библиотеке содержится \(movieCount) фильма и \(songCount) песни")
// Выведет "В Media библиотеке содержится 2 фильма и 3 песни"
```

## 3. Понижающее приведение

- Вы можете попробовать привести тип к типу подкласса при помощи оператора понижающего приведения (**as?** или **as!**).
  - Опциональная форма (**as?**) - возвращает опциональное значение типа, к которому вы пытаетесь привести. 
  - Принудительная форма (**as!**) - принимает попытки понижающего приведения и принудительного разворачивания результата в рамках одного составного действия.
- Приведение не изменяет экземпляра или его значений. Первоначальный экземпляр остается тем же. Просто после приведения типа с экземпляром можно обращаться (и использовать свойства) именно так как с тем типом, к которому его привели.

```Swift
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}
 
// Movie: Casablanca, dir. Michael Curtiz
// Song: Blue Suede Shoes, by Elvis Presley
// Movie: Citizen Kane, dir. Orson Welles
// Song: The One And Only, by Chesney Hawkes
// Song: Never Gonna Give You Up, by Rick Astley
```

## 4. Приведение типов для Any и AnyObject

- Swift предлагает две версии псевдонимов типа для работы с неопределенными типами:
  - **Any** может отобразить экземпляр любого типа, включая функциональные типы.
  - **AnyObject** может отобразить экземпляр любого типа класса. 
- Используйте Any и AnyObject только тогда, когда вам явно нужно поведение и особенности, которые они предоставляют. Всегда лучше быть конкретным насчет типов, с которыми вы ожидаете работать в вашем коде.

```Swift
var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })

for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called \(movie.name), dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}
 
// zero as an Int
// zero as a Double
// an integer value of 42
// a positive double value of 3.14159
// a string value of "hello"
// an (x, y) point at 3.0, 5.0
// a movie called Ghostbusters, dir. Ivan Reitman
// Hello, Michael
```

- Тип Any представляет собой значения любого типа, включая и опциональные типы. Swift предупредит вас, если вы используете опциональное значение в том месте, где ожидается тип Any. Если вы действительно хотите использовать опциональное значение в виде значения типа Any, то вы можете использовать оператор as, чтобы явно привести опционал к Any, как показано ниже.

```Swift
let optionalNumber: Int? = 3
things.append(optionalNumber)        // Warning
things.append(optionalNumber as Any) // No warning
```