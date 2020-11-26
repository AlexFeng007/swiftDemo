//
//  FKYHomePageNaviPageControlView.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageNaviPageControlView: UIView {

    lazy var backView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xCCCCCC)
        return view
    }()
    
    lazy var indexView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFF2D5C)
        return view
    }()
    
    var backViewWidth = WH(24)
    var indexViewWidth = WH(14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK: - 数据展示
extension FKYHomePageNaviPageControlView{
    
    /*
    // 切换到index 第一页的index从1开始
    func swichToIndex(index:Int){
        if index == 1 {// 切换到第一页
            self.indexView.snp_remakeConstraints { (make) in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(WH(14))
            }
        }else if index == 2 {// 切换到第二页
            self.indexView.snp_remakeConstraints { (make) in
                make.top.right.bottom.equalToSuperview()
                make.width.equalTo(WH(14))
            }
        }
    }
    */
    
    /// 产品要求从翻页切换成顺滑
    func moveToPoint(point:CGFloat){
        var updataWidth = (backViewWidth-indexViewWidth) * point + indexViewWidth
        if updataWidth > backViewWidth {
            updataWidth = backViewWidth
        }
        
        if updataWidth <= 0 {
            updataWidth = 0
        }
        
        indexView.snp_updateConstraints { (make) in
            make.width.equalTo(updataWidth)
        }
    }
    
    /// 配置显示颜色样式
    /// - Parameter type: 1 有背景图  2无背景图
    func configDisplayType(type:Int){
        if type == 1 {
            indexView.backgroundColor = RGBColor(0xFFFFFF)
            backView.backgroundColor = RGBAColor(0xFFFFFF, alpha: 0.5)
        }else if type == 2{
            indexView.backgroundColor = RGBColor(0xFF2D5C)
            backView.backgroundColor = RGBAColor(0xCCCCCC, alpha: 1)
        }
    }
}

//MARK: - 私有方法
extension FKYHomePageNaviPageControlView{
    func getBackViewHeight() -> CGFloat {
        return WH(3)
    }
}

//MARK: - UI
extension FKYHomePageNaviPageControlView{
    func setupUI(){
        self.addSubview(self.backView)
        self.backgroundColor = .clear
        self.backView.addSubview(self.indexView)
        self.backView.layer.cornerRadius = self.getBackViewHeight()/2.0
        self.backView.layer.masksToBounds = true
        self.indexView.layer.cornerRadius = self.getBackViewHeight()/2.0
        self.indexView.layer.masksToBounds = true
        
        self.backView.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(backViewWidth)
            make.height.equalTo(self.getBackViewHeight())
            make.top.greaterThanOrEqualToSuperview().offset(0)
            make.bottom.lessThanOrEqualToSuperview().offset(0)
        }
        
        self.indexView.snp_makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(indexViewWidth)
        }
    }
}
