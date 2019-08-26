//
//  OrderTableViewController.swift
//  Restaurant-2019.08
//
//  Created by Denis Bystruev on 26/08/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    // MARK: - Constants
    let cellManager = CellManager()
    let networkManager = NetworkManager()
    
    // MARK: - Stored Properties
    var minutes = 0
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            tableView!,
            selector: #selector(UITableView.reloadData),
            name: OrderManager.orderUpdatedNotification,
            object: nil
        )
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "OrderConfirmationSegue" else { return }
        let destination = segue.destination as! OrderConfirmationViewController
        destination.minutes = minutes
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        OrderManager.shared.order = Order()
    }
    
    // MARK: - UITableViewSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderManager.shared.order.menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        let menuItem = OrderManager.shared.order.menuItems[indexPath.row]
        cellManager.configure(cell, with: menuItem, for: tableView, indexPath: indexPath)
        return cell
    }
    
    // MARK: - Custom Methods
    func uploadOrder() {
        let menuIDs = OrderManager.shared.order.menuItems.map { $0.id }
        networkManager.submitOrder(forMenuIDs: menuIDs) { minutes, error in
            if let error = error {
                print(#line, #function, "ERROR: \(error.localizedDescription)")
            } else {
                guard let minutes = minutes else {
                    print(#line, #function, "ERROR: didn't get minutes from server")
                    return
                }
                self.minutes = minutes
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "OrderConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        let orderTotal = OrderManager.shared.order.menuItems.reduce(0) { $0 + $1.price }
        
        let alert = UIAlertController(
            title: "Confirm Order",
            message: "You are about to submit your order with a total of \(orderTotal.formattedHundreds)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
            self.uploadOrder()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
