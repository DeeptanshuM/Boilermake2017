//
//  ViewController.swift
//  Boilermake4
//
//  Created by Deetpanshu Malik on 1/20/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//

import UIKit
import Foundation

class OCRViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var photoImageView: UIImageView!
  var image: UIImage?
  let ocr = CognitiveServices.sharedInstance.ocr
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    dismiss(animated: true, completion: nil)
  }
  
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
    
    let requestObject: OCRRequestObject = (resource: UIImageJPEGRepresentation(image!, 0.8), language: .Automatic, detectOrientation: true)
    try! ocr.recognizeCharactersWithRequestObject(requestObject, completion: { (response) in
      let text = self.ocr.extractStringFromDictionary(response!)
      
      ////////////////////////////////////////////////////////////////
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
        // here "jsonData" is the dictionary encoded in JSON data
        
        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
        // here "decoded" is of type `Any`, decoded from JSON data
        
        // you can now cast it with the right type
        if let dictFromJSON = decoded as? ([String:AnyObject?]) {
          // use dictFromJSON
          print(type(of: dictFromJSON))
          if let uno_nestedDictionary = dictFromJSON["regions"] as? [String: Any] {
            // access nested dictionary values by key
            //print(type(of: uno_nestedDictionary))
            if let dos_nestedDictionary = uno_nestedDictionary["lines"] as? [String: Optional<AnyObject>] {
              //print(dos_nestedDictionary["words"])
              if let tres_nestedDictionary = dos_nestedDictionary["words"] as? [String: Optional<AnyObject>]{
                print(tres_nestedDictionary["text"])
              }
            }
          }
        }
        
      } catch {
      }
      
      print("\nfinitto\n")
      ////////////////////////////////////////////////////////////////////////////////////////
      
      // Save data to file
      let fileName = "Data"
      let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      
      let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
      print("FilePath: \(fileURL.path)")
      
      let writeString = text
      do {
        // Write to the file
        try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
      } catch let error as NSError {
        print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
      }
      
      var readString = "" // Used to store the file contents
      do {
        // Read the file contents
        readString = try String(contentsOf: fileURL)
      } catch let error as NSError {
        print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
      }
      print("File Text: \(readString)")
      
      self.textView.text = text
      //print(response)
      
    })
    
    
  }
  
  
}

