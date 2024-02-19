//
//  FileManager+Extension.swift
//  SeSACAccountBook
//
//  Created by cho on 2/19/24.
//

import UIKit

extension UIViewController {
    
    func loadImageToDocument(filename: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "star")!}

        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        //이 경로에 실제로 파일이 존재하는 지 확인
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())!
        } else {
            return UIImage(systemName: "star.fill")!
        }
    }
    
    
    func saveImageToDocument(image: UIImage, filename: String) {
        //앱 도큐먼트 위치, filemanager라는 클래스를 통해 얻음, 싱글톤 패턴으로 적용하듯이 함
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        print(documentDirectory)
        
        //이미지를 저장할 경로(파일명) 지정
        //appendingPathComponent 얘가 슬래쉬 역할을 함
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }//사진을 압축해보고 싶다면, 이걸 사용
       // image.pngData() 이건 png로 사용
        //이미지 파일 저장
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
}
