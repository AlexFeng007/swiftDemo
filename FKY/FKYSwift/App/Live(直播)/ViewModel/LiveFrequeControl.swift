//
//  LiveFrequeControl.swift
//  FKY
//
//  Created by yyc on 2020/8/19.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

//控制星星动画的频率
class LiveFrequeControl: NSObject {
    static let shareLiveControl = LiveFrequeControl()
    var countsLimit = 0
    var secondsLimit = 0.0
    var curCounts = 0
    var preTime = 0.0
    func resetCountsAndSeconds(_ counts:Int, _ seconds:Double){
        countsLimit = counts
        secondsLimit = seconds
        curCounts = 0
        preTime = 0.0
    }
    
    func canTrigger() -> Bool {
        let nowTime = NSDate().timeIntervalSince1970
        if preTime == 0 || nowTime - preTime > secondsLimit {
            preTime = nowTime
            curCounts = 0
        }
        if curCounts >= countsLimit {
            return false
        }
        curCounts += 1
        return true
    }

}
