//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 623971951 on 2018/3/26.
//  Copyright © 2018年 syc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    
    private var lab: UILabel!
    private var field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        
        label()
        textField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: rx
    
    private func label(){
        lab = UILabel(frame: CGRect(x: 20, y: 80, width: 100, height: 30))
        lab.layer.borderWidth = 1
        lab.textAlignment = NSTextAlignment.center
        self.view.addSubview(lab)
        
        // 每0.1秒执行一次
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        timer.map {
            String(
                format: "%0.2d:%0.2d.%0.1d",
                arguments: [($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10]
            )
        }
        .bind(to: lab.rx.text)
        .disposed(by: disposeBag)
    }
    
    private func textField(){
        field = UITextField(frame: CGRect(x: 20, y: 120, width: 200, height: 30))
        field.borderStyle = .roundedRect
        self.view.addSubview(field)
        
        let infoLab = UILabel(frame: CGRect(x: 250, y: 120, width: 200, height: 30))
        infoLab.textAlignment = NSTextAlignment.center
        self.view.addSubview(infoLab)
        
        field.rx.text.orEmpty.asObservable()
        //field.rx.text.orEmpty.changed// changed 也可以
            .subscribe { (event) in
                print("输入了 \(event)")
            }
            .disposed(by: disposeBag)
        
        let input = field.rx.text.orEmpty.asDriver()
            .throttle(1)// 在主线程操作, 1秒内取最后一次
        input.map { "count: \($0.count)" }
            .drive(infoLab.rx.text)
            .disposed(by: disposeBag)
        
        
        
    }
}

