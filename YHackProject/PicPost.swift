//
//  PicPost.swift
//  YHackProject
//
//  Created by techbar on 11/12/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import Parse
import UIKit

class PicPost: PFObject {
    
    class func postUserImage(image: UIImage?, withCaption caption: String?, companyName: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["image"] = getPFFileFromImage(image: image) // PFFile column type
        post["author"] = PFUser.current() // Pointer column type that points to PFUser
        post["caption"] = caption
        post["company"] = companyName
        
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
        print("completed")
        
        
        
        var numPosts = PFUser.current()?["numPosts"] as? Int
        
        PFUser.current()?.setObject(numPosts! + 1, forKey: "numPosts")
        PFUser.current()?.saveInBackground(block: { (succes: Bool, error: Error?) in
            if error == nil {
              print("success")
                
            } else {
                print("error: \(error?.localizedDescription)")
            }
        }
    )
    }
    
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                print("RETURNED")
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }



}
