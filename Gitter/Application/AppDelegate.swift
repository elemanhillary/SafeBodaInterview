//
//  AppDelegate.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    weak var rootController: UINavigationController? {
        return (self.window!.rootViewController as? UINavigationController)
    }
    private lazy var applicationCoordinator: Coordinator = self.makeCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        applicationCoordinator.start()
        return true
    }
    
    private func makeCoordinator() -> Coordinator {
        let navigationController = UINavigationController()
        let router = RouterImp(rootController: navigationController)
        let coordinatorFactory = CoordinatorFactoryImp()
        let appCoordinator = ApplicationCoordinator(router: router, coordinatorFactory: coordinatorFactory)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return appCoordinator
    }
}

