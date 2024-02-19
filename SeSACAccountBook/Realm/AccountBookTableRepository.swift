//
//  AccountBookTableRepository.swift
//  SeSACAccountBook
//
//  Created by cho on 2/16/24.
//

import Foundation
import RealmSwift

final class AccountBookTableRepository { //realm이 class 형태로 동작하고 있다보니 class로 많이 만들어둠
    
    private let realm = try! Realm()
    
    func createItem(_ item: AccountBookTable) {
        do {//옵셔널을 최대한 쓰지말고 써보자!
            try realm.write {
                realm.add(item)
                print("Realm create")
            }
        } catch {
            print(error)
        }
        
        //        try! realm.write { //try만 쓰는 것보다 do try catch를 사용하면 좀 더 안전함!
        //            realm.add(item)
        //            print("Realm create")
        //        }
    }
    
    //테이블에서 데이터 다 가져오도록 하는 코드
    func fetch() -> Results<AccountBookTable> {
         return realm.objects(AccountBookTable.self)
    }
    
    func fetchCategoryFilter(_ category: String) -> Results<AccountBookTable> {
        realm.objects(AccountBookTable.self).where {
            $0.category == category
        }.sorted(byKeyPath: "money", ascending: true)
    }
    
    func updateItem(id: ObjectId, money: Int, category: String) {
        do {
            try realm.write {
                realm.create(AccountBookTable.self, value: ["id": id, "money": money, "category": category], update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    //테이블을 중 한 컬럼에 대한 값을 전체 수정하고 싶을 때
    func updateMoneyAll(money: Int) {
        do {
            try realm.write {
                realm.objects(AccountBookTable.self).setValue(money, forKey: "money") //fetch처럼 가져와서 setValue 해주는 것!
            }
        } catch {
            print(error)
        }
    }
    
    func updateFavorite(_ item: AccountBookTable) {
        do {
            try realm.write {
                //list[indexPath.row].category = "졸음껌" //realm과 sync가 되어있어서 이렇게 해줘도 realm에 반영이 됨
                item.favorite.toggle()
                item.money = Int.random(in: 40000...1000000)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteItem(_ item: AccountBookTable) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
}
