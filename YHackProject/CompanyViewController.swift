//
//  CompanyViewController.swift
//  YHackProject
//
//  Created by techbar on 11/12/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import UIKit
import Parse

class CompanyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var user = PFUser.current()
    var myComp: [Company] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControlAction()
        refreshControl.addTarget(self, action: "refreshControlAction", for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction() {
        // Do any additional setup after loading the view.
        let query = PFQuery(className: "Company")
        //query.limit = 20
        query.order(byDescending: "name")
        query.includeKey("name")
        query.includeKey("media")
        query.includeKey("numDonations")
        
        //print("CHECKING USER:" + user!.username!)
        
        if user == nil {
            user = PFUser.current()!
        }
        
        print("CHECKING USER:" + user!.username!)
        
        query.findObjectsInBackground { (company: [PFObject]?, error: Error?) -> Void in
            if let company = company {
                for c in company {
                    var co = Company()
                    let name = (c["name"] as! String)
                    co.name = name
                    let coor = CLLocationCoordinate2DMake(c["lat"] as! CLLocationDegrees, c["long"] as! CLLocationDegrees)
                    co.coordinate = coor
                    let numDonations = c["numDonations"] as! Int
                    co.numDonations = numDonations
                    co.image = (c["media"] as! PFFile)
                    self.myComp.append(co)
                    //print(co.name)
                    //print(co.coordinate)
                }
            } else {
                print(error?.localizedDescription)
            }
            
            self.tableView.reloadData()
            
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myComp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyCell", for: indexPath) as! CompanyCell
        let company = myComp[indexPath.row]
        cell.nameLabel.text = company.name
        cell.numDonationsLabel.text = String(company.numDonations as! Int)
        cell.photoImageView.file = company.image
        cell.photoImageView.loadInBackground()
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
