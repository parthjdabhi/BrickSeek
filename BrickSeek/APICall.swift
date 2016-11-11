//
//  APICall.swift
//  BrickSeek
//
//  Created by Dustin Allen on 11/2/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var productImageURL = ""
var productNameJSON = ""
var walmartSKUInfo = ""
var targetSKUInfo = ""
var storeStreet = ""
var availableStoreForProduct:[JSON] = []

//struct StoreInfo {
//    let storeAddress : String
//}

//var storeInformation = [StoreInfo]()

class APICall {
    
    static let apiCall = APICall()
    
    static func upcSearch(upc: String) {
        
        let upcSearchAPI = "\(upcAPI)\(upc)&zip=\(userZip)&key=\(apiKey)"
        
        Alamofire.request(.GET, upcSearchAPI)
            .responseJSON { response in
                
                let json = JSON(response.result.value!)
                print(json)
                
                productImageURL = "\(json["product_info"]["image"])"
                productNameJSON = "\(json["product_info"]["name"])"
                targetSKUInfo = "Target: \(json["store_matches"][0]["sku"])"
                walmartSKUInfo = "Walmart: \(json["store_matches"][1]["sku"])"
                
                availableStoreForProduct = json["stores"].arrayValue
                //                for x in storeArray {
                //                    let storeAddressInfo = x["store_address"].stringValue
                //                    let theStores = StoreInfo(storeAddress: storeAddressInfo)
                //                    storeInformation.append(theStores)
                //                    print(storeInformation)
                //                }
        }
    }
}
