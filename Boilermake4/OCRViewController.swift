//
//  ViewController.swift
//  Boilermake4
//
//  Created by Deetpanshu Malik on 1/20/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//

import UIKit

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
  
  @IBAction func loadImageFromPhotoLibrary(_ sender: UIButton) {
    
      let imagePickerController = UIImagePickerController()
      imagePickerController.sourceType = .photoLibrary
      imagePickerController.delegate = self
    
    
      
      present(imagePickerController, animated: true, completion: nil)
      
      
    }
    
    @IBAction func convertToText(_ sender: Any) {
        
        let requestObject: OCRRequestObject = (resource: UIImagePNGRepresentation(image!)!, language: .Automatic, detectOrientation: true)
        try! ocr.recognizeCharactersWithRequestObject(requestObject, completion: { (response) in
            let text = self.ocr.extractStringFromDictionary(response!)
            self.textView.text = text
            print(text)
            
        })

        
    }
    
    
  }

