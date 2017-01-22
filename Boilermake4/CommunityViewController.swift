//
//  CommunityViewController.swift
//  Boilermake4
//
//  Created by Ryuji Mano on 1/21/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "mapSegue2", sender: self)
    }
}
