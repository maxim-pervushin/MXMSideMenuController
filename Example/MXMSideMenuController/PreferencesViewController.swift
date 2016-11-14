//
// Created by Maxim Pervushin on 11/11/2016.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class PreferencesViewController: UITableViewController {

    @IBOutlet weak var menuModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var overlapLabel: UILabel!
    @IBOutlet weak var overlapSlider: UISlider!
    @IBOutlet weak var dimContentSwitch: UISwitch!
    @IBOutlet weak var showShadow: UISwitch!

    @IBAction func menuModeSegmentedControlValueChanged(_ sender: Any) {
        switch menuModeSegmentedControl.selectedSegmentIndex {
        case 0:
            sideMenuController?.mode = .shiftMenuAndContent
        case 1:
            sideMenuController?.mode = .shiftMenu
        default:
            sideMenuController?.mode = .shiftContent
        }
    }

    @IBAction func overlapSliderValueChanged(_ sender: Any) {
        sideMenuController?.menuOverlap = overlapSlider.value
        if let sideMenuController = sideMenuController {
            overlapLabel.text = "\(sideMenuController.menuOverlap)"
        }
    }

    @IBAction func dimContentSwitchValueChanged(_ sender: Any) {
        sideMenuController?.dimContent = dimContentSwitch.isOn
    }

    @IBAction func showShadowSwitchValueChanged(_ sender: Any) {
        sideMenuController?.showShadow = showShadow.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _reloadData()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    fileprivate func _reloadData() {
        guard let sideMenuController = sideMenuController else {
            return
        }

        switch sideMenuController.mode {
        case .shiftMenuAndContent:
            menuModeSegmentedControl.selectedSegmentIndex = 0
        case .shiftMenu:
            menuModeSegmentedControl.selectedSegmentIndex = 1
        case .shiftContent:
            menuModeSegmentedControl.selectedSegmentIndex = 2
        }

        overlapSlider.value = sideMenuController.menuOverlap
        overlapLabel.text = "\(sideMenuController.menuOverlap)"

        dimContentSwitch.isOn = sideMenuController.dimContent
        showShadow.isOn = sideMenuController.showShadow
    }
}
