//
//  AddCartViewModel.swift
//  FKY
//
//  Created by Rabe on 22/02/2018.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

class AddCartViewModel {
    typealias AddCartViewModelCallback = (_ shouldToast: Bool, _ msg: String)->()
    
    // MARK: - properties
    var nowCount: Int = 1
    var baseCount: Int = 1
    var stepCount: Int = 1
    var stockCount: Int = 0
    fileprivate var unit: String = "件"
    
    var minusValid: Bool {
        get {
            return self.nowCount > self.baseCount && self.nowCount > self.stepCount
        }
    }
    var plusValid: Bool {
        get {
            return self.nowCount < self.stockCount
        }
    }
    
    
    // MARK: - life cycle
    convenience init(_ baseCount: Int, stepCount: Int, stockCount: Int, unit: String) {
        self.init()
        self.baseCount = baseCount
        self.stepCount = stepCount
        self.stockCount = stockCount
        self.unit = unit
        if nowCount < baseCount {
            nowCount = baseCount
        }
        if (nowCount % stepCount) != 0 {
            nowCount = nowCount - (nowCount % stepCount) + stepCount
        }
        if nowCount > stockCount {
            nowCount = stockCount - (stockCount % stepCount)
        }
    }
}

// MARK: - public
extension AddCartViewModel {
    func minusLogic() -> (outputValue: String, toastMessage: String?) {
        nowCount = nowCount - stepCount
        return updateInputValue(nowCount)
    }
    
    func plusLogic() -> (outputValue: String, toastMessage: String?) {
        nowCount = nowCount + stepCount
        return updateInputValue(nowCount)
    }
    
    func updateInputValue(_ inputValue: Int) -> (outputValue: String, toastMessage: String?) {
        nowCount = inputValue
        var message: String? = nil
        // 过小
        if nowCount < baseCount {
            nowCount = baseCount
            message = "最小拆零包装为\(stepCount)\(unit)"
        }
        // 整数倍
        if (nowCount % stepCount) != 0 {
            nowCount = nowCount - (nowCount % stepCount) + stepCount
        }
        // 过大
        if nowCount > stockCount {
            nowCount = stockCount - (stockCount % stepCount)
            message = "最多只能买\(nowCount)\(unit)!"
        }
        return ("\(nowCount)", message)
    }
    
    func shouldInputValueChangeCharacters(_ inputValue: String) -> (outputValue: String?, shouldChangeValue: Bool, shouldResignKeyboard: Bool, toastMessage: String?) {
        let string = inputValue as NSString
        nowCount = string.integerValue
        
        if nowCount < baseCount {
            nowCount = baseCount
        }
        
        if (nowCount % stepCount) != 0 {
            nowCount = nowCount - (nowCount % stepCount) + stepCount
        }
        
        if string.integerValue == 0 {
            nowCount = 0
        }

        if nowCount > stockCount {
            let toastMessage = "最多只能买\(stockCount)\(unit)!"
            return ("\(stockCount)", false, true, toastMessage)
        }
        return (nil, true, false, nil)
    }
}

// MARK: - delegates
extension AddCartViewModel {
    
}

// MARK: - action
extension AddCartViewModel {
    
}

// MARK: - data
extension AddCartViewModel {
    
}

// MARK: - ui
extension AddCartViewModel {
    
}

// MARK: - private methods
extension AddCartViewModel {

}
