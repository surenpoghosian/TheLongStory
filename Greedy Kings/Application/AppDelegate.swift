//
//  AppDelegate.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 21.09.23.
//

import UIKit
import CloudKit
//import FirebaseCore
//import FirebaseAnalytics
//import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("app got terminated")
        NotificationCenter.default.post(name: .appDidEnterBackground, object: nil)
        print("Notification sent")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
            // Handle the user's response
        }
        
        application.registerForRemoteNotifications()
        //        FirebaseApp.configure()
        //        Analytics.logEvent("AppLaunched", parameters: [
        //            "remember": "The ones who are crazy enough to think that they can change the world, are the ones who do."
        //        ])
        //
        //        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        //
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let container = CKContainer.default()
        let publicDatabase = container.publicCloudDatabase
        
        // Create a unique identifier for the subscription
        let subscriptionID = "GreedyKings-Notifications"
        
        // Use CKQuerySubscription's initializer with a subscriptionID parameter
        let subscription = CKQuerySubscription(recordType: "Notification", predicate: NSPredicate(value: true), subscriptionID: subscriptionID, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "New data available"
        subscription.notificationInfo = notificationInfo
        
        publicDatabase.save(subscription) { data, error in
            print("subscription saved", data, error)
            // Handle subscription save completion
        }
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Handle registration failure
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // ... Handle the incoming push notification ...
        completionHandler(.newData)
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
