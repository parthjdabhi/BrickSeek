//
//  WalmartAPICall.swift
//  BrickSeek
//
//  Created by Dustin Allen on 11/2/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WalmartAPICall {
    
    static let walmartAPICall = WalmartAPICall()
    
    static func upcSearch(upc: String) {
        
        let storeType = "&store_type=3"
        let upcSearchAPI = "\(upcAPI)\(upc)\(storeType)&zip=\(userZip)&key=\(apiKey)"
        
        Alamofire.request(.GET, upcSearchAPI)
            .responseJSON { response in
                
                let json = JSON(response.result.value!)
                print(json)
                
                productImageURL = "\(json["product_info"]["image"])"
                productNameJSON = "\(json["product_info"]["name"])"
                msrpInfo = "\(json["product_info"]["msrp"])"
                discountInfo = "\(json["product_info"]["discount_percent"])"
                availableInfo = "\(json["product_info"]["avail_percent"])"
                
                availableStoreForProduct = json["stores"].arrayValue
                print(availableStoreForProduct)
        }
    }
}
