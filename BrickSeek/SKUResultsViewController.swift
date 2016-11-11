//
//  SKUResultsViewController.swift
//  BrickSeek
//
//  Created by Dustin Allen on 11/2/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit

class SKUResultsViewController: UIViewController {
    
    @IBOutlet var productName: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var msrpField: UILabel!
    @IBOutlet var discountedField: UILabel!
    @IBOutlet var stockField: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var zipField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.title = "Search"
        
        productImage.imageFromUrl(productImageURL)
        productName.text = productNameJSON
        msrpField.text = "MSRP: $\(msrpInfo)"
        discountedField.text = "\(discountInfo)%"
        stockField.text = "\(availableInfo)%"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func zipGo(sender: AnyObject) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SKUCell", forIndexPath: indexPath) as! SKUCell
        
        let storeStuff = availableStoreForProduct[indexPath.row]
        print(storeStuff)
        
        //cell = locationNameArray[indexPath.row] as! UPCCell
        //cell.addressField.text = storeAddresses[indexPath.row]
        
        //cell.stockInfo.text = storeStuff["stock"].string ?? "-"
        if let stock = storeStuff["stock"].int {
            //stock
            if stock >= 1 {
                cell.stockInfo.text = "In Stock"
                cell.stockInfo.textColor = UIColor.greenColor()
            } else {
                cell.stockInfo.text = "Out Of Stock"
                cell.stockInfo.textColor = UIColor.redColor()
            }
        } else {
            cell.stockInfo.text = "-"
            cell.stockInfo.textColor = UIColor.grayColor()
        }
        
        cell.qtyInfo.text = (storeStuff["stock"].int != nil) ? "\(storeStuff["stock"].int!)" : ""
        cell.priceInfo.text = "$" + (storeStuff["price"].string ?? "")
        cell.addressField.text = storeStuff["store_name"].string ?? "-"
        cell.cityField.text = storeStuff["store_address"].string ?? ""
        cell.telephoneField.text = storeStuff["store_phone"].string ?? "-"
        
        cell.productButton.imageView?.imageFromUrl(storeStuff["store_image"].string ?? "")
        
        return cell
        
        /*
         "stores" : [
         {
         "store_image" : "http:\/\/brickseek.com\/img\/walmart_logo.png",
         "store_name" : "Walmart",
         "quan1" : "-1",
         "stock" : 2,
         "store_address" : "700 Keeaumoku St<br>Honolulu HI 96814",
         "price" : "136.0",
         "quan" : "9",
         "store_id" : "3478",
         "aisle" : "N.A.",
         "store_phone" : "808-955-8441",
         "distance" : "1.73",
         "department" : "N.A.",
         "store_type" : 3
         },
         */
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableStoreForProduct.count
    }
    
}
