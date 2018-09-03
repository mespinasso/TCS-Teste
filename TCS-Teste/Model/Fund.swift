//
//  Fund.swift
//  TCS-Teste
//
//  Created by Matheus Coelho Espinasso on 02/09/18.
//  Copyright © 2018 Matheus Coelho Espinasso. All rights reserved.
//

import Foundation

class Fund {
    let fundName: String
    let definition: String
    let risk: Int
    let info: [FundInfo]
    let downInfo: [FundInfo]
    
    required init(dictionary: [String : Any]) {
        fundName = dictionary[FieldKeys.fundName] as! String
        definition = dictionary[FieldKeys.definition] as! String
        risk = dictionary[FieldKeys.risk] as! Int
        
        let infoDictionary = dictionary[FieldKeys.info] as! [[String : Any]]
        info = FundInfo.getFundInfoList(from: infoDictionary)

        let downInfoDictionary = dictionary[FieldKeys.downInfo] as! [[String : Any]]
        downInfo = FundInfo.getFundInfoList(from: downInfoDictionary)
    }

    // JSON field names
    struct FieldKeys {
        static let fundName = "fundName"
        static let definition = "definition"
        static let risk = "risk"
        static let info = "info"
        static let downInfo = "downInfo"
    }
}

enum FundInfoSection: String {
    case general = "Geral", info = "Informações", downInfo = "Extras"
}

// Server API fetching
extension Fund {
    
    static let apiEndpoint = "fund.json"
    
    static func fetchFromServer(completion: @escaping (Fund?) -> Void) {
        let service = ServerAPIService(apiEndpoint: apiEndpoint)
        service.get { (jsonDictionary) in
            
            if let jsonDictionary = jsonDictionary {
                if let fundDic = jsonDictionary["screen"] as? [String : Any] {
                    let fund = Fund(dictionary: fundDic)
                    completion(fund)
                }
            }
        }
    }
}
