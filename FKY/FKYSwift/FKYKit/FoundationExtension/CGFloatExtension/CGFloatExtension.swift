//
//  CGFloatExtension.swift
//  FKY
//
//  Created by Rabe on 16/01/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import Foundation



extension CGFloat {
    func multiple(_ number: Int) -> CGFloat {
        guard number != 0 else {
            return CGFloat.init(0)
        }
        var ret = CGFloat.init(0)
        for _ in 1...number {
            ret += self
        }
        return ret
    }
}
