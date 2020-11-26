//
//  FKYNewShopBottomView.swift
//  FKY
//
//  Created by hui on 2019/10/28.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

class FKYNewShopBottomView: UIView {
    
    fileprivate var iconPic = ["shop_message_pic","0","shop_contact_pic"]
    fileprivate var SeletIconPic = ["shop_message_selected_pic","0","shop_contact_pic"]
    fileprivate var titleNames = ["商家首页","全部商品","联系客服"]
    fileprivate var bgViewArr : [Any] = [] //存放背景view控件
    fileprivate var iconArr : [Any] = [] //存放图片控件或者label
    fileprivate var titleArr : [Any] = [] //存放titl空间label
    fileprivate var currentIndex = 0 //当前选中的序号(默认选择0)
    var clickViewBock : ((Int)->(Void))? //点击视图
    //当前选择第一个
    var selectIndex :Int {
        get{
           return currentIndex
        }
        set{
            self.resetIconView(newValue)
            self.currentIndex = newValue
        }
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = RGBColor(0xFFFFFF)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        let bgView_w = SCREEN_WIDTH/4.0
        self.iconArr.removeAll()
        self.titleArr.removeAll()
        self.bgViewArr.removeAll()
        for i in 0...(self.titleNames.count-1) {
            let bgViewOne = UIView()
            bgViewOne.isUserInteractionEnabled = true
            self.addSubview(bgViewOne)
            bgViewOne.snp.makeConstraints { (make) in
                make.width.equalTo(bgView_w)
                make.left.equalTo(self.snp.left).offset(CGFloat(i)*bgView_w+SCREEN_WIDTH/8.0)
                make.top.equalTo(self.snp.top)
                make.height.equalTo(WH(54))
            }
            bgViewOne.bk_(whenTapped: { [weak self] in
                if let strongSelf = self {
                    if let block = strongSelf.clickViewBock,strongSelf.selectIndex != i {
                        block(i)
                    }
                    if i != 2 {
                        strongSelf.selectIndex = i
                    }
                }
            })
            self.bgViewArr.append(bgViewOne)
            //icon图片标签和商品数量
            if i == 1 {
                let iconCountLabel = UILabel()
                iconCountLabel.textAlignment = .center
                iconCountLabel.font = UIFont.systemFont(ofSize: WH(17))
                iconCountLabel.textColor = RGBColor(0xaaaaaa)
                iconCountLabel.lineBreakMode = .byTruncatingTail
                var iconNameStr = ""
                if i < iconPic.count {
                    iconNameStr = iconPic[i]
                }
                iconCountLabel.text = iconNameStr
                bgViewOne.addSubview(iconCountLabel)
                iconCountLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(bgViewOne.snp.top).offset(WH(6))
                    make.centerX.equalTo(bgViewOne.snp.centerX)
                    make.left.equalTo(bgViewOne.snp.left).offset(WH(3))
                    make.right.equalTo(bgViewOne.snp.right).offset(-WH(3))
                }
                self.iconArr.append(iconCountLabel)
            }else {
                let iconImageView = UIImageView()
                var iconNameStr = ""
                if i < iconPic.count {
                    iconNameStr = (i == 0 ? SeletIconPic[i] : iconPic[i])
                }
                iconImageView.image = UIImage.init(named: iconNameStr)
                bgViewOne.addSubview(iconImageView)
                iconImageView.snp.makeConstraints { (make) in
                    make.top.equalTo(bgViewOne.snp.top).offset(WH(3))
                    make.centerX.equalTo(bgViewOne.snp.centerX)
                    make.height.equalTo(WH(30))
                    make.width.equalTo(WH(30))
                }
                self.iconArr.append(iconImageView)
            }
            
            //标题
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.font = t3.font
            titleLabel.textColor = (i == 0 ? t73.color : t3.color)
            var titleNameStr = ""
            if i < titleNames.count {
                titleNameStr = titleNames[i]
            }
            titleLabel.text = titleNameStr
            bgViewOne.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.bottom.equalTo(bgViewOne.snp.bottom).offset(-WH(8))
                make.centerX.equalTo(bgViewOne.snp.centerX)
                make.left.equalTo(bgViewOne.snp.left).offset(WH(3))
                make.right.equalTo(bgViewOne.snp.right).offset(-WH(3))
            }
            self.titleArr.append(titleLabel)
        }
    }
}
//MARK:更新视图
extension FKYNewShopBottomView {
    //刷新视图
   fileprivate func resetIconView (_ newIndex:Int){
        if self.currentIndex != newIndex {
            //标题
            if let currentLabel = titleArr[self.currentIndex] as? UILabel {
                currentLabel.textColor = t3.color
            }
            if let selectLabel = titleArr[newIndex] as? UILabel {
                //选中
                selectLabel.textColor = t73.color
            }
            //图标
            if let currentImageView = iconArr[self.currentIndex] as? UIImageView {
                currentImageView.image = UIImage.init(named: iconPic[self.currentIndex])
            }
            if let selectImageView = iconArr[newIndex] as? UIImageView {
                //选中
                selectImageView.image = UIImage.init(named: SeletIconPic[newIndex])
            }
            if let currentLabel = iconArr[self.currentIndex] as? UILabel {
                 currentLabel.textColor = RGBColor(0xaaaaaa)
            }
            if let selectLabel = iconArr[newIndex] as? UILabel {
                //选中
                selectLabel.textColor = t73.color
            }
            
        }
    }
    //设置全部商品数量
    func resetProductNum (_ productNum:Int) {
        if let currentLabel = iconArr[1] as? UILabel {
             currentLabel.text = "\(productNum)"
        }
    }
    
}
extension FKYNewShopBottomView {
    //店铺自营专区（底部样式设置）
    func resetBottomIconAndLabelView (){
        //专区信息
        if let currentbgView = bgViewArr[0] as? UIView {
            currentbgView.snp.updateConstraints { (make) in
                make.left.equalTo(self.snp.left).offset(SCREEN_WIDTH*3/16.0)
            }
        }
        if let currentLabel = titleArr[0] as? UILabel {
            currentLabel.text = "专区信息"
        }
        //全部商品
        if let currentbgView = bgViewArr[1] as? UIView {
            currentbgView.snp.updateConstraints { (make) in
                make.left.equalTo(self.snp.left).offset(SCREEN_WIDTH*9/16.0)
            }
        }
        //客服隐藏（隐藏）
        if let currentbgView = bgViewArr[2] as? UIView {
            currentbgView.isHidden = true
        }
    }
}
