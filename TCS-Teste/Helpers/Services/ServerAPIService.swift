//
//  ServerAPIService.swift
//  TCS-Teste
//
//  Created by Matheus Coelho Espinasso on 26/08/18.
//  Copyright © 2018 Matheus Coelho Espinasso. All rights reserved.
//

import Foundation
import Alamofire

class ServerAPIService {
    let baseURL = "https://floating-mountain-50292.herokuapp.com/"
    let endpoint: URL?
    
    init(apiEndpoint: String) {
        endpoint = URL(string: "\(baseURL)\(apiEndpoint)")
    }
    //completion: @escaping (DictionaryInitialization?) -> Void
    func get(completion: @escaping ([String: Any]?) -> Void) {
        if let endpoint = self.endpoint {
            
            Alamofire.request(endpoint).responseJSON(completionHandler: {(response) in
                
                switch response.result {
                case .success:

                    if let jsonDictionary = response.result.value as? [String: Any] {
                        completion(jsonDictionary)
                    }
                    
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                }
            })
        }
    }
}
