//
//  HistoryViewController.swift
//  Boilermake4
//
//  Created by Ryuji Mano on 1/21/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var arr: [String] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let defaults = UserDefaults.standard
        
        budgetLabel.text = String(format:"$%.2f/$%.2f", defaults.value(forKey: "total") as! Double, defaults.value(forKey: "budget") as! Double)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        arr = getItems("coffee")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getItems(type: String) -> [String] {
        var price: String = ""
        var product: String = ""
        var lat: String = ""
        var lng: String = ""
        
        var result: [String] = []
        Alamofire.request("https://96838f4d.ngrok.io/getItem/" + type).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                price = "\(swiftyJsonVar[0].dictionary?["price"])"
                print(price)
                result.append(price)
                product = "\(swiftyJsonVar[0].dictionary?["product"])"
                result.append(product)
                lat = "\(swiftyJsonVar[0].dictionary?["lat"])"
                result.append(lat)
                lng = "\(swiftyJsonVar[0].dictionary?["long"])"
                result.append(lng)
                
            }
            
        }
        return result
    }
    
    func getItems() -> [String] {
        var price: String = ""
        var product: String = ""
        var lat: String = ""
        var lng: String = ""
        print("asdfasdf")
        var result: [String] = []
        Alamofire.request("https://96838f4d.ngrok.io/getAllItems/").responseJSON { (responseData) -> Void in
            print("asdfasdfasdf")
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                price = "\(swiftyJsonVar[0].dictionary?["price"])"
                print(price)
                result.append(price)
                product = "\(swiftyJsonVar[0].dictionary?["product"])"
                result.append(product)
                lat = "\(swiftyJsonVar[0].dictionary?["lat"])"
                result.append(lat)
                lng = "\(swiftyJsonVar[0].dictionary?["long"])"
                result.append(lng)
                print("asdfasdfasdfas")
            }
            
        }
        return result
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arr.count)
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemsTableViewCell
        
        print(arr[indexPath.row])
        cell.itemLabel.text = arr[indexPath.row * 4]
        cell.priceLabel.text = "\(arr[indexPath.row * 4 + 1])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mapSegue", sender: self)
    }

}
