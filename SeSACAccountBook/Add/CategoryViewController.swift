//
//  CategoryViewController.swift
//  SeSACAccountBook
//
//  Created by cho on 2/14/24.
//

import UIKit

class CategoryViewController: BaseViewController {

    let categoryTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //post
        NotificationCenter.default.post(name: NSNotification.Name("CategoryReceived"), object: nil, userInfo: ["nickname": "moana", "category": categoryTextField.text!])// name기준으로 전달하게 됨
        
    }
    override func setAddView() {
        view.addSubview(categoryTextField)
    }
    
    override func configureAttribute() {
        super.configureAttribute()
        categoryTextField.placeholder = "카테고리 입력해주세용"
        categoryTextField.keyboardType = .numberPad
    }
    
    override func configureLayout() {
        categoryTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }
}
