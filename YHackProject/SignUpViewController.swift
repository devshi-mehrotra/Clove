//
//  SignUpViewController.swift
//  YHackProject
//
//  Created by techbar on 11/11/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var photoView: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    
    var chosenImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = UIImage(named: "noprofile")

        imagePicker.delegate = self
        
        
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        print("hi")
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoView.contentMode = .scaleAspectFit
        photoView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func choosePic(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        

    }
   
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        // set user properties
        newUser.username = emailField.text
        newUser.password = passwordField.text
        
        let img = photoView.image
        
        
        
        let imageData = getPFFileFromImage(img)
        
        newUser["name"] = nameField.text
        newUser["profPic"] = imageData
        newUser["numPosts"] = 0
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) -> Void in
            if let error = error {
                print(error.localizedDescription)
                if error != nil {
                    print(error.localizedDescription)
                }
            } else {
                print("User Registered successfully")
                self.performSegue(withIdentifier: "signupSegue1", sender: nil)
                
                // manually segue to logged in view
                
            }
        }

    }
    
    func getPFFileFromImage(_ image: UIImage?) -> PFFile? {
        if let image = image {
            if let imageData = UIImagePNGRepresentation(image){
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
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
