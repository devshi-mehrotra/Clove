//
//  ProfileViewController.swift
//  YHackProject
//
//  Created by techbar on 11/11/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numPosts: UILabel!
    
    
    var myCell: photoCell?
    
    var user = PFUser.current()
    var myposts: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user?.username)
        nameLabel.text = user?["name"] as! String?
        photoView.file = user?["profPic"] as! PFFile?
        photoView.loadInBackground()
        let num = user?["numPosts"] as! Int
        numPosts.text = "Number of posts: " + String(num)
        collectionView.dataSource = self
        self.collectionView.alwaysBounceVertical = true
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 1, 0, 1);
        layout.minimumInteritemSpacing = 0 // this number could be anything <=5. Need it here because the default is 10.
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width-3)/3, height: (self.collectionView.frame.size.width-3)/3)
        
        let refreshControl = UIRefreshControl()
        refreshControlAction()
        refreshControl.addTarget(self, action: "refreshControlAction", for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        
        print("viewdidload")


        // Do any additional setup after loading the view.
    }

    func refreshControlAction() {
        // Do any additional setup after loading the view.
        let query = PFQuery(className: "Post")
        //query.limit = 20
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.includeKey("_created_at")
        
        //print("CHECKING USER:" + user!.username!)
        
        if user == nil {
            user = PFUser.current()!
        }
        
        print("CHECKING USER:" + user!.username!)
        
        query.whereKey("author", equalTo: self.user!)
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.myposts = posts
                //self.posts = tempposts
                // do something with the array of object returned by the call
                //print("YAY")
                for post in posts {
                    print(post["caption"])
                }
            } else {
                print(error?.localizedDescription)
            }
            
            //self.userLabel.text = String(self.user!.username!)
            
            self.collectionView.reloadData()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionview")
        if let myposts = myposts {
            //numberPostsLabel.text = "Number of Posts: " + String(myposts.count)
            print(myposts.count)
            return myposts.count
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("2collectionview")

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! photoCell
        myCell = cell
   
        let post = self.myposts![indexPath.row]
        
        if post["image"] != nil {
            let tempimage = post["image"] as! PFFile
            tempimage.getDataInBackground
                {
                    (imageData: Data?, error: Error?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)!
                            cell.photoImageView.contentMode = UIViewContentMode.scaleAspectFit
                            cell.photoImageView.image = image
                        }
                    }
            }
            
        }
        
        return cell
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
