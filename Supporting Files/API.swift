//
//  API.swift
//  OpenApp
//
//  Created by Kobaissy on 4/25/20.
//  Copyright © 2020 IDS Mac. All rights reserved.
//

import Foundation
import CoreData

let api = API()

class API {
    
    
    // MARK: - Section
    func GetCategory(completionHandler: @escaping (_ returnedData: [Category])-> Void ){
        let urlString = Webservice.get_category.value
        print("GetCategory urlString : " , urlString)
        
        if let url = URL(string: urlString){
            let urlRequest = URLRequest(url: url , cachePolicy: ((NetworkReachabilityManager()!.isReachable) ? .reloadIgnoringCacheData : .returnCacheDataElseLoad))
            Alamofire.request(urlRequest).responseCategories { response in
                if let data = response.result.value {
                    print("GetCategory result count:",data.count)
                    completionHandler(data)
                }
                else {
                    print("GetCategory error:",response.result.error?.localizedDescription ?? "nil")
                    completionHandler([])
                }
                //    switch response.result {
                //    case .success:
                //        let result = JSON(response.result.value!)
                //        print("GetAllSection result count:",result.count)
                //
                //        var data = [CategoryItem]()
                //        if result.count > 0 {
                //            for i in 0..<result.count{
                //                let item = CategoryItem(id: result[i]["id"].intValue ,
                //                                        title: result[i]["title"].stringValue.withoutHtmlTag ,
                //                                        image: "")
                //                data.append(item)
                //            }
                //        }
                //        completionHandler(data)
                //
                //    case .failure(let error):
                //        print("GetAllSection error:",error.localizedDescription)
                //        completionHandler([])
                //    }
            }
        }
    }

}
