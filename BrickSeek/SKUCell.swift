//
//  SKUCell.swift
//  BrickSeek
//
//  Created by Dustin Allen on 11/10/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation

class SKUCell: UITableViewCell {
    
    @IBOutlet var stockInfo: UILabel!
    @IBOutlet var qtyInfo: UILabel!
    @IBOutlet var priceInfo: UILabel!
    @IBOutlet var addressField: UILabel!
    @IBOutlet var cityField: UILabel!
    @IBOutlet var telephoneField: UILabel!
    @IBOutlet var productButton: UIButton!
    
    var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}