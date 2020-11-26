//
//  PDGroupTitleView.swift
//  FKY
//
//  Created by 夏志勇 on 2017/12/19.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  商详(搭配 or 固定)套餐之顶部标题视图...<套餐切换>

import UIKit


typealias changePDGroupIndexClousre = (_ groupIndex: Int)->()

class PDGroupTitleView: UIView {
    // 下划线
    fileprivate lazy var viewLine: UIView! = {
        let viewWhite = UIView()
        viewWhite.backgroundColor = RGBColor(0xE5E5E5)
        return viewWhite
    }()
    
    // 标题lbl...<当只有一个套餐时显示>
    fileprivate lazy var lblTitle: UILabel! = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: WH(15))
        lbl.textColor = RGBColor(0xFF2D5C)
        lbl.textAlignment = .center
        lbl.text = nil
        return lbl
    }()
    
    // 套餐标题
    fileprivate var segmentedControl: HMSegmentedControl!
    
    // block
    var changeIndexCallback: changePDGroupIndexClousre?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupView
    func setupView() {
        // 下划线
        self.addSubview(self.viewLine)
        self.viewLine.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        // 标题
        self.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            //make.center.equalTo(self)
            make.edges.equalTo(UIEdgeInsets(top: WH(5), left: WH(10), bottom: WH(5), right: WH(10)))
        }
        self.lblTitle.isHidden = true
    
        // 先不绘制SegmentedControl
    }
    
    // MARK: - public
    func showSegmentedControl4GroupTitle(_ arrayTitles: NSArray?) {
        if self.segmentedControl != nil {
            self.segmentedControl.removeFromSuperview()
            self.segmentedControl = nil
        }
        
        if let arr = arrayTitles, arr.count > 0 {
            // 有套餐
            self.segmentedControl = HMSegmentedControl.init(sectionTitles: arr as! [String])
            // 设置背景色
            self.segmentedControl.backgroundColor = UIColor.clear
            //_segmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            // 设置滚动条高度
            self.segmentedControl.selectionIndicatorHeight = WH(1)
            // 设置滚动条颜色
            self.segmentedControl.selectionIndicatorColor = RGBColor(0xFF2D5C)
            // 设置滚动条样式
            self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyle.textWidthStripe
            // 设置滚动条位置
            self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
            // 设置每个分段项左右间距
            self.segmentedControl.segmentEdgeInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
            // 设置底部分段指示器左右间距
            self.segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 20)
            // 各项宽度不固定，根据文字长度来动态设置
            self.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyle.dynamic
            // 设置未选中的字体大小和颜色
            self.segmentedControl.titleTextAttributes = [NSAttributedString.Key.foregroundColor:RGBColor(0x333333), NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(15))]
            // 设置选中的字体大小和颜色
            self.segmentedControl.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor:RGBColor(0xFF2D5C), NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(15))]
            // 设置分段选中索引
            self.segmentedControl.setSelectedSegmentIndex(0, animated: true)
            // 设置分段类型切换时触发的操作
            self.segmentedControl.indexChangeBlock = { [unowned self] (index: Int) -> Void in
                if self.changeIndexCallback != nil {
                    self.changeIndexCallback!(index)
                }
            }
            self.addSubview(self.segmentedControl)
            self.segmentedControl.snp.makeConstraints({ (make) in
                //make.left.equalTo(self.lblTitle.snp.right).offset(WH(10))
                make.left.equalTo(self).offset(WH(0))
                make.right.equalTo(self).offset(WH(0))
                make.top.bottom.equalTo(self)
            })
            
            if arr.count == 1 {
                // 只有一个套餐时，不显示分段控件，只显示单独的一个标题
                self.segmentedControl.isHidden = true
                self.lblTitle.isHidden = false
                self.lblTitle.text = arr.firstObject as? String
            }
            else {
                // 多套餐时，不显示标题，只显示分段控件
                self.segmentedControl.isHidden = false
                self.lblTitle.isHidden = true
            }
        }
        else {
            // 无套餐
            self.segmentedControl = nil
        }
    }
    
    func setSegmentedControlIndex(_ groupIndex: Int) {
        self.segmentedControl.setSelectedSegmentIndex(UInt(groupIndex), animated: true)
    }
    
    func configView() {
        //
    }
}
