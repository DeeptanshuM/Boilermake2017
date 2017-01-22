//
//  ViewController.swift
//  Boilermake4
//
//  Created by Deetpanshu Malik on 1/20/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class OCRViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    var image: UIImage?
    let ocr = CognitiveServices.sharedInstance.ocr
    
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var photoLibraryButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var useButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        retakeButton.isEnabled = false
        useButton.isEnabled = false
        retakeButton.isHidden = true
        useButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if defaults.value(forKey: "budget") == nil {
            defaults.set(200, forKey: "budget")
        }
        if defaults.value(forKey: "closest") == nil {
            defaults.set(false, forKey: "closest")
        }
        if defaults.value(forKey: "total") == nil {
            defaults.set(0.00, forKey: "total")
        }
        // Do any additional setup after loading the view, typically from a nib.
        //print(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true) {
            self.orLabel.text = ""
            self.useButton.isEnabled = true
            self.retakeButton.isEnabled = true
            self.useButton.isHidden = false
            self.retakeButton.isHidden = false
            
            self.photoLibraryButton.isEnabled = false
            self.takePhotoButton.isEnabled = false
            self.photoLibraryButton.isHidden = true
            self.takePhotoButton.isHidden = true
        }

    }
    
    func pullDataFromMDB(type: String) {
        
        Alamofire.request("https://3e7b6fab.ngrok.io/getItem/" + type).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                let price = swiftyJsonVar[0].dictionary?["price"]
                print(price)
            }
            
        }
    }
    
    func pushDataToMDB(product: String, price: Double, store: String, lat: String, long: String) {
        
        let parameters: [String: Any] = [
            "product": product,
            "price": price,
            "lat": lat,
            "long": long
        ]

        
        Alamofire.request("https://3e7b6fab.ngrok.io/addItem", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseString { response in
                print(response)
        }
   
        
        
    }


    
    //Mark: Variables we need
    
    var knownPlaces: Set = ["STARBUCKS", "Panera"]
    var knownProducts: Set = ["Coffee", "Pike"]
    var product_ycoordinate = [String: Int]()
    var ycoordinate_Price = [Int: Double]()
    //var largestYCoordinate = -1
    var toSend: [(x: String, y:String, z: Double)] = []
    var dasPlace: String = ""
    
    //MARK: Actions
    
    @IBAction func loadImageFromCamera(_ sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func loadImageFromPhotoLibrary(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func convertToText(_ sender: Any) {
        print("Convert command received")
        let requestObject: OCRRequestObject = (resource: UIImageJPEGRepresentation(image!, 0.8), language: .Automatic, detectOrientation: true)
        try! ocr.recognizeCharactersWithRequestObject(requestObject, completion: { (response) in
            print(response)
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response as! NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                
                guard let decoded = try JSONSerialization.jsonObject(with: jsonData, options: []) as? NSDictionary else {
                    
                    return
                }
                
                guard let regions = decoded["regions"] as? [NSDictionary] else {
                    return
                }
                
                for region in regions {
                    guard let lines = region["lines"] as? [NSDictionary] else {
                        return
                    }
                    
                    for line in lines {
                        guard let words = line["words"] as? [NSDictionary] else {
                            return
                        }
                        
                        for word in words {
                            let y = Int((word["boundingBox"]! as! String).components(separatedBy: ",")[3])!
                            let textFromImage = word["text"]! as! String
                            
                            print(y, textFromImage)
                            
                            if (self.knownPlaces.contains(textFromImage)){
                                if(textFromImage == "STARBUCKS"){
                                    self.dasPlace = "Starbucks"
                                }
                                else if(textFromImage == "Panera"){
                                    self.dasPlace = "Panera Bread"
                                }
                            }
                            
                            if(self.knownProducts.contains(textFromImage)){
                                self.product_ycoordinate[textFromImage] = y
                            }
                            
                            var Price = NumberFormatter().number(from: textFromImage)?.doubleValue
                            
                            if (Price != nil){
                                print(Price!)
                                //Round price tp 2 places
                                let temp = Price
                                Price = Double(round(100*temp!)/100)
                                
                                self.ycoordinate_Price[y] = Price
                            }
                        }
                        
                    }
                }
                
                
                
                
            } catch {
            }
            
            for(key, val) in self.product_ycoordinate{
                let v_lower = val - 5
                let v_upper = val + 6
                
                //print(key, val)
                
                var flag: Int = 0
                
                for i in val...v_upper {
                    if(self.ycoordinate_Price[i] != nil){
                        self.toSend.append((key, self.dasPlace, self.ycoordinate_Price[i]!))
                        flag = 1
                        break;
                    }
                }
                
                if(flag == 0){
                    for i in v_lower...val{
                        if(self.ycoordinate_Price[i] != nil){
                            self.toSend.append((key, self.dasPlace, self.ycoordinate_Price[i]!))
                            flag = 0
                            break;
                        }
                    }
                }
            }
            
            //      for(key, val) in self.ycoordinate_Price{
            //        print(key, val)
            //      }
            
            print("\nfinitto\n", self.toSend)
            print("\(self.ycoordinate_Price)")
            ////////////////////////////////////////////////////////////////////////////////////////
            
            // Save data to file
            //      let fileName = "Data"
            //      let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            //
            //      let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
            //      print("FilePath: \(fileURL.path)")
            //
            //      let writeString = text
            //      do {
            //        // Write to the file
            //        try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            //      } catch let error as NSError {
            //        print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            //      }
            //
            //      var readString = "" // Used to store the file contents
            //      do {
            //        // Read the file contents
            //        readString = try String(contentsOf: fileURL)
            //      } catch let error as NSError {
            //        print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
            //      }
            //      print("File Text: \(readString)")
            //
            //      self.textView.text = text
            //      print(response)
            //
            self.performSegue(withIdentifier: "suggestionSegue", sender: self)
        })
        
        
    }
    @IBAction func retake(_ sender: AnyObject) {
        useButton.isHidden = true
        retakeButton.isHidden = true
        useButton.isEnabled = false
        retakeButton.isEnabled = false
        
        photoLibraryButton.isHidden = false
        takePhotoButton.isHidden = false
        photoLibraryButton.isEnabled = true
        takePhotoButton.isEnabled = true
        orLabel.text = "OR"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! SuggestionViewController
        if self.toSend.count == 0 {
            let alert = UIAlertController(title: "An Error Ocurred", message: "We could not get your data.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        dest.product = self.toSend[0].x
        dest.price = self.toSend[0].z
    }
    
    
}
