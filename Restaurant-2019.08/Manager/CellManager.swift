//
//  CellManager.swift
//  Restaurant-2019.08
//
//  Created by Denis Bystruev on 22/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class CellManager {
    let networkManager = NetworkManager()
    
    func configure(_ cell: UITableViewCell, with category: String) {
        cell.textLabel?.text = category.localizedCapitalized
    }
    
    func configure(
        _ cell: UITableViewCell,
        with menuItem: MenuItem,
        for tableView: UITableView,
        indexPath: IndexPath
    ) {
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = menuItem.price.formattedHundreds
        
        if let image = menuItem.image {
            cell.imageView?.image = image
        } else {
            networkManager.getImage(menuItem.imageURL) { image, error in
                if let error = error {
                    print(#line, #function, "ERROR:", error.localizedDescription)
                }
                if let image = image {
                    menuItem.image = image
                    DispatchQueue.main.async {
                        tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
        
    }
}
