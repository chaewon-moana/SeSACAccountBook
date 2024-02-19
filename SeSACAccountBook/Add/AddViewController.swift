//
//  AddViewController.swift
//  SeSACAccountBook
//
//  Created by cho on 2/14/24.
//

import UIKit
import SnapKit

protocol PassDataDelegate {
    func memoReceived(text: String)
}

class AddViewController: BaseViewController, PassDataDelegate {
    //왜 여기에 passDataDelegate했냐?, memobutton을 처리를 해야하기 떄문!
    
    func memoReceived(text: String) {
        memoButton.setTitle(text, for: .normal)
    }
    
    let moneyButton = UIButton()
    let categoryButton = UIButton()
    let memoButton = UIButton()
    let photoImageView = UIImageView()
    let addButton = UIButton()
    
    let repository = AccountBookTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addvc viewdidload")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(rightButtonTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(categoryReceivedNotification), name: Notification.Name("CategoryReceived"), object: nil)
    }
    
    @objc func rightButtonTapped() {
        
        //싱글톤으로 repository 만들어서 간단하게 넣어줄 수 있음
        let data = AccountBookTable(money: Int.random(in: 100...5000)*10,
                                    category: "공부",
                                    memo: "츄가추가",
                                    regDate: Date(),
                                    dataName: Date(),
                                    type: false)
        
        repository.createItem(data)
        
        
        //Filemanager를 통해 이미지 파일 자체를 도큐먼트에 저장
        //realm 레코드는 파일명으로 저장이 됨, 도큐먼트 이미지 경로를 저장
        //이미지 파일명을 어떻게 설정할 것인가?,,컬럼하나를 더 만들 필요가 있는가? 그런데 중복되면 안됨.
        //primary key인 id를 파일이름으로 저장해도 괜춘할듯, 날짜기반으로 저장하기도 함
        if let image = photoImageView.image {
            saveImageToDocument(image: image, filename: "\(data.id)")
        }
        

 
        //Realm에 내용(Record) 추가(create)하기..
        //1. realm을 찾아야함
//        let realm = try! Realm() //realm을 찾는 것
//        
//        print(realm.configuration.fileURL)
//        
//        //2. record 구성
//        let data = AccountBookTable(money: Int.random(in: 100...5000)*10,
//                                    category: "공부",
//                                    memo: "츄가추가",
//                                    regDate: Date(),
//                                    dataName: Date(),
//                                    type: false)
////        data.memo = "haha"
////        data.category = "Food"
////        data.type = false
//        
//        //3. 2번에서 만든 레코드를 realm에 추가
//        try! realm.write {
//            realm.add(data)
//            print("realm create")
//        }
    }
    
    @objc func categoryReceivedNotification(notification: NSNotification) {
        if let value = notification.userInfo?["category"] as? String {   //Any의 형태였기때문에 typeCasting이 필요
            categoryButton.setTitle(value, for: .normal)
        }
    }
    
    override func setAddView() {
        view.addSubview(moneyButton)
        view.addSubview(categoryButton)
        view.addSubview(memoButton)
        view.addSubview(photoImageView)
        view.addSubview(addButton)
    }
    
    override func configureAttribute() {
        super.configureAttribute() //Base에서 background의 컬러를 설정해두었기때문에
        moneyButton.backgroundColor = .black
        moneyButton.setTitleColor(.white, for: .normal)
        moneyButton.setTitle("금액", for: .normal)
        moneyButton.addTarget(self, action: #selector(moneyButtonTapped), for: .touchUpInside)
        
        categoryButton.backgroundColor = .black
        categoryButton.setTitleColor(.white, for: .normal)
        categoryButton.setTitle("카테고리", for: .normal)
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
        memoButton.backgroundColor = .black
        memoButton.setTitleColor(.white, for: .normal)
        memoButton.setTitle("메모", for: .normal)
        memoButton.addTarget(self, action: #selector(memoButtonTapped), for: .touchUpInside)
        
        photoImageView.backgroundColor = .lightGray
        
        addButton.backgroundColor = .black
        addButton.setTitleColor(.white, for: .normal)
        addButton.setTitle("이미지 추가", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    override func configureLayout() {
        moneyButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(moneyButton.snp.bottom).offset(20)
        }
        
        memoButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(categoryButton.snp.bottom).offset(20)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.centerX.equalTo(view)
            make.top.equalTo(memoButton.snp.bottom).offset(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(photoImageView.snp.bottom).offset(20)

        }
    }
 
    @objc func memoButtonTapped() {
        let vc = MemoViewController()
        vc.delegate = self
        NotificationCenter.default.post(name: Notification.Name("memoTest"), object: nil, userInfo: ["sesac": "여기 한 줄 메모 테스트 글자이다아"])
        navigationController?.pushViewController(vc, animated: true)
    }
      
    @objc func moneyButtonTapped() {
        let vc = MoneyViewController()
        vc.money = { money in
            print("머니머니")
            print(money)
            self.moneyButton.setTitle(money, for: .normal)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func categoryButtonTapped() {
        let vc = CategoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //카메라 촬영 갤러리 접근 기능(*시뮬에서 카메라 불가)
    //UIImagePickerController -> PHPickerViewController
    //out of process, 원래는 갤러리에 접근하시겠습니까?가 있었음. 근데 충돌이 나는 지점이 있음
    //out of process : 갤러리 가져오기는 권한 필요없음. 유저가 선택한 사진에 대해서는 권한 설정을 하지 않아도 됨!
    @objc func addButtonTapped() {
        print(#function)
        
        let vc = UIImagePickerController()
        //vc.sourceType = .camera //카메라 촬영하는 타입이 뜸
        vc.delegate = self
        vc.allowsEditing = true //편집할 수 있는 화면을 띄울것인가
        present(vc, animated: true)
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        //originalImage를 넣으면 편집을 해도 original이 들어감,,
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoImageView.image = pickedImage
        }
        
        dismiss(animated: true)
    }
}
