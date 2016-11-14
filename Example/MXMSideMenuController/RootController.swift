//
// Created by Maxim Pervushin on 14/11/2016.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit
import MXMSideMenuController

class RootController: SideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let menu = storyboard?.instantiateViewController(withIdentifier: "Menu") as? MenuViewController {
            menu.delegate = self
            menuViewController = menu
        }
    }
}

extension RootController: MenuViewControllerDelegate {

    func menuViewController(_ menuViewController: MenuViewController, didSelectMenuItem menuItem: MenuItem) {
        contentViewController = storyboard?.instantiateViewController(withIdentifier: menuItem.viewControllerId)
        sideMenuController?.setMenuVisible(false, animated: true)
    }
}
