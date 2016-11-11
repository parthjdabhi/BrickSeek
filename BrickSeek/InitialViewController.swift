//
//  InitialViewController.swift
//  BrickSeek
//
//  Created by Dustin Allen on 10/27/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

var userZip = ""

class InitialViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var upcField: UITextField!
    @IBOutlet var brickSeekResponse: UITextView!
    
    let locationManager = CLLocationManager()
    var userLat = 0.0
    var userLong = 0.0
    //var userZip = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let urlPath: String = "\(messageAPI)"
        let url: NSURL = NSURL(string: urlPath)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("ASynchronous\(jsonResult)")
                    dispatch_async(dispatch_get_main_queue()){
                        self.brickSeekResponse.text = String(jsonResult)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }

    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            print(locationManager.location)
            if locationManager.location != nil {
                userLat = locationManager.location!.coordinate.latitude
                userLong = locationManager.location!.coordinate.longitude
                print(userLat)
                print(userLong)
            } else {
                print("Location Not Available")
            }
        } else {
            print("Not Authorized")
        }
        reverseGeoCode()
    }
    
    // If needed to make nav bar reappear
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func targetButton(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("TargetCheckerViewController") as! TargetCheckerViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func walmartButton(sender: AnyObject) {
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("WalmartCheckerViewController") as! WalmartCheckerViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func termsConditions(sender: AnyObject) {
        
    }
    
    @IBAction func gettingStarted(sender: AnyObject) {
        
    }
    
    @IBAction func scanButton(sender: AnyObject) {
        let upc = upcField.text! as String
        
        if upc == "" {
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController!
            self.navigationController?.pushViewController(next, animated: true)
        } else {
            CommonUtils.sharedUtils.showProgress(self.view, label: "Searching...")
            APICall.upcSearch(upc)
            searchingTimer()
        }
    }
    
    
    func locationManger(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let userLocation:CLLocation = locations[0] as! CLLocation
        let long = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude
        print(lat)
        print(long)
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
                userZip = zip as String
                print(userZip)
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
            }
            
        })
    }
    
    func searchingTimer() {
        _ = NSTimer.scheduledTimerWithTimeInterval(7.0, target: self, selector: #selector(InitialViewController.segueInformation), userInfo: nil, repeats: false)
    }
    
    func segueInformation() {
        CommonUtils.sharedUtils.hideProgress()
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("UPCResultsViewController") as! UPCResultsViewController!
        self.navigationController?.pushViewController(next, animated: true)
    }
}
