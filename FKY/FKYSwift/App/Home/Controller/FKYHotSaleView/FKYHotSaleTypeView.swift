//
//  FKYHotSaleTypeView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/11.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)热销商品之类型选择视图

import UIKit

class FKYHotSaleTypeView: UIView {
    // MARK: - Property
    
    // closure
    var changeTypeCallback: ((Int, Any?)->())? // 切换类型
    
    // 热销类型选择器
    fileprivate var segmentedControl: HMSegmentedControl?
//    fileprivate lazy var segmentedControl: HMSegmentedControl! = {
//        // 先使用占位数组进行初始化
//        let segment = HMSegmentedControl.init(sectionTitles: ["--", "--", "--", "--"])
//        // 设置背景色
//        segment?.backgroundColor = UIColor.clear
//        // 设置滚动条高度
//        segment?.selectionIndicatorHeight = WH(3)
//        // 设置滚动条颜色
//        segment?.selectionIndicatorColor = RGBColor(0xFF2D5C)
//        // 设置滚动条样式
//        segment?.selectionStyle = HMSegmentedControlSelectionStyle.textWidthStripe
//        // 设置滚动条位置
//        segment?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
//        // 设置每个分段项左右间距
//        segment?.segmentEdgeInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
//        // 设置底部分段指示器左右间距
//        segment?.selectionIndicatorEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 30)
//        // 各项宽度不固定，根据文字长度来动态设置
//        segment?.segmentWidthStyle = HMSegmentedControlSegmentWidthStyle.dynamic
//        // 设置未选中的字体大小和颜色
//        segment?.titleTextAttributes = [NSForegroundColorAttributeName:RGBColor(0x333333), NSFontAttributeName:UIFont.systemFont(ofSize: WH(15))]
//        // 设置选中的字体大小和颜色
//        segment?.selectedTitleTextAttributes = [NSForegroundColorAttributeName:RGBColor(0xFF2D5C), NSFontAttributeName:UIFont.boldSystemFont(ofSize: WH(15))]
//        // 设置分段选中索引
//        segment?.setSelectedSegmentIndex(0, animated: true)
//        // 切换类型
//        segment?.indexChangeBlock = { [weak self] (index: Int) -> () in
//            if let closure = self?.changeTypeCallback {
//                closure(index, nil)
//            }
//        }
//        return segment
//    }()
    
    // 类型数据源
    var typeDataSource = [String]()
    
    // 判断是否需要重置HMSegmentedControl的标题
    fileprivate var needNewSegmentedTitles: Bool {
        get {
            guard segmentedControl != nil else {
                return true
            }
            // 当前标题数组
            let typeListCurrent = segmentedControl?.sectionTitles
            if typeListCurrent?.count == 0 {
                // 未设置标题数组（不可能出现此种情况）
                if typeDataSource.count == 0 {
                    // 无类型数据源
                    return false
                }
                else {
                    // 有类型数据源
                    return true
                }
            }
            else {
                // 已设置标题数组
                if typeDataSource.count == 0 {
                    // 无类型数据源
                    return false
                }
                else {
                    // 有类型数据源
                    guard typeDataSource.count == typeListCurrent?.count else {
                        return true
                    }

                    var needReset = false
                    for index in 0 ..< typeDataSource.count {
                        let title = typeDataSource[index]
                        let titleBk = typeListCurrent![index]
                        if title != titleBk {
                            needReset = true
                            break
                        }
                    } // for
                    return needReset
                }
            }

            // 默认不需要重置
            //return false
        }
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        backgroundColor = UIColor.white
        
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
        
//        addSubview(segmentedControl)
//        segmentedControl.snp.makeConstraints { (make) in
//            make.edges.equalTo(self)
//        }
    }
    
    
    // MARK: - Public
    
    func configData(_ list: [String], _ index: Int) {
        guard list.count > 0 else {
            typeDataSource.removeAll()
            if segmentedControl != nil {
                segmentedControl?.removeFromSuperview()
                segmentedControl = nil
            }
            return
        }
        
        // 保存
        typeDataSource = list
        
        if segmentedControl == nil {
            // 为空
            self.segmentedControl = createNewSegmentControl()
            addSubview(segmentedControl!)
            segmentedControl?.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
        }
        else {
            // 不为空
            if needNewSegmentedTitles {
                // 先清空
                segmentedControl?.removeFromSuperview()
                segmentedControl = nil
                // 创始
                self.segmentedControl = createNewSegmentControl()
                addSubview(segmentedControl!)
                segmentedControl?.snp.makeConstraints { (make) in
                    make.edges.equalTo(self)
                }
            }
        }
        segmentedControl?.setSelectedSegmentIndex(UInt(index >= list.count ? 0 : index), animated: false)
        
//        // 需要重置标题
//        if needNewSegmentedTitles {
//            segmentedControl.sectionTitles = list
//        }
//
//        // 设置
//        segmentedControl.isHidden = false
//        //segmentedControl.sectionTitles = typeDataSource
//        segmentedControl.setSelectedSegmentIndex(UInt(index >= list.count ? 0 : index), animated: false)
    }
    
    func updateTypeIndex(_ index: Int) {
        guard index < typeDataSource.count else {
            return
        }
        
        guard segmentedControl != nil else {
            self.segmentedControl = createNewSegmentControl()
            addSubview(segmentedControl!)
            segmentedControl?.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
            segmentedControl?.setSelectedSegmentIndex(UInt(index), animated: true)
            return
        }
        
        segmentedControl?.setSelectedSegmentIndex(UInt(index), animated: true)
    }
    
    
    // MARK: - Private
    
    fileprivate func createNewSegmentControl() -> HMSegmentedControl? {
        // 先使用占位数组进行初始化
        let segment = HMSegmentedControl.init(sectionTitles: typeDataSource)
        // 设置背景色
        segment?.backgroundColor = UIColor.clear
        // 设置滚动条高度
        segment?.selectionIndicatorHeight = WH(3)
        // 设置滚动条颜色
        segment?.selectionIndicatorColor = RGBColor(0xFF2D5C)
        // 设置滚动条样式
        segment?.selectionStyle = HMSegmentedControlSelectionStyle.textWidthStripe
        // 设置滚动条位置
        segment?.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        // 设置每个分段项左右间距
        segment?.segmentEdgeInset = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 12)
        // 设置底部分段指示器左右间距
        segment?.selectionIndicatorEdgeInsets = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 24)
        // 各项宽度不固定，根据文字长度来动态设置
        segment?.segmentWidthStyle = HMSegmentedControlSegmentWidthStyle.dynamic
        // 设置未选中的字体大小和颜色
        segment?.titleTextAttributes = [NSForegroundColorAttributeName:RGBColor(0x333333), NSFontAttributeName:UIFont.systemFont(ofSize: WH(15))]
        // 设置选中的字体大小和颜色
        segment?.selectedTitleTextAttributes = [NSForegroundColorAttributeName:RGBColor(0xFF2D5C), NSFontAttributeName:UIFont.boldSystemFont(ofSize: WH(15))]
        // 设置分段选中索引
        segment?.setSelectedSegmentIndex(0, animated: true)
        // 切换类型
        segment?.indexChangeBlock = { [weak self] (index: Int) -> () in
            if let closure = self?.changeTypeCallback {
                closure(index, nil)
            }
        }
        return segment
    }
}
