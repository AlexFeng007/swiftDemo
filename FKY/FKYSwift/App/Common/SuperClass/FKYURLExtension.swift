//
//  FKYURLExtension.swift
//  FKY
//
//  Created by 油菜花 on 2020/9/22.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYURLExtension: NSObject {

}

extension URL {
    public var parametersFromQueryString : [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
