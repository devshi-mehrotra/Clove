//
//  AddCompanyViewController.swift
//  YHackProject
//
//  Created by techbar on 11/12/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import UIKit
import Parse


class AddCompanyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let imagePicker = UIImagePickerController()
    
    var chosenImage: UIImage!
    

    @IBOutlet weak var longField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddCompany(_ sender: Any) {
        let company = PFObject(className: "Company")
        
        // Add relevant fields to the object
        company["media"] = Post.getPFFileFromImage(image: photoView.image) // PFFile column type
        company["name"] = nameField.text // Pointer column type that points to PFUser
        company["lat"] = Double(latField.text!)
        company["long"] = Double(longField.text!)

        company["numDonations"] = 0
        
        
        // Save object (following function will save the object in Parse asynchronously)
        company.saveInBackground(block: nil)
    }

    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
   

    @IBAction func onAddPic(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("hi")
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoView.contentMode = .scaleAspectFit
        photoView.image = chosenImage
        dismiss(animated: true, completion: nil)
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
