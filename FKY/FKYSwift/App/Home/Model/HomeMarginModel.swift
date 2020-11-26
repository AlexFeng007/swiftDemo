//
//  HomeMarginModel.swift
//  FKY
//
//  Created by Rabe on 07/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation

class HomeMarginModel: NSObject {
    public var height: CGFloat = WH(10)
}

extension HomeMarginModel: HomeModelInterface {
    func floorIdentifier() -> String {
        return "HomeTemplateMarginCell"
    }
}

extension HomeMarginModel: ShopListModelInterface {
    func floorCellIdentifier() -> String {
        return "HomeTemplateMarginCell"
    }
}
