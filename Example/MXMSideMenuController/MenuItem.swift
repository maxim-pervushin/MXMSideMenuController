//
// Created by Maxim Pervushin on 14/11/2016.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import Foundation

struct MenuItem {

    let title: String
    let viewControllerId: String

    init(title: String, viewControllerId: String) {
        self.title = title
        self.viewControllerId = viewControllerId
    }
}
