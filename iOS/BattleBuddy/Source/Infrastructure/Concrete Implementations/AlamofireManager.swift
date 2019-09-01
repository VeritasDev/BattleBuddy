//
//  AlamofireManager.swift
//  BattleBuddy
//
//  Created by Mike on 6/2/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireManager: HttpRequestor {

    func sendGetRequest(url: String, headers: [String: String] = [:], completion: @escaping (_ : [String: Any]?) -> Void) {
        Alamofire.request(url, headers: headers).responseJSON(queue: .global()) { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? [String: Any] {
                    print("Request succeeded with json response: \(json)")
                    completion(json)
                } else {
                    print("Request succeeded, but response contained no valid json.")
                    completion(nil)

                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                completion(nil)
            }
        }
    }
}
