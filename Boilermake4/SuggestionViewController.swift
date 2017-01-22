//
//  SuggestionViewController.swift
//  Boilermake4
//
//  Created by Ryuji Mano on 1/21/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//

import UIKit

class SuggestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var product: String!
    var price: Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGo(_ sender: AnyObject) {
        /**let indexPath = NSIndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! SuggestionTableViewCell
        if let p = cell.price {
            price = p
        }
        if let p =  cell.item {
            product = p
        }**/
        performSegue(withIdentifier: "locationSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! LocationPickViewController
        dest.product = self.product
        dest.price = self.price
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath) as! SuggestionTableViewCell
        print(product)
        cell.itemLabel.text = product
        cell.priceLabel.text = "\(price!)"
        
        return cell
    }
}
