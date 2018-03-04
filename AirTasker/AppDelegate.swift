//
//  AppDelegate.swift
//  AirTasker
//
//  Created by Timothy Storey on 23/01/2018.
//  Copyright © 2018 BITE-Software. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataManager: DataControllerPrototcol!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        var persistenceManager: PersistenceControllerProtocol!
//        var sessionManager: URLSessionProtocol!
//        var locationManager: AnyMapper<Mapped<[LocationRaw]>>!
//        var localleManager: AnyMapper<Mapped<LocalleRaw>>!
//        var locationsViewController: LocationsViewController!
        
        
        PersistenceHelper.createProductionContainer{ container in
            let storyboard = (self.window?.rootViewController?.storyboard)!
            guard let vc = storyboard.instantiateViewController(withIdentifier: "LocationsViewController") as? LocationsViewController else {
                fatalError("Could not instantiate locations view controller")
            }
            let persistenceManager = PersistenceManager(store: container)
            let sessionManager = URLSession(configuration: URLSessionConfiguration.default)
            let locationManager = AnyMapper(LocationMapper(storeManager: persistenceManager))
            let localleManager = AnyMapper(LocalleMapper(storeManager: persistenceManager))
            self.dataManager = DataManager(storeManager: persistenceManager, urlSession: sessionManager, locationParser: locationManager, localleParser: localleManager)
            vc.dataManager = self.dataManager
            let nv = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = nv
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

