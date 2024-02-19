//
//  MainViewController.swift
//  SeSACAccountBook
//
//  Created by cho on 2/14/24.
//

import UIKit
import SnapKit
import RealmSwift
import FSCalendar

final class MainViewController: BaseViewController {
    let realm = try! Realm()
    
    let tableView = UITableView()
    let calendar = FSCalendar()
    //Results의 타입이 realm과 sync가 되어있다고 생각하면 됨! 그래서
    var list: Results<AccountBookTable>! //인스턴스에 대해서 100%보장! nil인 상황에서 앱이 꺼짐. 그런데 옵셔널바인딩같은거 안해줘도 돼서 좋긴함
    let repository = AccountBookTableRepository()
    //viewwillAppear에선 view만 다시 그려줘~(tableView.reloadData)를 해주면 됨. list는 viewdidload에 받아줘도 됨 -> realm이 알아서 반영해주고 있음,,
    //realm이 가진 특성이지 다른 DB는 다를 수 있음
    
    let dateFormat = DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormat.dateFormat = "yyyy년 MM월 dd일"
        print(realm.configuration.fileURL)
        showToast(message: "mainViewController입니다~!~")
        
        //1. realm 위치에 접근
//        let realm = try! Realm()
//        
//        //2. Realm 중 특정 하나의 테이블 가지고 오기
//        list = realm.objects(AccountBookTable.self)
        
        //let realm = try! Realm()
        //전체데이터를 money 컬럼 기준으로 정렬
        //list = realm.objects(AccountBookTable.self).sorted(byKeyPath: "money", ascending: true) //byKeyPath에 없는 값을 넣으면 런타임 에러발생
        
        //list = repository.fetchCategoryFilter("공부")
        list = repository.fetch()
        
