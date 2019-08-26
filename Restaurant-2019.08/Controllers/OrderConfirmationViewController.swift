//
//  OrderConfirmationViewController.swift
//  Restaurant-2019.08
//
//  Created by Denis Bystruev on 26/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    @IBOutlet var timeRemainingLabel: UILabel!
    
    var minutes: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemainingLabel.text = "Thank you for your order!  Your waiting time is approximately \(minutes!) minutes."
    }
}
