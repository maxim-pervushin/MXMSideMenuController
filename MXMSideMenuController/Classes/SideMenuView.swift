//
// Created by Maxim Pervushin on 09/11/2016.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

public protocol SlideViewDelegate: class {

    func slideView(_ slideView: SideMenuView, willSetVisibility visibility: CGFloat)

    func slideView(_ slideView: SideMenuView, didSetVisibility visibility: CGFloat)
}

public class SideMenuView: UIView {

    public enum Mode {
        case shiftMenuAndContent
        case shiftMenu
        case shiftContent
    }

    weak var delegate: SlideViewDelegate?

    var overlap: CGFloat = 0.75

    private (set) var menuVisible = false

    var menuMode: Mode = .shiftMenu {
        didSet {
            _adjustViewsOrder()
            _adjustMenuVisibility()
        }
    }

    var dimsContent: Bool = true {
        didSet {
            _adjustViewsOrder()
        }
    }

    var displaysShadow: Bool = true {
        didSet {
            _adjustMenuVisibility()
        }
    }

    var menuView: UIView? {
        willSet {
            if let newValue = newValue {
                _menuContainer.addSubview(newValue)
                newValue.frame = CGRect(x: 0, y: 0, width: _menuContainer.frame.width, height: _menuContainer.frame.height)
            }
        }
        didSet {
            oldValue?.removeFromSuperview()
        }
    }

    var contentView: UIView? {
        willSet {
            if let newValue = newValue {
                _contentContainer.addSubview(newValue)
                newValue.frame = CGRect(x: 0, y: 0, width: _contentContainer.frame.width, height: _contentContainer.frame.height)
            }
        }
        didSet {
            oldValue?.removeFromSuperview()
        }
    }

    public func setMenuVisible(_ visible: Bool, animated: Bool) {
        self.menuVisible = visible
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self._adjustMenuVisibility()
            }, completion: { (success) in })
        } else {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        _adjustViewsOrder()
        _adjustMenuVisibility()
        menuView?.layoutIfNeeded()
        contentView?.layoutIfNeeded()
    }

    private let _overlapView = UIView()

    private let _menuContainer = UIView()
    private let _contentContainer = UIView()
    private let _shadowView = ShadowView()

    private func _commonInit() {
        _shadowView.backgroundColor = .clear
        addSubview(_menuContainer)
        addSubview(_contentContainer)
        addSubview(_overlapView)
        addSubview(_shadowView)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self._tapGesture))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        _overlapView.addGestureRecognizer(tapGestureRecognizer)

        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self._leftSwipeGesture))
        leftSwipeGestureRecognizer.direction = .left
        leftSwipeGestureRecognizer.numberOfTouchesRequired = 1
        addGestureRecognizer(leftSwipeGestureRecognizer)

        let leftScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self._screenEdgePanGesture))
        leftScreenEdgePanGestureRecognizer.delegate = self
        leftScreenEdgePanGestureRecognizer.edges = .left
        leftScreenEdgePanGestureRecognizer.cancelsTouchesInView = true
        addGestureRecognizer(leftScreenEdgePanGestureRecognizer)
    }

    private func _adjustViewsOrder() {

        switch menuMode {
        case .shiftMenuAndContent:
            _shadowView.isHidden = true
            bringSubview(toFront: _contentContainer)
            bringSubview(toFront: _overlapView)
            _overlapView.backgroundColor = dimsContent ? UIColor(white: 0, alpha: 0.5) : .clear
            bringSubview(toFront: _menuContainer)

        case .shiftMenu:
            bringSubview(toFront: _contentContainer)
            _shadowView.isHidden = false
            _shadowView.horizontal = true
            _shadowView.shadowStartColor = UIColor(white: 0, alpha: 0.15)
            _shadowView.shadowEndColor = .clear
            bringSubview(toFront: _shadowView)
            _overlapView.backgroundColor = dimsContent ? UIColor(white: 0, alpha: 0.5) : .clear
            bringSubview(toFront: _overlapView)
            bringSubview(toFront: _menuContainer)

        case .shiftContent:
            bringSubview(toFront: _menuContainer)
            _shadowView.horizontal = true
            _shadowView.isHidden = false
            _shadowView.shadowStartColor = .clear
            _shadowView.shadowEndColor = UIColor(white: 0, alpha: 0.15)
            bringSubview(toFront: _shadowView)
            bringSubview(toFront: _contentContainer)
            _overlapView.backgroundColor = dimsContent ? UIColor(white: 0, alpha: 0.5) : .clear
            bringSubview(toFront: _overlapView)
        }
    }

    private func _adjustMenuVisibility() {
        _setMenuVisibility(menuVisible ? 1 : 0)
    }

    private func _setMenuVisibility(_ menuVisibility: CGFloat) {
        delegate?.slideView(self, willSetVisibility: menuVisibility)

        let menuWidth = bounds.width * overlap
        let offset = -(bounds.width * overlap * (1 - menuVisibility))

        let shadowWidth: CGFloat = displaysShadow ? 12 : 0

        switch menuMode {
        case .shiftMenuAndContent:
            _menuContainer.frame = CGRect(x: offset, y: 0, width: menuWidth, height: frame.height)
            _contentContainer.frame = CGRect(x: offset + menuWidth, y: 0, width: frame.width, height: frame.height)

        case .shiftMenu:
            _menuContainer.frame = CGRect(x: offset - shadowWidth * (1 - menuVisibility), y: 0, width: menuWidth, height: frame.height)
            _shadowView.frame = CGRect(x: offset + menuWidth - shadowWidth * (1 - menuVisibility), y: 0, width: shadowWidth, height: frame.height)
            _contentContainer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        case .shiftContent:
            _menuContainer.frame = CGRect(x: 0, y: 0, width: menuWidth, height: frame.height)
            _shadowView.frame = CGRect(x: offset + menuWidth - shadowWidth, y: 0, width: shadowWidth, height: frame.height)
            _contentContainer.frame = CGRect(x: offset + menuWidth, y: 0, width: frame.width, height: frame.height)
        }

        _overlapView.frame = _contentContainer.frame
        _overlapView.alpha = menuVisibility

        delegate?.slideView(self, didSetVisibility: menuVisibility)
    }

    @objc private func _tapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            setMenuVisible(!menuVisible, animated: true)
        }
    }

    @objc private func _leftSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        if !menuVisible {
            return
        }

        if sender.state == .recognized {
            setMenuVisible(false, animated: true)
        }
    }

    @objc private func _rightSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        if menuVisible {
            return
        }

        if sender.state == .recognized {
            setMenuVisible(true, animated: true)
        }
    }

    @objc private func _screenEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        if menuVisible {
            return
        }

        let translation = sender.translation(in: self).x

        if sender.state == .recognized {
            if translation > bounds.size.width / 4 {
                setMenuVisible(true, animated: true)
            } else {
                setMenuVisible(false, animated: true)
            }
        } else {
            let visibility = translation / bounds.width / overlap
            _setMenuVisibility(visibility < 1 ? visibility : 1)
        }
    }
}

extension SideMenuView: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UINavigationBar {
            return false
        } else {
            return true
        }
    }
}
