//
//  MemoViewController.swift
//  SeSACAccountBook
//
//  Created by cho on 2/14/24.
//

import UIKit

class MemoViewController: BaseViewController {

    let memoTextField = UITextField()
    var delegate: PassDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addObserver보다 post가 먼저 신호를 보내면, addObserver가 미리 보낸 post신호를 받지 못한다!
        
        NotificationCenter.default.addObserver(self, selector: #selector(memoTest), name: Notification.Name("memoTest"), object: nil)
    }
    
    @objc func memoTest(notification: NSNotification) {
        print("chkkkkk")
//        if let value = notification.userInfo?["sesac"] as? String {
//            memoTextField.text = value
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.memoReceived(text: memoTextField.text!)
        
    }
    override func setAddView() {
        view.addSubview(memoTextField)
    }
    
    override func configureAttribute() {
        super.configureAttribute()
        memoTextField.placeholder = "메모 입력해주세용"
    }
    
    override func configureLayout() {
        memoTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
    }

}
