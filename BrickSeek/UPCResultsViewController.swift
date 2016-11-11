//
//  UPCResultsViewController.swift
//  BrickSeek
//
//  Created by Dustin Allen on 10/28/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import SDWebImage

class UPCResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var zipField: UITextField!
    @IBOutlet var targetSKU: UILabel!
    @IBOutlet var walmartSKU: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let cellReuseIdentifier = "UPCCell"
    var locationNameArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.title = "Search"
        
        productImage.imageFromUrl(productImageURL)
        productName.text = productNameJSON
        targetSKU.text = targetSKUInfo
        walmartSKU.text = walmartSKUInfo
        
        tableView.reloadData()
        //print(storeInfo)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func zipGo(sender: AnyObject) {
        
        if zipField.text != "" {
            userZip = zipField.text! as String
            viewDidLoad()
            tableView.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UPCCell", forIndexPath: indexPath) as! UPCCell
        
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
        
        cell.productButton.sd_setImageWithURL(NSURL(string: (storeStuff["store_image"].string ?? "")), forState: .Normal)
        
        //cell.storeImage.imageView?.imageFromUrl("\(storeStuff["store_image"])")
        
        //cell.productButton.imageView?.imageFromUrl(storeStuff["store_image"].string ?? "")
        
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
