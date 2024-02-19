//
//  RealmModel.swift
//  SeSACAccountBook
//
//  Created by cho on 2/15/24.
//

import Foundation
import RealmSwift
//프로퍼티가 변경,추가,삭제가 되면은 기존은 데이터들은 어떻게 해줄지를 다뤄줘야함..모든 버전들에 대한 관리를 해줘야함

class AccountBookTable: Object {
    //Realm에서 제공해주는 타입 종류 중 하나가 ObjectId.
    //pk의 역할을 할 수 있게, 겹치지 않는 값을 만들어줄게! -> objectid가 primary key라는 것은 아님, pk로 설정하기 좋다는 것!
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var money: Int //소비금액
    @Persisted var category: String //카테고리
    @Persisted var memo: String? //한줄메모(옵셔널)
    @Persisted var regDate: Date //등록일
    @Persisted var dataName: Date //소비날짜
    @Persisted var type: Bool //입금(true) 출금(false) 여부
    @Persisted var favorite: Bool //즐겨찾기
    
    //편의 생성자 convenience init
    convenience init(money: Int, category: String, memo: String? = nil, regDate: Date, dataName: Date, type: Bool) { //id는 내가 만들어줄거니까 init 안해줘도 돼~
        self.init() //id는 여기서 알아서 해줘~라는 것 
        self.money = money
        self.category = category
        self.memo = memo
        self.regDate = regDate
        self.dataName = dataName
        self.type = type
        self.favorite = false//일단 모든 내용을 false로 해두기
    }
}


