cmd + shift + . - отображение скрытых файлов в папке

//
//  ViewController.swift
//  UIKitDZ
//
//  Created by 2lup on 21.09.2022.
//

import UIKit

/// ViewController
class ViewController: UIViewController {

    // создаем UISwitch()
    let mySwitch = UISwitch()
    let mySwitch2 = UISwitch()
    let button = UIButton()
    // frame
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // создали switch
        self.mySwitch.frame = CGRect(x: 100, y: 100, width: 0, height: 0)
        // отображаем на экране
        self.view.addSubview(self.mySwitch)
        // включили
        self.mySwitch.setOn(true, animated: true)
        
        // mySwitch.isOn - включен ли?
        if self.mySwitch.isOn {
            print("свитч включен")
        }
        
        // наблюдатель - будет наблюдать и вызываться за установленной характеристикой
        // селектор - это функция которую будет вызывать наблюдатель (принимаемые параметры через :)
        self.mySwitch.addTarget(self, action: #selector(switcChange(paramTarget:)), for: .valueChanged)

        // устанавливаем в позицию 0 0
        self.mySwitch2.frame = CGRect.zero
        // помещаем центр свича в центр view
        self.mySwitch2.center = self.view.center
        // добавляем сам свитч во вью
        self.view.addSubview(self.mySwitch2)
        // оттенок
        self.mySwitch2.tintColor = UIColor.green
        // цвет ручажка
        self.mySwitch2.thumbTintColor = UIColor.red
        // цвет включенного состояния
        self.mySwitch2.onTintColor = UIColor.blue
        
        self.button.frame = CGRect(x: 100, y: 200, width: 200, height: 100)
        self.button.backgroundColor = UIColor.orange
        self.button.setTitle("OK", for: .normal)
        self.button.setTitle("нажата", for: .highlighted)
        self.view.addSubview(button)
        
        self.mySwitch2.addTarget(self, action: #selector(isOn(target:)), for: .valueChanged)
        
    }
    
    // селектор
    @objc func switcChange(paramTarget: UISwitch) {
        print("text:", paramTarget)
        if paramTarget.isOn {
            print("свитч включен")
        }
    }
    
    @objc func isOn(target: UISwitch) {
        if target.isOn {
            // отключаем кнопку
            self.button.isUserInteractionEnabled = false
        } else {
            self.button.isUserInteractionEnabled = true
        }
    }
    
}
