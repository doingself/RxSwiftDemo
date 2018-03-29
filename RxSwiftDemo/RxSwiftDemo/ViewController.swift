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
    private var txtView: UITextView!
    private var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        
        label()
        textField()
        textView()
        button()
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
                print("textField 输入了 \(event)")
            }
            .disposed(by: disposeBag)
        
        // 记录输入的长度
        let input = field.rx.text.orEmpty.asDriver()
            .throttle(1)// 在主线程操作, 1秒内取最后一次
        input.map { "count: \($0.count)" }
            .drive(infoLab.rx.text)
            .disposed(by: disposeBag)
        
        field.rx.controlEvent(UIControlEvents.allEditingEvents).asObservable()
            .subscribe({ (event) in
                print("textField allEditingEvents subscribe \(event)")
            })
            .disposed(by: disposeBag)
    }
    
    private func textView(){
        txtView = UITextView(frame: CGRect(x: 20, y: 120+30+20, width: 200, height: 50))
        txtView.layer.borderWidth = 1
        self.view.addSubview(txtView)
        
        txtView.rx.didBeginEditing
            .subscribe(onNext: { (e) in
                print("UITextView didBeginEditing onNext \(e)")
            })
            .disposed(by: disposeBag)
        Observable.combineLatest(field.rx.text.orEmpty, txtView.rx.text.orEmpty) { (f, v) -> String in
            return "field:\(f) txtview:\(v)"
            }.subscribe { (event) in
                print("Observable.combineLatest \(event)")
        }.disposed(by: disposeBag)
    }
    
    private func button(){
        btn = UIButton(frame: CGRect(x: 20, y: 230, width: 90, height: 30))
        btn.setTitleColor(UIColor.blue, for: UIControlState.normal)
        btn.setTitleColor(UIColor.black, for: UIControlState.selected)
        btn.layer.borderWidth = 1
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 4
        self.view.addSubview(btn)
        
        btn.rx.tap.bind{
            print("button tap")
            }.disposed(by: disposeBag)
        
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        
        //根据索引数拼接最新的标题，并绑定到button上
        timer.map{"计数\($0)"}
            .bind(to: btn.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        let btn2 = UIButton(frame: CGRect(x: 120, y: 230, width: 90, height: 30))
        btn2.setTitle("btn2", for: UIControlState.normal)
        btn2.setTitleColor(UIColor.blue, for: UIControlState.normal)
        btn2.setTitleColor(UIColor.black, for: UIControlState.selected)
        btn2.layer.borderWidth = 1
        btn2.layer.cornerRadius = 4
        self.view.addSubview(btn2)
        
        let btn3 = UIButton(frame: CGRect(x: 220, y: 230, width: 90, height: 30))
        btn3.setTitle("btn3", for: UIControlState.normal)
        btn3.setTitleColor(UIColor.blue, for: UIControlState.normal)
        btn3.setTitleColor(UIColor.black, for: UIControlState.selected)
        btn3.layer.borderWidth = 1
        btn3.layer.cornerRadius = 4
        self.view.addSubview(btn3)
        
        // 单选按钮
        let btns = [btn, btn2, btn3].map{ $0! }
        btn.isSelected = true
        let selectBtn = Observable.from(
            btns.map{ b in
                b.rx.tap.map{ b }
            }
            ).merge()
        
        for b in btns{
            selectBtn.map{ $0 == b}.bind(to: b.rx.isSelected).disposed(by: disposeBag)
        }
        
    }
}

