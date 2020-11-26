//
//  FKYRecognizeSimultaneousTab.swift
//  FKY
//
//  Created by hui on 2018/12/12.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYRecognizeSimultaneousTab: UITableView,UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
