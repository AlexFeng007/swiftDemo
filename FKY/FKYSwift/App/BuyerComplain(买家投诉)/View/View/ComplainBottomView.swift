//
//  ComplainBottomView.swift
//  FKY
//
//  Created by 寒山 on 2019/1/8.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

typealias ComplainSubmitBlock = ()->()
class ComplainBottomView: UIView {
    
    var submitBlock: ComplainSubmitBlock?
    fileprivate lazy var  upView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        return lineView
    }()
    
    fileprivate lazy var  upLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = RGBColor(0xE5E5E5)
        return lineView
    }()
    
    fileprivate lazy var  downView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = RGBColor(0xf7f7f7)
        return lineView
    }()
    
    fileprivate lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("提交", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: WH(15))
        button.backgroundColor = RGBColor(0xFF2D5C)
        button.layer.cornerRadius = WH(4)
        _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            guard let block = strongSelf.submitBlock else {
                return
            }
            block()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return  button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        self.addSubview(upView)
        upView.addSubview(upLineView)
        self.addSubview(downView)
        downView.addSubview(submitButton)
        
        upView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(WH(82))
        }
        upLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(upView)
            make.height.equalTo(0.5)
            make.bottom.equalTo(upView)
        }
        downView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(upView.snp.bottom)
            make.height.equalTo(WH(63))
        }
        submitButton.snp.makeConstraints { (make) in
            make.left.equalTo(downView).offset(WH(30))
            make.right.equalTo(downView).offset(WH(-30))
            make.top.equalTo(downView.snp.top).offset(WH(12))
            make.height.equalTo(WH(44))
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
