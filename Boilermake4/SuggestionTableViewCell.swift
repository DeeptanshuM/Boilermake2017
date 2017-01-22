//
//  SuggestionTableViewCell.swift
//  Boilermake4
//
//  Created by Ryuji Mano on 1/21/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var item: String?
    var price: Double?

    override func awakeFromNib() {
        super.awakeFromNib()
        itemTextField.delegate = self
        priceTextField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == itemTextField {
            item = itemTextField.text
        }
        else {
            price = Double(priceTextField.text!)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
