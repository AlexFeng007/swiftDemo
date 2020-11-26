//
//  RITypeSelectView.swift
//  FKY
//
//  Created by 夏志勇 on 2019/8/9.
//  Copyright © 2019 yiyaowang. All rights reserved.
//  [资料管理]图片上传界面之企业类型选择视图...<吸顶>

import UIKit

class RITypeSelectView: UIView {
    // MARK: - Property
    
    // closure
    var changeTypeCallback: ((Int, Any?)->())? // 切换类型
    
    // 当前选中的索引项
    fileprivate var indexSelected = 0
    
    // 背景视图
    fileprivate lazy var viewBg: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    // 上分隔线
    fileprivate lazy var viewLineTop: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    // 下分隔线
    fileprivate lazy var viewLineBottom: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    /******************************************/
    // 0方案
    
    // 底部指示器
    fileprivate lazy var viewSelect: UIView = {
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = RGBColor(0xFF2D5C)
        return view
    }()
    
    // 标题数组
    fileprivate var titleList = [String]()
    // btn数组...<1~4>
    fileprivate var btnList = [UIButton]()
    // 标题宽度...<当前逻辑为每个标题宽度相同，取各标题宽度最大者>
    fileprivate var widthTitle = WH(80)
    // 标题间距...<各标题间距相等>
    fileprivate var marginTitle = WH(20)
    // 第0个标题与屏幕左侧间距
    fileprivate var offsetX: CGFloat {
        get {
            let count = titleList.count
            if count == 1 {
                return 0
            }
            else if count == 2 {
                return WH(30)
            }
            else if count == 3 {
                return WH(20)
            }
            else if count == 4 {
                return WH(10)
            }
            else {
                return 0
            }
        }
    }
    
    /******************************************/
    // 1方案
    
    // 类型选择器...<左右边界最小间距15， item间最小间距30>
    fileprivate lazy var segmentedControl: HMSegmentedControl = {
        // 先使用占位数组进行初始化
        let segment = HMSegmentedControl()
        // 设置背景色
        segment.backgroundColor = UIColor.clear
        // 设置滚动条高度
        segment.selectionIndicatorHeight = 1
        // 设置滚动条颜色
        segment.selectionIndicatorColor = RGBColor(0xFF2D5C)
        // 设置滚动条样式
        segment.selectionStyle = HMSegmentedControlSelectionStyle.textWidthStripe
        // 设置滚动条位置
        segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        // 设置每个分段项左右间距
        segment.segmentEdgeInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        // 设置底部分段指示器左右间距
        segment.selectionIndicatorEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 30)
        // 各项宽度不固定，根据文字长度来动态设置
        segment.segmentWidthStyle = HMSegmentedControlSegmentWidthStyle.dynamic
        // 设置未选中的字体大小和颜色
        segment.titleTextAttributes = [NSAttributedString.Key.foregroundColor:RGBColor(0x333333), NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(15))]
        // 设置选中的字体大小和颜色
        segment.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor:RGBColor(0xFF2D5C), NSAttributedString.Key.font:UIFont.systemFont(ofSize: WH(15))]
        // 设置分段选中索引
        segment.setSelectedSegmentIndex(0, animated: true)
        // 切换类型
        segment.indexChangeBlock = { [weak self] (index: Int) -> () in
            guard let strongSelf = self else {
                return
            }
            if let closure = strongSelf.changeTypeCallback {
                closure(index, nil)
            }
        }
        // 返回
        return segment
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        //backgroundColor = .white
        backgroundColor = .clear
        
        // 最下层的背景视图
        addSubview(viewBg)
        viewBg.snp.makeConstraints { (make) in
            make.left.bottom.top.equalTo(self)
            make.right.equalTo(self).offset(-6)
        }
        
        // 上分隔线
        addSubview(viewLineTop)
        viewLineTop.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        // 下分隔线
        addSubview(viewLineBottom)
        viewLineBottom.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}


// MARK: - 自定义

extension RITypeSelectView {
    // 使用自定义的btns...<1~4>
    func configViewWithTitles(_ list: [String]) {
        guard list.count > 0, list.count <= 4 else {
            return
        }
        
        // 保存
        titleList = list
        
        // 标题个数
        let count = list.count
        widthTitle = getMaxTitleWidth(list)
        marginTitle = (SCREEN_WIDTH - widthTitle * CGFloat(count) - offsetX * 2) / CGFloat(count + 1)
        
        for index in 0..<count {
            //
            let title = list[index]
            //
            let btn = UIButton.init(type: .custom)
            btn.tag = index
            btn.backgroundColor = .clear
            btn.setTitleColor(RGBColor(0x333333), for: .normal)
            btn.setTitleColor(RGBColor(0x000000), for: [.normal, .highlighted])
            btn.setTitleColor(RGBColor(0xFF2D5C), for: .selected)
            btn.setTitleColor(RGBColor(0xFF2D5C), for: [.selected, .highlighted])
            btn.titleLabel?.font = UIFont.systemFont(ofSize: WH(15))
            btn.setTitle(title, for: .normal)
            btn.titleLabel!.lineBreakMode = .byTruncatingTail
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self ,weak btn] (_) in
                guard let strongSelf = self else {
                    return
                }
                guard let strongBtn = btn else {
                    return
                }
                
                guard strongBtn.isSelected == false else {
                    return
                }
                strongSelf.showSelected(strongBtn.tag)
                if let block = strongSelf.changeTypeCallback {
                    block(strongBtn.tag, nil)
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(self).offset(getSelectPosition(index))
                make.height.equalTo(WH(32))
                make.width.equalTo(widthTitle)
            }
            if index == 0 {
                btn.isSelected = true
            }
            //
            btnList.append(btn)
        }
        
