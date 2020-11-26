//
//  FKYTogeterHeaderView.swift
//  FKY
//
//  Created by hui on 2018/10/22.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

class FKYTogeterHeaderView: UIView {
    fileprivate lazy var oldBuyLabel : UILabel = {
        let label = UILabel()
        label.font = t14.font
        label.textColor = RGBColor(0xFFA8C2)
        label.text = "下期预告"
        return label
    }()
    
    fileprivate lazy var statusNextBuyLabel : UILabel = {
        let label = UILabel()
        label.font = t11.font
        label.textColor = RGBColor(0xFFA8C2)
        label.text = "即将开始"
        return label
    }()
    
    //查看下期认购
    fileprivate lazy var nextButton : UIButton = {
        let btn = UIButton()
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickIndexClosure {
                strongSelf.updateLabelColore(1)
                closure(1)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    fileprivate lazy var nowBuyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize:WH(18))
        label.textColor = t34.color
        label.text = "本期认购"
        return label
    }()
    
    fileprivate lazy var statusBuyLabel : UILabel = {
        let label = UILabel()
        label.font = t11.font
        label.textColor = t34.color
        label.text = "进行中"
        return label
    }()
    
    //查看本期认购
    fileprivate lazy var nowButton : UIButton = {
        let btn = UIButton()
        _=btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self]  (_) in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.clickIndexClosure {
                strongSelf.updateLabelColore(0)
                closure(0)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
   
    var clickIndexClosure: viewClosure?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        //下期预告
        self.addSubview(self.oldBuyLabel)
        self.oldBuyLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.centerX).offset(WH(19))
        }
        self.addSubview(self.statusNextBuyLabel)
        self.statusNextBuyLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.oldBuyLabel.snp.centerX)
            make.top.equalTo(self.oldBuyLabel.snp.bottom)
        }
        self.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.oldBuyLabel.snp.top)
            make.right.equalTo(self.oldBuyLabel.snp.right)
            make.left.equalTo(self.oldBuyLabel.snp.left)
            make.bottom.equalTo(self.statusNextBuyLabel.snp.bottom)
        }
        //本期认购
        self.addSubview(self.nowBuyLabel)
        self.nowBuyLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.centerY)
            make.right.equalTo(self.snp.centerX).offset(-WH(19))
        }
        self.addSubview(self.statusBuyLabel)
        self.statusBuyLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.nowBuyLabel.snp.centerX)
            make.top.equalTo(self.nowBuyLabel.snp.bottom)
        }
        self.addSubview(self.nowButton)
        self.nowButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.nowBuyLabel.snp.top)
            make.right.equalTo(self.nowBuyLabel.snp.right)
            make.left.equalTo(self.nowBuyLabel.snp.left)
            make.bottom.equalTo(self.statusBuyLabel.snp.bottom)
        }
        updateNumTitle(1)
    }
    //查看往期认购
    func clickOldBuyLabel(){
        if let closure = self.clickIndexClosure {
            self.updateLabelColore(1)
            closure(1)
        }
    }
    func updateLabelColore(_ index : Int) {
        if index == 0 {
            //本期
            self.nowBuyLabel.font = UIFont.boldSystemFont(ofSize:WH(18))
            self.nowBuyLabel.textColor = t34.color
            self.statusBuyLabel.textColor = t34.color
            
            self.oldBuyLabel.font = t14.font
            self.oldBuyLabel.textColor = RGBColor(0xFFA8C2)
            self.statusNextBuyLabel.textColor = RGBColor(0xFFA8C2)
        }else{
            //下期
            self.nowBuyLabel.font =  t14.font
            self.nowBuyLabel.textColor = RGBColor(0xFFA8C2)
            self.statusBuyLabel.textColor = RGBColor(0xFFA8C2)
            
            self.oldBuyLabel.font = UIFont.boldSystemFont(ofSize:WH(18))
            self.oldBuyLabel.textColor = t34.color
            self.statusNextBuyLabel.textColor = t34.color
        }
    }
    //更新title
    func updateNumTitle(_ numTotal:Int){
        if numTotal == 1{
            self.oldBuyLabel.isHidden = true
            self.statusNextBuyLabel.isHidden = true
            self.nextButton.isHidden = true
            self.nextButton.isUserInteractionEnabled = false
            self.nowBuyLabel.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self.snp.centerY)
                make.centerX.equalTo(self.snp.centerX)
            }
        }else{
            self.oldBuyLabel.isHidden = false
            self.statusNextBuyLabel.isHidden = false
            self.nextButton.isHidden = false
            self.nextButton.isUserInteractionEnabled = true
            self.nowBuyLabel.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self.snp.centerY)
                make.right.equalTo(self.snp.centerX).offset(-WH(19))
            }
        }
    }
   
}
