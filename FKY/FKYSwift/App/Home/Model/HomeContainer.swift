//
//  HomeContainer.swift
//  FKY
//
//  Created by Rabe on 07/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation

class HomeContainerModel: NSObject {
    public var itemList: NSArray?
    public var margin: HomeMarginModel? = nil
}

@objc
extension HomeContainerModel: HomeContainerProtocol {
    func numberOfChildModelsInContainer() -> Int {
        if let list = itemList {
            return list.count
        }
        return 0
    }
    
    func childFloorModel(atIndex index: Int) -> HomeModelInterface? {
        return nil
    }
}

@objc
extension HomeContainerModel: HomeModelInterface {
    func floorIdentifier() -> String {
        return "UITableViewCell"
    }
    
    func floorType() -> NSInteger {
        return 0
    }
}

@objc
extension HomeContainerModel: ShopListContainerProtocol {
    func numberOfChildModelsInShopListContainer() -> Int {
        if let list = itemList {
            return list.count
        }
        return 0
    }
    
    func childShopListFloorModel(atIndex index: Int) -> ShopListModelInterface? {
        return nil
    }
}

@objc
extension HomeContainerModel: ShopListModelInterface {
    func floorCellIdentifier() -> String {
        return "UITableViewCell"
    }
    
    func floorCellType() -> NSInteger {
        return 0
    }
}
