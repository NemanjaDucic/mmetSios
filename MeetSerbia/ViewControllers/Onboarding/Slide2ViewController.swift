//
//  ss.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.3.23..
//

import Foundation
import UIKit
class Slide2ViewController: UIViewController {

    
    var index: Int = 0
    
    @IBOutlet weak var tvDesc: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        uiSetup()
        
    }
    private func uiSetup(){
        view.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 228/255, alpha: 1)
        tvDesc.text = "Оснивач је Мисије, сада Задужбине Манастира Хиландара у Београду, којом је руководио три године. Такође је оснивач Издавачке куће „Принцип Прес“ и престижног магазина Србија – Национална ревија. \n\nПриређивач је капиталних монографија на више светских језика: Туристичка библија Србије, Србија – од злата јабука, Бој изнад векова – стогодишњица Кумановске битке, Србија – друмовима, пругама, рекама и др. \n\nРуководилац је више пројеката из области културе, међу којима су значајнији „Србија на међународним сајмовима књига – Лајпциг, Пекинг, Москва, Франкфурт 2019“ као и подухват дигитализације културног наслеђа и савременог стваралаштва „Србија национална ревија — пут у дигитализовани свет културне баштине Србије“."
        tvDesc.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 228/255, alpha: 1)
    }
}
