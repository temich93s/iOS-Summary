# UIPageViewController



## 1. Создаем экземпляр класса UIPageViewController.

### Алгоритм действий:
- Устанавливаем себя источником данных для UIPageViewControllerDataSource

```Swift
class PageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // устанавливаем себя источником данных для UIPageViewControllerDataSource
        self.dataSource = self
    }
}
```

## 2. Подписываемся под протокол UIPageViewControllerDataSource

### Алгоритм действий:
- Подписываем экземпляр класса UIPageViewController под протокол UIPageViewControllerDataSource
- Реализовываем метод viewControllerBefore, который возвращает предыдущий UIViewController
- Реализовываем метод viewControllerAfter, который возвращает следующуй UIViewController
- Создаем свой собственный метод генерирующий ViewController для определенного индекса. 

### Примечание:
- **let vc = storyboard?.instantiateViewController(withIdentifier: "")** - Создает ViewController с указанным идентификатором (storyboard ID) и инициализирует его данными из storyboard

```Swift
// MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    
    // viewControllerBefore - возвращаем предыдущий ViewController
    // return nil - означает, что страница предыдущая/следующая не существует
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // получаем индекс предыдущего ViewController и отнимаем от него единицу
        let index = ((viewController as? SpaceRocketInfoViewController)?.index ?? 0) - 1
        // используем наш собственный метод генерирующий ViewController для определенного индекса
        return createPageViewController(for: index)
    }

    // viewControllerBefore - возвращаем следующуй ViewController
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // получаем индекс текущего ViewController и прибовляем к нему единицу
        let index = ((viewController as? SpaceRocketInfoViewController)?.index ?? 0) + 1
        // используем наш собственный метод генерирующий ViewController для определенного индекса
        return createPageViewController(for: index)
    }
    
    // метод генерирующий ViewController для определенного индекса
    func createPageViewController(for index: Int) -> UIViewController? {
        // проверяем что бы мы не вышли за пределы количества ViewController
        if (index < 0) || (index > 3) {
            return nil
        } else {
            // instantiateViewController - Создает ViewController с указанным идентификатором (storyboard ID) и инициализирует его данными из storyboard
            // И кастим результат до нашего кастомного ViewController
            let vc = storyboard?.instantiateViewController(withIdentifier: "SpaceRocketInfoSID") as? SpaceRocketInfoViewController
            vc?.index = index
            return vc
        }
    }
}
```