        //filter 기능을 사용!
        //realm 데이터가 변경이 되면 list에서 알아서 반영! 즉, 테이블뷰 갱신만 고려하면 됨
//        list = realm.objects(AccountBookTable.self).where {
//            //$0.money >= 30000
//            //$0.type == true
//            $0.category == "공부"
//        }.sorted(byKeyPath: "money", ascending: true)
//        print("viewwillAppear", list.count)
    }
    
    //Realm 데이터가 추가가 안 될 때
    //Realm 데이터를 list로 잘 가지고 왔는지
    //list를 뷰에 잘 보이게 설정했는지
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
//        let realm = try! Realm()
//        //전체데이터를 money 컬럼 기준으로 정렬
//        //list = realm.objects(AccountBookTable.self).sorted(byKeyPath: "money", ascending: true) //byKeyPath에 없는 값을 넣으면 런타임 에러발생
//        
//        //filter 기능을 사용!
//        list = realm.objects(AccountBookTable.self).where {
//            //$0.money >= 30000
//            //$0.type == true
//            $0.category == "공부"
//        }.sorted(byKeyPath: "money", ascending: true)
//        print("viewwillAppear", list.count)
 
    }

    override func setAddView() {
        view.addSubview(tableView)
        view.addSubview(calendar)
    }
    
    override func configureLayout() {
        calendar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        tableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(calendar.snp.bottom)
        }
    }
    
    override func configureAttribute() {
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
        tableView.backgroundColor = .gray
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.backgroundColor = .white
        
        navigationItem.title = "용돈기입장"
        let image = UIImage(systemName: "plus")
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rightButtonItemTapped))
        navigationItem.rightBarButtonItem = item
        
        let today = UIBarButtonItem(title: "오늘", style: .plain, target: self, action: #selector(todayButtonTapped))
        let all = UIBarButtonItem(title: "전체", style: .plain, target: self, action: #selector(allButtonTapped))
        navigationItem.leftBarButtonItems = [today, all]
    }
    
    @objc func todayButtonTapped() {
        print(#function)
        //realm에서 오늘 날짜만 필터링해서 데이터 가지고 오고 이걸 list에 넣기
        //2024.02.19 00:00:00 - 2024.02.19 23:59:59
        //오늘 시작 날짜
        let start = Calendar.current.startOfDay(for: Date()) //지금의 날짜와 시간을 가져오면 됨
        
        //오늘 끝 날짜 == 내일 시작 날짜, end는 옵셔널 값
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date() //1이면 내일, -1이며 어제
        //쿼리작성
        let predicate = NSPredicate(format: "regDate >= %@ && regDate < %@", start as NSDate, end as NSDate) //format에 column 명이 들어옴
        //%@는 변수는 스트링의 경우, %@로 작성이 됨, 네모박스라고 생각하면 됨, 오른쪽에 있는데 %@에 들어오게 됨
        list = realm.objects(AccountBookTable.self).filter(predicate)
        tableView.reloadData()
    }
    
    @objc func allButtonTapped() {
        print(#function)
        list = repository.fetch()
        tableView.reloadData()
    }
    
    @objc func rightButtonItemTapped() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell")!
        
        //출력 확인하기,,,-> 현재시각과 영국표준시에 대해서 알아볼 수 있음
  
        let row = list[indexPath.row]
        
        let result = dateFormat.string(from: row.regDate)
        
        cell.textLabel?.text = "\(row.category) : \(row.money)원, \(result)"
        if let image = loadImageToDocument(filename: "\(row.id)") {
            cell.imageView?.image = image
        }
        
        //도큐먼트 폴더에 있는 이미지를 셀에 보여주기
        //도큐먼트 위치 찾기 > 경로 완성 > URL 
        
        
//        print(list[indexPath.row].regDate)
//        print(dateFormat.string(from: list[indexPath.row].regDate))
//        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Realm Delete : 1. realm 파일에서 제거!, 2. 이를 뷰에 반영
        //let realm = try! Realm()
        repository.deleteItem(list[indexPath.row])
//        try! realm.write { //추가, 수정, 삭제 모두 데이터를 쓰는 과정
//            realm.delete(list[indexPath.row])
//        }
        
        //Realm Update
        //1. 한 레코드에 특정 컬럼값을 수정하고 싶은 경우
        repository.updateFavorite(list[indexPath.row])
//        try! realm.write {
//            //list[indexPath.row].category = "졸음껌" //realm과 sync가 되어있어서 이렇게 해줘도 realm에 반영이 됨
//            list[indexPath.row].favorite.toggle()
//            list[indexPath.row].money = Int.random(in: 40000...1000000)
//        }
        
        //2. 테이블에서 전체 컬럼 정보를 변경하고 싶을 때
        repository.updateMoneyAll(money: 7777)
        //iOS에서도, realm에서도 setValue가 있기때문에 자동완성이 안뜸!
//        try! realm.write {
//            list.setValue(66666, forKey: "money")
//        }
        
        
        
        
        //3. 한 레코드에서 여러 칼럼 정보를 변경하고 싶을 떄
        
        repository.updateItem(id: list[indexPath.row].id, money: 123123, category: "수우저엉")
//        try! realm.write {
//            //어떤 값을 바꿔주는 지 알아야하기에 id도 넣어줌
//            realm.create(AccountBookTable.self, value: ["id": list[indexPath.row].id, "money": 999, "favorite": true], update: .modified)
//        }
//        
        tableView.reloadData()
    }
}


extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let start = Calendar.current.startOfDay(for: date)
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
        let predicate = NSPredicate(format: "regDate >= %@ && regDate < %@", start as NSDate, end as NSDate)

        //TODO: 여기서 tableView.reloadData()가 없으면 에러발생, 그런데 넣으면 오늘날짜의 todo가 바로 뜨지 않음
        list = realm.objects(AccountBookTable.self).filter(predicate)
        tableView.reloadData()
        return list.count
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print(#function, date)
        // 2/1 시작 날짜 이상 ~ 2/2 시작 날짜 미만
        //FS에서 제공해주는게 믿을만한가?,,항상 영국표준시 기준, 우리가 쓸 때, dateFormatter로 바꾸면 됨
        let start = Calendar.current.startOfDay(for: date) //지금의 날짜와 시간을 가져오면 됨
        //오늘 끝 날짜 == 내일 시작 날짜, end는 옵셔널 값
        let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date() //1이면 내일, -1이며 어제
        //쿼리작성
        let predicate = NSPredicate(format: "regDate >= %@ && regDate < %@", start as NSDate, end as NSDate) //format에 column명이 들어옴
        //%@는 변수는 스트링의 경우, %@로 작성이 됨, 네모박스라고 생각하면 됨, 오른쪽에 있는데 %@에 들어오게 됨
        list = realm.objects(AccountBookTable.self).filter(predicate)
        tableView.reloadData()
    }
    //날짜대신 string을 받게 됨
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "이 내용은 어디에 해당되는 걸까요"
//    }
}
