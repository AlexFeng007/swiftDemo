//
//  SearchSuggestModel.swift
//  FKY
//
//  Created by 夏志勇 on 2019/7/16.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  搜索之推荐词model

import Foundation
import SwiftyJSON

final class SearchSuggestModel: NSObject, JSONAbleType {
    let nature: String?
    let word: String?
    
    init(nature: String?, word: String?) {
        self.nature = nature
        self.word = word
    }
    
    static func fromJSON(_ json: [String : AnyObject]) -> SearchSuggestModel {
        let j = JSON(json)
        let nature = j["nature"].string
        let word = j["word"].string
        
        return SearchSuggestModel(nature: nature, word: word)
    }
}
