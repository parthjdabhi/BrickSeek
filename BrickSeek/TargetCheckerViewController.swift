//
//  TargetCheckerViewController.swift
//  BrickSeek
//
//  Created by Dustin Allen on 11/2/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import CoreLocation

class TargetCheckerViewController: UIViewController {

    @IBOutlet var zipField: UITextField!
    @IBOutlet var skuField: UITextField!
    @IBOutlet var upcField: UITextField!
    
    let locationManager = CLLocationManager()
    var userLat = 0.0
    var userLong = 0.0
    var userZip = ""
    var storeType = "&store_type=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false
        self.title = "Target Inventory Checker"
    }
    
    override func viewDidAppear(animated: Bool) {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            print(locationManager.location)
            if locationManager.location != nil {
                userLat = locationManager.location!.coordinate.latitude
                userLong = locationManager.location!.coordinate.longitude
                print(userLat)
                print(userLong)
                zipFindTimer()
            } else {
                print("Location Not Available")
            }
        } else {
            print("Not Authorized")
        }
        reverseGeoCode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        let upc = upcField.text as String!
        let sku = skuField.text as String!
        
        if userZip == "" {
            userZip = zipField.text!
        }
        
        if zipField.text == "" {
            let alert = UIAlertController(title: "Sorry!", message: "Please Enter Your Zip Code To Proceed", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        
        if upcField.text == "" && skuField.text == "" {
            let alert = UIAlertController(title: "Sorry!", message: "Please Enter Either A UPC or SKU To Proceed", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        
        if upcField.text != "" && skuField.text == "" {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Searching...")
            TargetAPICall.upcSearch(upc)
            searchingTimer()
        }
        
        if skuField.text != "" && upcField.text == "" {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Searching...")
            TargetSKUCall.upcSearch(sku)
            searchingTimer()
        }
    }
    
    @IBAction func scanUPC(sender: AnyObject) {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("TargetScannerViewController") as! TargetScannerViewController!
            self.navigationController?.pushViewController(next, animated: true)
    }
    
    func reverseGeoCode() {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: userLat, longitude: userLong)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary)
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                self.userZip = zip as String
                print(self.userZip)
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
            }
            
        })
    }
    
    func zipFindTimer() {
        let zipTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(WalmartCheckerViewController.zipTextFunc), userInfo: nil, repeats: false)
        print(zipTimer)
    }
    
    func zipTextFunc() {
        zipField.text = userZip as String
    }
    
    func searchingTimer() {
        _ = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(InitialViewController.segueInformation), userInfo: nil, repeats: false)
    }
    
    func segueInformation() {
        CommonUtils.sharedUtils.hideProgress()
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("SKUResultsViewController") as! SKUResultsViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
}