        addSubview(viewSelect)
        viewSelect.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(getSelectPosition(0))
            make.bottom.equalTo(self).offset(-1.5)
            make.height.equalTo(1)
            make.width.equalTo(widthTitle)
        }
    }
    
    // 标题项选择
    func showSelected(_ index: Int) {
        guard btnList.count > index else {
            return
        }
        
        guard btnList[index].isSelected == false else {
            return
        }
        
        // 保存
        indexSelected = index
        
        UIView.animate(withDuration: 0.12, animations: { [weak self] in
            if let strongSelf = self {
                strongSelf.viewSelect.snp.updateConstraints { (make) in
                    make.left.equalTo(strongSelf).offset(strongSelf.getSelectPosition(index))
                }
                strongSelf.layoutIfNeeded()
            }
            
        }) { (finish) in
            //
        }
        
        for btn in btnList {
            btn.isSelected = false
        }
        let btnNow = btnList[index]
        btnNow.isSelected = true
    }
    
    // 根据主界面collectview滑动状态来确定当前最终选中的企业类型索引...[>=iOS9]
    func updateSelected(_ sectionList: [IndexPath], _ cellList: [IndexPath]) {
        if sectionList.count == 1 {
            // 仅有一个section-header显示
            let ip: IndexPath = sectionList.first!
            if ip.section == 0 || ip.section == 1 {
                showSelected(0)
            }
            else {
                showSelected(ip.section - 1)
            }
        }
        else if sectionList.count == 0 {
            // 无section-header显示
            guard cellList.count > 0 else {
                return
            }
            // 若当前屏幕上无section-header显示，则说明当前屏幕上布满同一个section的cell
            let ip: IndexPath = cellList.first!
            if ip.section == 0 || ip.section == 1 {
                showSelected(0)
            }
            else {
                showSelected(ip.section - 1)
            }
        }
        else {
            // 有多个section-header显示
            var indexFinal = indexSelected
            for ip in sectionList {
                guard ip.section > 0 else {
                    continue
                }
                let section = ip.section - 1
                if section >= indexFinal {
                    indexFinal = section
                }
            }
            // 更新
            showSelected(indexFinal)
        }
    }
    
    // 根据主界面collectview滑动状态来确定当前最终选中的企业类型索引...[<iOS9]
    func updateSelectedType(_ cellList: [IndexPath]) {
        var maxSection = 0
        for ip: IndexPath in cellList {
            guard ip.section > 0 else {
                continue
            }
            let section = ip.section - 1
            if section >= maxSection {
                maxSection = section
            }
        }
        // 更新
        showSelected(maxSection)
    }
    
    // 计算各标题的最大宽度
    fileprivate func getMaxTitleWidth(_ list: [String]) -> CGFloat {
        guard list.count > 0 else {
            return 0
        }
        
        // 最小宽度
        var value: CGFloat = WH(70)
        for txt in list {
            // 计算txt宽度
            let width = COProductItemCell.calculateStringWidth(txt, UIFont.systemFont(ofSize: WH(15)), WH(30)) + WH(5)
            if width >= value {
                value = width
            }
        }
        // 最大值
        let max = (SCREEN_WIDTH - WH(10) * CGFloat(list.count + 1) - offsetX * 2) / CGFloat(list.count)
        if value >= max {
            value = max
        }
        
        return value
    }
    
    //
    fileprivate func getSelectPosition(_ index: Int) -> CGFloat {
        return offsetX + marginTitle + (widthTitle + marginTitle) * CGFloat(index)
    }
}


// MARK: - HMSegmentedControl

extension RITypeSelectView {
    // 使用HMSegmentedControl...<动态>
    func configView(_ list: [String]) {
        guard list.count > 0 else {
            return
        }
        
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0)))
        }
        
        // 动态设置btn个数
        segmentedControl.sectionTitles = list
        segmentedControl.selectedSegmentIndex = 0
        // 动态更新展示配置
        let itemCount = list.count // 标题项个数
        let allWidth = getAllTextWidth(list) // 所有标题项中文字的总长度
        let marginWidth: CGFloat = WH(30) * CGFloat(itemCount - 1) + WH(15) * 2 // 所有(最小)间距总宽度
        if SCREEN_WIDTH - allWidth > marginWidth {
            // 需额外处理
            let allValue: CGFloat = SCREEN_WIDTH - allWidth // 剩余间距总宽度
            let allCount: Int = (itemCount - 1) * 2 + 2 // 最小间距项个数...<以左右边界间距为单位，标题项之间的间距为左右边界间距的两倍>
            let value: CGFloat = allValue / CGFloat(allCount) // 单个最小间距宽度
            // 设置每个分段项左右间距
            segmentedControl.segmentEdgeInset = UIEdgeInsets.init(top: 0, left: value, bottom: 0, right: value)
            // 设置底部分段指示器左右间距
            segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets.init(top: 0, left: value, bottom: 0, right: value * 2)
        }
        else {
            // 不需额外处理...<由控件内部自适应>
        }
    }
    
    // 计算所有文字总宽度
    fileprivate func getAllTextWidth(_ list: [String]) -> CGFloat {
        guard list.count > 0 else {
            return 0
        }
        
        var value: CGFloat = 0
        for txt in list {
            // 计算txt宽度
            let width = COProductItemCell.calculateStringWidth(txt, UIFont.systemFont(ofSize: WH(15)), WH(30))
            value += (width + 2)
        }
        return value
    }
}
