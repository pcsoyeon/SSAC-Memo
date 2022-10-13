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
        let config = Realm.Configuration(schemaVersion: 2) { migration, oldSchemaVersion in
            // 0 -> 1로 업데이트, 새로운 컬럼 추가
            if oldSchemaVersion < 1 {
                // 새로운 컬럼 추가는 따로 코드를 구현하지 않아도 된다.
            }
            
            // 1 -> 2로 업데이트, 컬럼 삭제
            if oldSchemaVersion < 2 {
                // 컬럼 삭제는 따로 코드를 구현하지 않아도 된다.
            }
        }
        
        Realm.Configuration.defaultConfiguration = config
    }
}
