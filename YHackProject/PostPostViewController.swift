//
//  PostPostViewController.swift
//  YHackProject
//
//  Created by techbar on 11/11/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import UIKit

class PostPostViewController: UIViewController {

    var image: UIImage?
    var caption: String = ""
    var companyName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PicPost.postUserImage(image: image, withCaption: caption, companyName: companyName, withCompletion: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
