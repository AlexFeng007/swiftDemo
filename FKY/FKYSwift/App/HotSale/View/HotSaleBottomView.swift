//
//
//  GLTemplate
//
//  Created by Rabe on 17/12/15.
//  Copyright © 2017年 岗岭集团. All rights reserved.
//

import UIKit

protocol HotSaleBottomViewOperation {
    func bottomView(_ view: HotSaleBottomView, didTapButtonWith type: HotSaleType)
}

class HotSaleBottomView: UIView {
    // MARK: - properties
    var operation: HotSaleBottomViewOperation?
    
    fileprivate var curSelectType: HotSaleType?
    fileprivate lazy var weekButton: UIButton! = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        button.setTitle("本周热销", for: .normal)
        button.backgroundColor = RGBColor(0xff2d5c)
        button.setTitleColor(RGBColor(0xffffff), for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            guard self?.curSelectType != .week else {return}
            self?.curSelectType = .week
            self?.updateButtonStyle()
            self?.operation?.bottomView(self!, didTapButtonWith: .week)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    fileprivate lazy var localButton: UIButton! = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: WH(16))
        button.setTitle("区域热销", for: .normal)
        button.backgroundColor = RGBColor(0xffffff)
        button.setTitleColor(RGBColor(0xff2d5c), for: .normal)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](_) in
            guard self?.curSelectType != .local else {return}
            self?.curSelectType = .local
            self?.updateButtonStyle()
            self?.operation?.bottomView(self!, didTapButtonWith: .local)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return button
    }()
    
    // MARK: - life cycle
    convenience init(withSelectType type: HotSaleType) {
        self.init(frame: .zero)
        
        curSelectType = type
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowColor = RGBColor(0x000000).cgColor
        layer.shadowOpacity = 0.1;//阴影透明度，默认0
        layer.shadowRadius = 6;//阴影半径，默认3
        
        addSubview(weekButton)
        addSubview(localButton)
        updateButtonStyle()
        
        weekButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
            make.right.equalTo(snp.centerX)
        }
        
        localButton.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.left.equalTo(snp.centerX)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - delegates
extension HotSaleBottomView {
    
}

// MARK: - action
extension HotSaleBottomView {
    
}

// MARK: - private methods
extension HotSaleBottomView {
    fileprivate func updateButtonStyle() {
        if curSelectType == .week {
            weekButton.backgroundColor = RGBColor(0xff2d5c)
            weekButton.setTitleColor(RGBColor(0xffffff), for: .normal)
            localButton.backgroundColor = RGBColor(0xffffff)
            localButton.setTitleColor(RGBColor(0xff2d5c), for: .normal)
        } else {
            localButton.backgroundColor = RGBColor(0xff2d5c)
            localButton.setTitleColor(RGBColor(0xffffff), for: .normal)
            weekButton.backgroundColor = RGBColor(0xffffff)
            weekButton.setTitleColor(RGBColor(0xff2d5c), for: .normal)
        }
        
    }
}
