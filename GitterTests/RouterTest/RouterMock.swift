//
//  RouterMock.swift
//  GitterTests
//
//  Created by MacBook Pro on 5/15/22.
//

import Foundation
import UIKit

@testable import Gitter

protocol RouterMock: Router {
    var navigationStack: [UIViewController] {get}
    var presented: UIViewController? {get}
}

final class RouterMockImp: RouterMock {

    private(set) var navigationStack: [UIViewController] = []
    private(set) var presented: UIViewController?
    private var completions: [UIViewController : () -> Void] = [:]
    
    func toPresent() -> UIViewController? {
        return nil
    }
    
    func present(_ module: Presentable?) {
        present(module, animated: false)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        present(module, animated: false, fullscreen: false)
    }
    
    func present(_ module: Presentable?, animated: Bool, fullscreen: Bool) {
        guard let controller = module?.toPresent() else { return }
        presented = controller
    }
    
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationStack.append(controller)
    }
        
    func popModule(animated: Bool, hideBar: Bool) {
        let controller = navigationStack.removeLast()
        runCompletion(for: controller)
    }
    
    func push(_ module: Presentable?)  {
        push(module, animated: false)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }

    func push(_ module: Presentable?, hideBottomBar: Bool) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        controller.hidesBottomBarWhenPushed = hideBottomBar

        push(module, animated: false)
    }

    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {

        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationStack.append(controller)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }
        navigationStack.append(controller)
    }
    
    func show(_ module: Presentable?) {
        show(module, sender: nil)
    }

    func show(_ module: Presentable?, sender: Any?) {
        guard let controller = module?.toPresent() else { return }
        presented?.show(controller, sender: presented)
    }
    
    func popModule()  {
        popModule(animated: false)
    }
    
    func popModule(animated: Bool)  {
        let controller = navigationStack.removeLast()
        runCompletion(for: controller)
    }
    
    func dismissModule() {
        dismissModule(animated: false, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        presented = nil
    }
    
    func setRootModule(_ module: Presentable?) {
        guard let controller = module?.toPresent() else { return }
        navigationStack.append(controller)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        assertionFailure("This method is not used.")
    }

    func popToRootModule(animated: Bool) {
        guard let first = navigationStack.first else { return }
        
        navigationStack.forEach { controller in
            runCompletion(for: controller)
        }
        navigationStack = [first]
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
