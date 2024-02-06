//
//  TabBarViewController.swift
//  ZrobiQR
//
//  Created by SHIN MIKHAIL on 06.02.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        tabBar.backgroundColor = .systemGray6 // цвет таб бара
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: Create TabBar
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: MainViewController(),
                title: "QR-Code",
                image: UIImage(systemName: "qrcode")),
            generateVC(
                viewController: ScanerViewController(),
                title: "Scaner",
                image: UIImage(systemName: "qrcode.viewfinder")),
            generateVC(
                viewController: InfoViewController(),
                title: "About",
                image: UIImage(systemName: "info.circle")),
        ]
    }
    // Generate View Controllers
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
}
