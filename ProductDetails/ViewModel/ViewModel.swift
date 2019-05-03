//
//  ViewModel.swift
//  ProductDetails
//
//  Created by MAC Consultant on 4/15/19.
//  Copyright © 2019 MAC Consultant. All rights reserved.
//

import Foundation

private let apiUrlString = "https://api.myjson.com/bins/9asku"

protocol ViewModelDelegate: AnyObject {
    func updateUI()
}

protocol ViewModel: AnyObject {
    var delegate: ViewModelDelegate? { get set }
    func numberOfRows() -> Int
    func item(row: Int) -> Product
    func getData()
}

class ProductViewModel: ViewModel, ComparisonHandler {
    
    private var products = [Product]()
    weak var delegate: ViewModelDelegate?
    private var selected = Set<Int>()
    
    private func getProductDetails() {
        getProductDetailsHelper { [weak self] (products) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.products = products
            strongSelf.delegate?.updateUI()
        }
    }
    
    private func getProductDetailsHelper(_ completion: @escaping (([Product])->Void)) {
        let url = URL(string: apiUrlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(products)
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
    func select(row: Int) {
        if selected.contains(row) {
            selected.remove(row)
        }
        else {
            selected.insert(row)
        }
    }
    
    func displayResult(_ result: CompareResult)-> String {
        var text: String = ""
        switch (result) {
        case .different:
            text = "Both products are different"
        case .same:
            text = "Both products are same"
        case .tooMany:
            text = "Display Only two products can be selected"
        case .none:
            fallthrough
        case .invalid:
            return text
        }
        return text
    }
    
    func compare() -> CompareResult {
        let num = 2
        if selected.count > num {
            return .tooMany
        }
        if selected.count < num {
            return .invalid
        }
        let allVals = Array(selected)
        let first = allVals[0]
        for i in 1..<allVals.count {
            // if price and Item ID match display
            if products[first].price.amount.rate != products[allVals[i]].price.amount.rate &&
                products[first].pId != products[allVals[i]].pId {
                return .different
            }
        }
        return .same
    }
    
    func allSelected() -> Set<Int> {
        return selected
    }

}

extension ProductViewModel {
    func numberOfRows() -> Int {
        return products.count
    }
    func item(row: Int) -> Product {
        return products[row]
    }
    func getData() {
        self.getProductDetails()
    }
}
