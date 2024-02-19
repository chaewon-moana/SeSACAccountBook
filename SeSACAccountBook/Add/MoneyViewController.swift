//
//  MoneyViewController.swift
//  SeSACAccountBook
//
//  Created by cho on 2/14/24.
//

import UIKit
import SnapKit

class MoneyViewController:BaseViewController {

    let moneyTextField = UITextField()
    var money: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Responder Chain
        //키보드 자동으로 올라오기
        moneyTextField.becomeFirstResponder()

    }
    //이건 바로 바뀜
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        money?(moneyTextField.text!)
    }
    
    //화면이 전환되고 나서 값이 바뀜, 상황에 따라 적용해서 하면 될듯
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //키보드 자동으로 내려가기
        moneyTextField.resignFirstResponder()
    }
    override func setAddView() {
        view.addSubview(moneyTextField)
    }
    
    override func configureAttribute() {
        super.configureAttribute() //Base에서 background의 컬러를 설정해두었기때문에
        moneyTextField.placeholder = "금액을 입력해주세요"
        moneyTextField.keyboardType = .numberPad
    }
    
    override func configureLayout() {
        moneyTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
   
}
