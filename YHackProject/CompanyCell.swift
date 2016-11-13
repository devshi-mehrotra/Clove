//
//  CompanyCell.swift
//  YHackProject
//
//  Created by techbar on 11/12/16.
//  Copyright © 2016 yhack. All rights reserved.
//

import UIKit
import ParseUI

class CompanyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numDonationsLabel: UILabel!
    
    @IBOutlet weak var photoImageView: PFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
