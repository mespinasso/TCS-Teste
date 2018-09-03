//
//  FundInfo.swift
//  TCS-Teste
//
//  Created by Matheus Coelho Espinasso on 02/09/18.
//  Copyright © 2018 Matheus Coelho Espinasso. All rights reserved.
//

import Foundation

class FundInfo {
    let name: String
    let data: String
    
    required init(dictionary: [String : Any]) {
        name = dictionary[FieldKeys.name] as! String
        
        if let data = dictionary[FieldKeys.data] as? String {
            self.data = data
        } else {
            self.data = "-"
        }
    }
    
    // JSON field names
    struct FieldKeys {
        static let name = "name"
        static let data = "data"
    }
}

extension FundInfo {
    
    static func getFundInfoList(from dictionary: [[String : Any]]) -> [FundInfo] {
        var fundInfoList: [FundInfo] = []
        
        for entry in dictionary {
            let fundInfo = FundInfo(dictionary: entry)
            fundInfoList.append(fundInfo)
        }
        
        return fundInfoList
    }
}
