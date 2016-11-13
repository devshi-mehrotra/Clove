//
//  Company.swift
//  YHackProject
//
//  Created by techbar on 11/11/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import UIKit
import MapKit
import Parse

class Company: NSObject {
    
    var name: String! = ""
    var address: String? = ""
    var coordinate: CLLocationCoordinate2D!
    var image: PFFile? = nil
    var numDonations: Int = 0
    
    class func postCompany(name: String, address: String, description: String, image: UIImage) {
        
    }
    
    /*init(myName: String, myAddress: String, myCoordinate: CLLocationCoordinate2D)  {
        
        
        self.name = myName
        self.address = myAddress
        self.coordinate = myCoordinate
    }
 */
    override init() {
        
    }
    
    
    class func PFObjectToCompany() -> [Company]{
        
        let query = PFQuery(className: "Company")
        var compArray = [Company]()
        
        
        query.findObjectsInBackground { (company: [PFObject]?, error: Error?) -> Void in
            if let company = company {
                for c in company {
                    var co = Company()
                    let name = (c["name"] as! String)
                    co.name = name
                    let coor = CLLocationCoordinate2DMake(c["lat"] as! CLLocationDegrees, c["long"] as! CLLocationDegrees)
                    co.coordinate = coor
                    co.image = (c["media"] as! PFFile)
                    compArray.append(co)
                    //print(co.name)
                    //print(co.coordinate)
                }
            } else {
                print(error?.localizedDescription)
            }
            
        }
        print("COMPLETION!!!!!!!!!!!!!!!!!!!")
        return compArray
    }
    
       
    
    
    
}
