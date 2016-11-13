//
//  CreatePostViewController.swift
//  YHackProject
//
//  Created by techbar on 11/11/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import UIKit
import FBSDKShareKit
import Social
import Clarifai
//import VisualRecognitionV3
//import AlchemyLanguageV1

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var compNameLabel: UILabel!
    
    var app = ClarifaiApp(appID: "fcaFjE7XHAw9p9YazdAXiVBp_Dqqv4RnJtm17_PN", appSecret: "N4LQsO8NloJ9_xo2JfiVDbFwTbUMPOtzTZBg2tGs")
    
    var company: Company?
    
    @IBOutlet weak var takePicButton: UIButton!
    var controller: UIAlertController?
    
    var chosenImage: UIImage?
    var compName: String?
    
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        compNameLabel.text = compName
        
        textField.isUserInteractionEnabled = true
        textField.isEditable = true

        // Do any additional setup after loading the view.
        controller = UIAlertController(
            title: "Choose a photo for your post",
            message: "",
            preferredStyle: .actionSheet)
        let actionEmail = UIAlertAction(title: "Take Photo",
                                        style: UIAlertActionStyle.default,
                                        handler: {(paramAction:UIAlertAction!) in
                                            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                                                self.picker.allowsEditing = false
                                                self.picker.sourceType = UIImagePickerControllerSourceType.camera
                                                self.picker.cameraCaptureMode = .photo
                                                self.present(self.picker, animated: true, completion: nil)
                                            } else {
                                                self.noCamera()
                                            }
        })
        
        let actionImessage = UIAlertAction(title: "Choose from Library",
                                           style: UIAlertActionStyle.default,
                                           handler: {(paramAction:UIAlertAction!) in
                                            self.picker.allowsEditing = false
                                            self.picker.sourceType = .photoLibrary
                                            self.picker.modalPresentationStyle = .popover
                                            self.present(self.picker, animated: true, completion: nil)
        })
        
        let actionDelete = UIAlertAction(title: "Cancel",
                                         style: UIAlertActionStyle.destructive,
                                         handler: {(paramAction:UIAlertAction!) in
        })
        controller!.addAction(actionEmail)
        controller!.addAction(actionImessage)
        controller!.addAction(actionDelete)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        takePicButton.setImage(nil, for: UIControlState.normal)
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoView.contentMode = .scaleAspectFit
        photoView.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onTap(_ sender: Any) {
        self.view.endEditing(true)
        textField.resignFirstResponder()
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        self.present(controller!, animated: true, completion: nil)
        /*if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }*/
    }
    
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,
                              animated: true,
                              completion: nil)
    }

    
    @IBAction func shareFB(_ sender: Any) {
        UIPasteboard.general.string = "Thanks to \(compName!) for turning this picture into a donation!" + textField.text
        var photo = FBSDKSharePhoto()
        photo.image = chosenImage
        photo.isUserGenerated = true
        
        var content = FBSDKSharePhotoContent()
        content.photos = [photo]
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
        
        
        
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
//            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            fbShare.add(chosenImage)
//            fbShare.setInitialText("hi")
//            self.present(fbShare, animated: true, completion: nil)
//            
//        }

    }
    
    
       
    @IBAction func tweet(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            print("hi1")
            tweetShare.add(chosenImage)
            print("hi2")
            tweetShare.setInitialText("Thanks to \(compName!) for turning this picture into a donation!" + textField.text)
            print("hi3")
            self.present(tweetShare, animated: true, completion: nil)
            print("hi4")
            
        }
        
    }
    
    
    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "done", sender: nil)
        
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! PostPostViewController
        destinationVC.image = photoView.image
        destinationVC.caption = textField.text
        destinationVC.companyName = compName!


        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    /*
    func createModel() {
        var image = ClarifaiImage(url: "https://peopledotcom.files.wordpress.com/2016/08/forever-21-435-1.jpg", andConcepts: ["clothes"])
        var image2 = ClarifaiImage(url: "http://i.dailymail.co.uk/i/pix/2013/05/03/article-0-16728070000005DC-579_307x456.jpg", andConcepts: ["clothes"])
        var image3 = ClarifaiImage(url: "http://s12.favim.com/610/160217/boots-brandy-brandymelville-clothes-Favim.com-4009347.jpg", andConcepts: ["clothes"])
        
        var inputs = [image!, image2!, image3!]
        app?.add(inputs, completion: { (inputs, Error) in
            print("inputs: \(inputs)")
        })

        app?.createModel(["clothes"], name: "clothes", modelID: "clothes", conceptsMutuallyExclusive: false, closedEnvironment: false, completion: nil)


    }
    func verifyImage() {
        var image: ClarifaiImage!
        model.predict(
        
    }
    */
    
   
}
