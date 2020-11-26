//
//  FKYBasePopUpView.swift
//  FKY
//
//  Created by 寒山 on 2018/6/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

public class FKYBasePopUpView: UIView {
    var sourceFrame: CGRect?  /* tapBar的frame**/
    var shadowView: UIView?  /* 遮罩层**/
    var isShowIng: Bool?  /* 判断是否在展示**/
    var mainTableView: UITableView?
    var mainCollectView: UICollectionView?
    var subTableView: UITableView?
    var selectedArray: Array<Any>?  /* 记录所选的item**/
    var temporaryArray: Array<Any>?   /* 暂存最初的状态**/
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
