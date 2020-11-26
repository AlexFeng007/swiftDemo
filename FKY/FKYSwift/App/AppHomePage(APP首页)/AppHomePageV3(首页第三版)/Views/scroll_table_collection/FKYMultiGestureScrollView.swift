//
//  FKYMultiGestureScrollView.swift
//  FKY
//
//  Created by 油菜花 on 2020/11/16.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYMultiGestureScrollView: UIScrollView,UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
