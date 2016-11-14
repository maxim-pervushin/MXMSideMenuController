//
// Created by Maxim Pervushin on 14/11/2016.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel?

    var item: MenuItem? {
        didSet {
            _reloadData()
        }
    }

    private func _reloadData() {
        titleLabel?.text = item?.title
    }
}
