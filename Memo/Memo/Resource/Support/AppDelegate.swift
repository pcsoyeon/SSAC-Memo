//
//  AppDelegate.swift
//  Memo
//
//  Created by 소연 on 2022/08/31.
//

import UIKit

import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        aboutRealmMigration()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func aboutRealmMigration() {
        // ✅ 
        let config = Realm.Configuration(schemaVersion: 4) { migration, oldSchemaVersion in
            // 0 -> 1로 업데이트, 새로운 컬럼 추가
            if oldSchemaVersion < 1 {
                // 새로운 컬럼 추가는 따로 코드를 구현하지 않아도 된다.
            }
            
            // 1 -> 2로 업데이트, 컬럼 삭제
            if oldSchemaVersion < 2 {
                // 컬럼 삭제는 따로 코드를 구현하지 않아도 된다.
            }
            
            // 2 -> 3으로 업데이트, 컬럼명 변경
            if oldSchemaVersion < 3 {
                // onType: 테이블 이름
                // from: 이전 컬럼명
                // to: 바꾸고 싶은 컬럼명
                migration.renameProperty(onType: Memo.className(), from: "isPinned", to: "isFixed")
            }
            
            // ✅ 3 -> 4로 업데이트, 컬럼 결합
            if oldSchemaVersion < 4 {
                migration.enumerateObjects(ofType: Memo.className()) { oldObject, newObject in
                    guard let new = newObject else { return } // 새롭게 생길 컬럼
                    guard let old = oldObject else { return } // 기존의 컬럼 
                    
                    new["memoInfo"] = "제목: \(old["memoTitle"]!), 내용: \(old["memoContent"]!), 날짜: \(old["memoDate"]!)"
                }
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
    }
}
