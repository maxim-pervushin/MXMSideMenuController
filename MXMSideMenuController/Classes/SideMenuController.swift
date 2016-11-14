//
// Created by Maxim Pervushin on 09/11/2016.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

open class SideMenuController: UIViewController {

    var sideMenuView: SideMenuView! {
        return view as! SideMenuView
    }

    open var menuViewController: UIViewController? {
        willSet {
            if let newValue = newValue {
                addChildViewController(newValue)
                sideMenuView.menuView = newValue.view
            }
        }
        didSet {
            oldValue?.removeFromParentViewController()
        }
    }

    open var contentViewController: UIViewController? {
        willSet {
            if let newValue = newValue {
                addChildViewController(newValue)
                sideMenuView.contentView = newValue.view
            }
        }
        didSet {
            oldValue?.removeFromParentViewController()
        }
    }

    public var menuOverlap: Float {
        set {
            sideMenuView.overlap = CGFloat(newValue)
        }
        get {
            return Float(sideMenuView.overlap)
        }
    }

    public var mode: SideMenuView.Mode {
        set {
            sideMenuView.menuMode = newValue
        }
        get {
            return sideMenuView.menuMode
        }
    }

    public var dimContent: Bool {
        set {
            sideMenuView.dimsContent = newValue
        }
        get {
            return sideMenuView.dimsContent
        }
    }

    public var showShadow: Bool {
        set {
            sideMenuView.displaysShadow = newValue
        }
        get {
            return sideMenuView.displaysShadow
        }
    }

    public var menuVisible: Bool {
        return sideMenuView.menuVisible
    }

    public func setMenuVisible(_ visible: Bool, animated: Bool) {
        sideMenuView.setMenuVisible(visible, animated: animated)
    }

    override open func loadView() {
        let sideMenuView = SideMenuView()
        sideMenuView.delegate = self
        view = sideMenuView
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return _statusBarStyle
    }

    fileprivate var _statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}

extension SideMenuController: SlideViewDelegate {

    public func slideView(_ slideView: SideMenuView, willSetVisibility visibility: CGFloat) {
        if visibility >= 0.5 {
            _statusBarStyle = menuViewController?.preferredStatusBarStyle ?? .default
        } else {
            _statusBarStyle = contentViewController?.preferredStatusBarStyle ?? .default
        }
    }

    public func slideView(_ slideView: SideMenuView, didSetVisibility visibility: CGFloat) {
    }
}

public extension UIViewController {

    @IBAction public func showMenu(_ sender: AnyObject) {
        sideMenuController?.setMenuVisible(true, animated: true)
    }

    @IBAction public func hideMenu(_ sender: AnyObject) {
        sideMenuController?.setMenuVisible(false, animated: true)
    }

    @IBAction public func toggleMenu(_ sender: AnyObject) {
        if let sideMenuController = sideMenuController {
            sideMenuController.setMenuVisible(!sideMenuController.menuVisible, animated: true)
        }
    }

    public var sideMenuController: SideMenuController? {
        var p: UIViewController? = parent
        while (p != nil) {
            if let slideController = p as? SideMenuController {
                return slideController
            } else {
                p = p?.parent
            }
        }
        return nil
    }
}
