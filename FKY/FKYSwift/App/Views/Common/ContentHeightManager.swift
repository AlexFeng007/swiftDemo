//
//  ContentHeightManager.swift
//  FKY
//
//  Created by 寒山 on 2019/12/12.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  各个列表行高管理器

import UIKit

@objc class ContentHeightManager: NSObject {
     var contentCellDic: Dictionary<String, CGFloat> = [:]
    
    @objc func getContentCellHeight(_ productId:String,_ sellerCode:String,_ pageCode:String) -> CGFloat {
        let heightTag = pageCode + sellerCode  + productId
        if contentCellDic.keys.contains(heightTag){
            return  contentCellDic[heightTag] ?? 0
        }
        return 0
    }
    
    @objc func addContentCellHeight(_ productId:String,_ sellerCode:String,_ pageCode:String,_ height:CGFloat){
        let heightTag = pageCode + sellerCode + productId
        if contentCellDic.keys.contains(heightTag){
            return
        }else{
            contentCellDic[heightTag] = height
        }
    }
    
    @objc func removeAllContentCellHeight(){
        contentCellDic.removeAll()
    }
}
