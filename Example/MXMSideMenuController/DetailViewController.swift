//
// Created by Maxim Pervushin on 14/11/2016.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailTextLabel: UILabel?

    var detailText: String? {
        didSet {
            reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    func reloadData() {
        if !isViewLoaded {
            return
        }

        detailTextLabel?.text = detailText
    }
}

