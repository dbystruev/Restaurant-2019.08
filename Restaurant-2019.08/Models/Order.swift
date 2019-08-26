//
//  Order.swift
//  Restaurant-2019.08
//
//  Created by Denis Bystruev on 26/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

struct Order {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
