//
//  STTabBarViewController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/11.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class STTabBarViewController: UITabBarController {

    private let tabs: [Tab] = [.lobby, .product, .trolley, .profile]
    
    private var trolleyTabBarItem: UITabBarItem?
    
    private var orderObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = tabs.map { $0.makeViewController() }

        trolleyTabBarItem = viewControllers?[2].tabBarItem
        trolleyTabBarItem?.badgeColor = .brown
        
        orderObserver = StorageManager.shared.observe(
            \StorageManager.orders,
            options: .new,
            changeHandler: { [weak self] _, change in
                guard let newValue = change.newValue else { return }
                if newValue.count > 0 {
                    self?.trolleyTabBarItem?.badgeValue = String(newValue.count)
                } else {
                    self?.trolleyTabBarItem?.badgeValue = nil
                }
            }
        )
        
        StorageManager.shared.fetchOrders()
        
        delegate = self
        
        buttonSetting()
    }
    
    func buttonSetting() {
        let xPoint = ((view.frame.width) / 60) * 26.2
        let yPoint = ((view.frame.height) / 40) * 34.5
        let floatingButton = FloatingButton(frame: CGRect(x: xPoint, y: yPoint, width: 45, height: 45))
        floatingButton.addTarget(self, action: #selector(sellerMode), for: .touchUpInside)
        self.view.addSubview(floatingButton)
    }
}

// MARK: - Tabs
extension STTabBarViewController {
    private enum Tab {
        case lobby
        case product
        case profile
        case trolley

        func makeViewController() -> UIViewController {
            let controller: UIViewController
            switch self {
            case .lobby: controller = UIStoryboard.lobby.instantiateInitialViewController()!
            case .product: controller = UIStoryboard.product.instantiateInitialViewController()!
            case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!
            case .trolley: controller = UIStoryboard.trolley.instantiateInitialViewController()!
            }
            controller.tabBarItem = makeTabBarItem()
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
            return controller
        }
        
        private func makeTabBarItem() -> UITabBarItem {
            return UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
        }
        
        private var image: UIImage? {
            switch self {
            case .lobby:
                return .asset(.Icons_36px_Home_Normal)
            case .product:
                return .asset(.Icons_36px_Catalog_Normal)
            case .trolley:
                return .asset(.Icons_36px_Cart_Normal)
            case .profile:
                return .asset(.Icons_36px_Profile_Normal)
            }
        }
        
        private var selectedImage: UIImage? {
            switch self {
            case .lobby:
                return .asset(.Icons_36px_Home_Selected)
            case .product:
                return .asset(.Icons_36px_Catalog_Selected)
            case .trolley:
                return .asset(.Icons_36px_Cart_Selected)
            case .profile:
                return .asset(.Icons_36px_Profile_Selected)
            }
        }
    }
}

// MARK: - UITabBarControllerDelegate
extension STTabBarViewController: UITabBarControllerDelegate {

    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        guard
            let navVC = viewController as? UINavigationController,
            navVC.viewControllers.first is ProfileViewController
        else {
            return true
        }
        
        if KeyChainManager.shared.token != nil {
            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                authVC.modalPresentationStyle = .overCurrentContext
                present(authVC, animated: false, completion: nil)
            }
            return false
        } else {
            return true
        }
    }
    
    @objc func sellerMode() {
        // 點擊時要判斷是否有 token 如果有則是跳出 Alert 不然就是跳出 FB 登入
        if KeyChainManager.shared.token != nil {
            if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                authVC.modalPresentationStyle = .overCurrentContext
                present(authVC, animated: false, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "進入我的賣場", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "返回", style: .cancel) { _ in
                alert.dismiss(animated: true)
            }
            
            let confirmAction = UIAlertAction(title: "確定", style: .default) { _ in
                print("進入商品頁")
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
}
