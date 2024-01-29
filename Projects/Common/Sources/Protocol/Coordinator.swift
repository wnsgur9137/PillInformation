//
//  Coordinator.swift
//  Common
//
//  Created by JunHyeok Lee on 1/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public enum CoordinatorType {
    case tab, home, search, alarm, myPage
}

public protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController? { get set }
    var childCoordinator: [Coordinator] { get set }
    var type: CoordinatorType { get }
    
    func start()
    func finish()
}

public extension Coordinator {
    func finish() {
        childCoordinator.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

public protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
