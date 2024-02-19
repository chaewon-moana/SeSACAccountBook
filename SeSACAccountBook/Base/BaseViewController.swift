//
//  BaseViewController.swift
//  SeSACAccountBook
//
//  Created by cho on 2/14/24.
//

import UIKit
import Toast

class ParentBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("parent base viewdidload")
        test()
    }
    
    func test() {
        print(#function) //얘는 실행이 안됨
    }
}

class BaseViewController: ParentBaseViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddView()
        configureLayout()
        configureAttribute()
        test()
        print("base viewdidload")
    }
    
    override func test() { //parentBASE가 가진 것을 재정의 한 것
        print("override test")
    }
    
    func setAddView() { print(#function) }
    func configureLayout() { print(#function) }
    func configureAttribute() {
        view.backgroundColor = .white
        print(#function)
    }
   
    func showToast(message: String) {
        view.makeToast(message)
    }
    
    //func showAlert(title: String, message: String, ok: String, handler: @escaping ((UIAlertAction) -> Void)) {
    func showAlert(title: String, message: String, ok: String, handler: @escaping (() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //let ok = UIAlertAction(title: ok, style: .destructive, handler: handler)
        
        let ok = UIAlertAction(title: ok, style: .destructive) { _ in
            handler() //요렇게도 구현가능함!, 조금 더 자유롭게 쓸 수 있게하려면 이 방법이 좀 더 효율적이지 않을까,,,
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
