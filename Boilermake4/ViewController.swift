//
//  ViewController.swift
//  Boilermake4
//
//  Created by Deetpanshu Malik on 1/20/17.
//  Copyright © 2017 Boilermake4_Deeptanshu_Jake_Mason_Ryuji. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

  @IBOutlet weak var photoImage: UIImageView!
  
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
  
  
  //MARK: Actions
  
  @IBAction func loadImageFromPhotoLibrary(_ sender: UIButton) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.delegate = self
    
    present(imagePickerController, animated: true, completion: nil)

    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])




}

