//
//  ViewController.swift
//  SlideControllerReseach
//
//  Created by Maxim Pervushin on 08/11/2016.
//  Copyright © 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? DetailViewController,
           let selectedIndexPath = tableView.indexPathForSelectedRow {
            detail.detailText = "Item #\(selectedIndexPath.row)"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Item #\(indexPath.row)"
        return cell
    }
}
