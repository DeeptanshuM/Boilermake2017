//
//  SettingsViewController.swift
//  Boilermake4
//
//  Created by Ryuji Mano on 1/21/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var budgetTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    let arr = ["Cheapest", "Closest"]

    @IBAction func onTap(_ sender: AnyObject) {
        budgetTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        budgetTextField.delegate = self

        pickerView.delegate = self
        pickerView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGo(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        let check = budgetTextField.text == ""
        var budget: Double = defaults.value(forKey: "budget") as! Double
        if !check {
            budget = Double(budgetTextField.text!)!
        }
        let closest = arr[pickerView.selectedRow(inComponent: 0)] == "Closest"
        
        
        defaults.set(budget, forKey: "budget")
        defaults.set(closest, forKey: "closest")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
