//
//  FKYTimerManager.swift
//  FKY
//
//  Created by yyc on 2020/8/11.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYTimerManager: NSObject {
    @objc var allTimer : Timer?
    var allCount : Int64 = 0
    
    static let timerManagerShared = FKYTimerManager()
    func allTimerStart() {
        self.stopTimer()
        self.allCount = 0
        // 启动timer...<1.s后启动>
        let date = NSDate.init(timeIntervalSinceNow: 1.0)
        allTimer = Timer.init(fireAt: date as Date, interval: 1, target: self, selector: #selector(calculateCount), userInfo: nil, repeats: true)
        RunLoop.current.add(allTimer!, forMode: RunLoop.Mode.common)
    }
    
    @objc fileprivate func calculateCount() {
        self.allCount = self.allCount+1
    }
    
    func stopTimer()  {
        if allTimer != nil {
            allTimer?.invalidate()
            allTimer = nil
            self.allCount = 0
        }
    }
    
}
