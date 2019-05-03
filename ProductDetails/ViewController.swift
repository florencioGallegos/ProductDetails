//
//  ViewController.swift
//  ProductDetails
//
//  Created by MAC Consultant on 4/15/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import UIKit

enum CompareResult {
    case same, different, tooMany, invalid, none
}

protocol ComparisonHandler: AnyObject {
    func select(row: Int)
    func compare() -> CompareResult
    func allSelected() -> Set<Int>
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ViewModelDelegate {

    @IBOutlet var tableView: UITableView!
    
    var viewModel: ProductViewModel!
    var comparisonHandler: ComparisonHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        let vm = ProductViewModel()
        vm.delegate = self
        comparisonHandler = vm
        viewModel = vm
        viewModel.getData()
    }
    
    // ViewModel
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // Compare
    
    @IBAction func compareButtonAction(_ sender: Any) {
        let result = comparisonHandler?.compare() ?? .none
        displayResult(result)
    }
    
    func displayResult(_ result: CompareResult) {
        
        let alert = UIAlertController(title: viewModel.displayResult(result), message: nil, preferredStyle: .alert)
        let close = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
    
    // TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = viewModel.item(row: indexPath.row)
        let id = product.pId
        let price = product.price.amount.rate
        cell.textLabel?.text = id + "\n" + price
        cell.textLabel?.numberOfLines = 0
        let selected = comparisonHandler?.allSelected().contains(indexPath.row) ?? false
        cell.backgroundColor = selected ? .gray : .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        comparisonHandler?.select(row: indexPath.row)
        updateUI()
    }

}

