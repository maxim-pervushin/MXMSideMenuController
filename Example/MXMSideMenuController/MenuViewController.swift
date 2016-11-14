//
// Created by Maxim Pervushin on 09/11/2016.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {

    func menuViewController(_ menuViewController: MenuViewController, didSelectMenuItem menuItem: MenuItem)
}

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?

    weak var delegate: MenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        _setActiveMenuItemAtIndex(0)
        _reloadData()
    }

    fileprivate let _menuItems = [
            MenuItem(title: "Preferences", viewControllerId: "Preferences"),
            MenuItem(title: "Navigation", viewControllerId: "Navigation"),
            MenuItem(title: "Tab Bar", viewControllerId: "TabBar"),
            MenuItem(title: "Red", viewControllerId: "Red"),
            MenuItem(title: "Green", viewControllerId: "Green"),
            MenuItem(title: "Blue", viewControllerId: "Blue"),
    ]

    fileprivate func _setActiveMenuItemAtIndex(_ index: Int) {
        _setActiveMenuItem(_menuItems[index])
    }

    fileprivate func _setActiveMenuItem(_ menuItem: MenuItem) {
        delegate?.menuViewController(self, didSelectMenuItem: menuItem)
    }

    fileprivate func _reloadData() {

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        cell.item = _menuItems[indexPath.row]
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _setActiveMenuItemAtIndex(indexPath.row)
    }
}
