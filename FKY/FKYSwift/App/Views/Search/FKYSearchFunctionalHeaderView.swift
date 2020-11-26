//
//  FKYSearchFunctionalHeaderView.swift
//  FKY
//
//  Created by airWen on 2017/5/3.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

enum ImagesWithTextAlignment {
    case none
    case vertical_textUp_imageDown
    case vertical_textDown_imageUp
    case horizontal_textRigt_imageLeft
    case horizontal_textLeft_imageRight
    case horizontal_textLeft_imageRight_shop
}

enum ItemViewSelectState {
    case ItemViewSelectStateNormal
    case ItemViewSelectStateSelected
    case ItemViewSelectStateNone
}

class FKYSearchFunctionalItemView: UIView {
    
    fileprivate lazy var contentView: UIView =  {
        let contentView = UIView()
        contentView.backgroundColor = RGBColor(0xF4F4F4)
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.cornerRadius = 4
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.fontTuple = t7
        label.textAlignment = .center
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var imageView: UIImageView =  {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.clear
        imageV.translatesAutoresizingMaskIntoConstraints = false
        //        imageV.contentMode = UIViewContentMode.ScaleAspectFit
        return imageV
    }()
    
    fileprivate lazy var controlMask: UIControl =  {
        let control = UIControl()
        control.backgroundColor=UIColor.clear
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    internal var didSelectItem: ((_ item: FKYSearchFunctionalItemView)->())? //选择分类
    var canMultiSelected: Bool = false
    
    init?(title:String?, imageName:String?, contentAlignment:ImagesWithTextAlignment, canMultiSelected: Bool,hasContentBg: Bool) {
        super.init(frame: CGRect.zero)
        
        self.canMultiSelected = canMultiSelected
        
        addSubview(contentView);
        contentView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self)
        })
        if hasContentBg == false {
            self.setContentViewState(.ItemViewSelectStateNone)
        }
        if nil != title &&  nil == imageName {
            titleLabel.text = title
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self)
                make.top.left.greaterThanOrEqualTo(self).offset(2)
                make.right.bottom.greaterThanOrEqualTo(self).offset(-2)
            })
        }else if nil == title &&  nil != imageName {
            let imgIcon: UIImage? = UIImage(named: imageName!)
            if nil == imgIcon {
                return nil
            }else {
                imageView.image = imgIcon
                addSubview(imageView)
                imageView.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(self)
                    make.centerY.equalTo(self)
                    make.top.left.greaterThanOrEqualTo(self).offset(2)
                    make.right.bottom.greaterThanOrEqualTo(self).offset(-2)
                })
            }
        }else if nil != title &&  nil != imageName {
            let imgIcon: UIImage? = UIImage(named: imageName!)
            titleLabel.text = title
            addSubview(titleLabel)
            if nil == imgIcon {
                titleLabel.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(self)
                    make.centerY.equalTo(self)
                    make.top.left.greaterThanOrEqualTo(self).offset(2)
                    make.right.bottom.greaterThanOrEqualTo(self).offset(-2)
                })
            }else{
                imageView.image = imgIcon
                addSubview(imageView)
                
                switch contentAlignment {
                case .vertical_textUp_imageDown:
                    titleLabel.snp.makeConstraints({ (make) in
                        make.centerX.equalTo(self)
                        make.top.left.greaterThanOrEqualTo(self).offset(2)
                        make.right.greaterThanOrEqualTo(self).offset(-2)
                        make.bottom.equalTo(self.snp.centerY).offset(-1)
                    })
                    imageView.snp.makeConstraints({ (make) in
                        make.centerX.equalTo(self)
                        make.top.equalTo(self.snp.centerY).offset(1)
                    })
                    break
                case .vertical_textDown_imageUp:
                    titleLabel.snp.makeConstraints({ (make) in
                        make.centerX.equalTo(self)
                        make.left.greaterThanOrEqualTo(self).offset(2)
                        make.right.bottom.greaterThanOrEqualTo(self).offset(-2)
                        make.top.equalTo(self.snp.centerY).offset(1)
                    })
                    imageView.snp.makeConstraints({ (make) in
                        make.centerX.equalTo(self)
                        make.bottom.equalTo(self.snp.centerY).offset(-1)
                    })
                    break
                case .horizontal_textRigt_imageLeft:
                    titleLabel.snp.makeConstraints({ (make) in
                        make.centerX.equalTo(self).offset((imgIcon?.size.width)!/2.0)
                        make.centerY.equalTo(self)
                    })
                    imageView.snp.makeConstraints({ (make) in
                        make.centerY.equalTo(self)
                        make.right.equalTo(titleLabel.snp.left).offset(WH(-5))
                    })
                    break
                case .horizontal_textLeft_imageRight:
                    titleLabel.snp.makeConstraints({ (make) in
                        make.centerX.equalTo(self).offset(-(imgIcon?.size.width)!/2.0)
                        make.centerY.equalTo(self)
                    })
                    imageView.snp.makeConstraints({ (make) in
                        make.centerY.equalTo(self)
                        make.left.equalTo(titleLabel.snp.right).offset(1)
                    })
                    break
                case .horizontal_textLeft_imageRight_shop:
                    titleLabel.textAlignment = .center
                    titleLabel.snp.makeConstraints({ (make) in
                        //make.centerX.equalTo(self).offset(-(imgIcon?.size.width)!/2.0)
                        make.centerY.equalTo(self)
                        make.right.equalTo(self).offset(-((imgIcon?.size.width)! + WH(10)))
                        make.left.equalTo(self).offset(1)
                    })
                    imageView.snp.makeConstraints({ (make) in
                        make.centerY.equalTo(self)
                        make.left.equalTo(titleLabel.snp.right)
                    })
                    break
                case .none:
                    fallthrough
                default:
                    titleLabel.snp.makeConstraints({ (make) in
                        make.centerY.equalTo(self)
                        make.top.greaterThanOrEqualTo(self).offset(2)
                        make.right.bottom.greaterThanOrEqualTo(self).offset(-2)
                        make.left.equalTo(self.snp.centerX).offset(1)
                    })
                    imageView.snp.makeConstraints({ (make) in
                        make.centerY.equalTo(self)
                        make.right.equalTo(self.snp.centerX).offset(-1)
                    })
                    break
                }
            }
        }else {
            return nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContentViewState(_ selectState: ItemViewSelectState) {
        if selectState == .ItemViewSelectStateNormal{
            contentView.backgroundColor = RGBColor(0xF4F4F4)
            contentView.layer.borderColor = UIColor.clear.cgColor
        }else if (selectState == .ItemViewSelectStateSelected) {
            contentView.backgroundColor = RGBColor(0xFFEDE7)
            contentView.layer.borderColor = RGBColor(0xFF2D5C).cgColor
        }else if (selectState == .ItemViewSelectStateNone) {
            contentView.backgroundColor = UIColor.clear
            contentView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func currentImageTransform() -> CGAffineTransform? {
        return imageView.transform
    }
    func transformImage(_ transform: CGAffineTransform?) {
        if let newTransform = transform {
            imageView.transform = newTransform
        }
    }
    
    // MARK: Handle touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.didSelectItem?(self)
    }
    
}

class FKYSearchFunctionalHeaderView: UIView {
    var isSerachItem = false //判断是否是搜索的item
    fileprivate weak var lastAddItem: FKYSearchFunctionalItemView?
    fileprivate weak var rightConstaint: NSLayoutConstraint?
    fileprivate weak var selectedItemForNotMulti: FKYSearchFunctionalItemView?
    fileprivate var currentMultiSelectedItems: Set<Int> = []
    internal var itemList:[FKYSearchFunctionalItemView] = [] //记录创建的筛选视图
    internal var didDismissFirstItem: ((_ item: FKYSearchFunctionalItemView)->())? //选择其他消失商品分类的视图
    internal var didSelectItem: ((_ item: FKYSearchFunctionalItemView?, _ selectedIndex: Int, _ isRunAction: Bool)->())?
    internal var didDeselectItem: ((_ item: FKYSearchFunctionalItemView?, _ deselectIndex: Int)->())?
    internal var didDeselectItemForMulti: ((_ item: FKYSearchFunctionalItemView?, _ deselectIndex: Int)->())?
    internal var didUpdateItem: ((_ item: FKYSearchFunctionalItemView?, _ updateIndex: Int)->())?
    
    // MARK: Actions
    // MARK: Select/deselect Segment
    fileprivate func selectSegment(_ segment: FKYSearchFunctionalItemView, isRunAction: Bool) {
        self.selectedItemForNotMulti = segment
        if isSerachItem == false{
            //收起商品分类的选择
            if let didDismissAction = self.didDismissFirstItem {
                if segment.tag != 1{
                    //点击其他把选择类型
                    if itemList.count > 1{
                        let itemView =  itemList[0]
                        didDismissAction(itemView)
                    }
                }
            }
            if let selecteAtion = self.didSelectItem {
                //月店数和销售量 条件互斥
                if segment.tag == 2{
                    if itemList.count > 2{
                        let itemView =  itemList[2]
                        itemView.setTitleColor(RGBColor(0x333333));
                        itemView.setContentViewState(.ItemViewSelectStateNormal)
                    }
                    
                }else if segment.tag == 3{
                    if itemList.count > 1{
                        let itemView =  itemList[1]
                        itemView.setTitleColor(RGBColor(0x333333));
                        itemView.setContentViewState(.ItemViewSelectStateNormal)
                    }
                }
                selecteAtion(segment, segment.tag, isRunAction)
            }
        }else{
            if let selecteAtion = self.didSelectItem {
                selecteAtion(segment, segment.tag, isRunAction)
            }
        }
    }
    fileprivate func selectSegmentForMulti(_ segment: FKYSearchFunctionalItemView, isRunAction: Bool) {
        self.currentMultiSelectedItems.insert(segment.tag)
        if isSerachItem == false{
            //收起商品分类的选择
            if let didDismissAction = self.didDismissFirstItem {
                if segment.tag != 1{
                    //点击其他把选择类型
                    if itemList.count > 1{
                        let itemView =  itemList[0]
                        didDismissAction(itemView)
                    }
                }
            }
            if let selecteAtion = self.didSelectItem {
                //月店数和销售量 条件互斥
                if segment.tag == 2{
                    if itemList.count > 2{
                        let itemView =  itemList[2]
                        itemView.setTitleColor(RGBColor(0x333333));
                        itemView.setContentViewState(.ItemViewSelectStateNormal)
                    }
                }else if segment.tag == 3{
                    if itemList.count > 1{
                        let itemView =  itemList[1]
                        itemView.setTitleColor(RGBColor(0x333333));
                        itemView.setContentViewState(.ItemViewSelectStateNormal)
                    }
                }
                selecteAtion(segment, segment.tag, isRunAction)
            }
        }else{
            if let selecteAtion = self.didSelectItem {
                selecteAtion(segment, segment.tag, isRunAction)
            }
        }
        
    }
    fileprivate func updateSegment(_ segment: FKYSearchFunctionalItemView) {
        if isSerachItem == false{
            //收起商品分类的选择
            if let didDismissAction = self.didDismissFirstItem {
                if segment.tag != 1{
                    //点击其他把选择类型
                    if itemList.count > 1{
                        let itemView =  itemList[0]
                        didDismissAction(itemView)
                    }
                }
            }
            
            if let selecteAtion = self.didSelectItem {
                //月店数和销售量 条件互斥
                if segment.tag == 2{
                    if itemList.count > 2{
                        let itemView =  itemList[2]
                        itemView.setTitleColor(RGBColor(0x333333));
                        itemView.setContentViewState(.ItemViewSelectStateNormal)
                    }
                    
                }else if segment.tag == 3{
                    if itemList.count > 1{
                        let itemView =  itemList[1]
                        itemView.setTitleColor(RGBColor(0x333333));
                        itemView.setContentViewState(.ItemViewSelectStateNormal)
                    }
                }
                selecteAtion(segment, segment.tag, false)
            }
        }else{
            if let updateAction = self.didUpdateItem {
                updateAction(segment, segment.tag)
            }
        }
        
    }
    fileprivate func deselectSegment() {
        if let deseAction = self.didDeselectItem {
            if let curSelectedItem = self.selectedItemForNotMulti {
                deseAction(curSelectedItem, curSelectedItem.tag)
            }else {
                deseAction(nil, 0)
            }
            
        }
        self.selectedItemForNotMulti = nil
    }
    
    func deselectSegmentForMulti(_ segmentTag: Int) {
        self.currentMultiSelectedItems.remove(segmentTag)
        if let deseAction = self.didDeselectItemForMulti {
            for item in self.subviews {
                if item.isKind(of: FKYSearchFunctionalItemView.self) && (segmentTag == item.tag) {
                    if (item as! FKYSearchFunctionalItemView).canMultiSelected {
                        deseAction((item as! FKYSearchFunctionalItemView), item.tag)
                    }
                }
            }
        }
    }
    //取消第一个按钮的选中
    func deselectFirstItem() {
        //收起商品分类的选择
        if let didDismissAction = self.didDismissFirstItem {
            //点击其他把选择类型
            if itemList.count > 1{
                let itemView =  itemList[0]
                didDismissAction(itemView)
            }
        }
    }
    fileprivate func addSubItems(_ items: [(title:String?, imageName:String?, contentAlignment:ImagesWithTextAlignment, canMultiSelected: Bool,hasContentBg:Bool)]) {
        if 0 > items.count  {
            return;
        }
        self.itemList.removeAll()
        for (index ,itemTuple) in items.enumerated() {
            let itemView = FKYSearchFunctionalItemView.init(title: itemTuple.title, imageName: itemTuple.imageName, contentAlignment: itemTuple.contentAlignment, canMultiSelected: itemTuple.canMultiSelected,hasContentBg:itemTuple.hasContentBg)
            
            if nil == itemView {
                //数据不能正常展示
                continue
            }
            
            itemView?.didSelectItem = { [weak self] segment in
                if segment.canMultiSelected {
                    if self!.currentMultiSelectedItems.contains(segment.tag) {
                        self!.updateSegment(segment)
                    }else {
                        self!.selectSegmentForMulti(segment, isRunAction: true)
                    }
                }else {
                    if self!.selectedItemForNotMulti != segment {
                        self!.deselectSegment()
                        self!.selectSegment(segment, isRunAction: true)
                    }else {//连续点击自身更新状态
                        self!.updateSegment(segment)
                    }
                }
            }
            
            itemView?.translatesAutoresizingMaskIntoConstraints = false
            addSubview(itemView!)
            itemView?.tag = self.subviews.count
            
            let  sapceWidth: CGFloat  =  2*WH(10) + CGFloat((items.count-1))*(WH(14))
            
            let  contentWidth: CGFloat = (SCREEN_WIDTH - sapceWidth)/CGFloat(items.count)
            
            if nil == lastAddItem{
                itemView?.snp.makeConstraints({ (make) in
                    make.centerY.equalTo(self)
                    make.left.equalTo(self).offset(WH(10))
                    make.height.equalTo(WH(30))
                    make.width.equalTo(contentWidth)
                })
            }else{
                itemView?.snp.makeConstraints({ (make) in
                    make.centerY.equalTo(self)
                    make.left.equalTo((lastAddItem?.snp.right)!).offset(WH(14))
                    make.height.equalTo(WH(30))
                    make.width.equalTo(contentWidth)
                })
            }
            
            //            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[itemView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["itemView" : itemView!]))
            //
            //            if nil == lastAddItem{
            //                addConstraint(NSLayoutConstraint.init(item: itemView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
            //            }else{
            //                addConstraint(NSLayoutConstraint.init(item: itemView!, attribute: .leading, relatedBy: .equal, toItem: lastAddItem, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            //                addConstraint(NSLayoutConstraint.init(item: itemView!, attribute: .width, relatedBy: .equal, toItem: lastAddItem, attribute: .width, multiplier: 1.0, constant: 0.0))
            //            }
            //
            //            if (items.count-1) <= index {
            //                let tempRightC : NSLayoutConstraint = NSLayoutConstraint.init(item: itemView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            //                addConstraint(tempRightC)
            //                self.rightConstaint = tempRightC
            //
            //            }
            
            self.lastAddItem = itemView!
            self.itemList.append(itemView!)
        }
    }
    
    init?(items: [(title:String?, imageName:String?, contentAlignment:ImagesWithTextAlignment, canMultiSelected: Bool,hasContentBg: Bool)]) {
        super.init(frame: CGRect.zero)
        
        self.addSubItems(items)
        
        let viewLine = UIView()
        viewLine.translatesAutoresizingMaskIntoConstraints = false
        viewLine.backgroundColor = m1
        self.addSubview(viewLine)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewLine(1)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["viewLine" : viewLine]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewLine]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["viewLine" : viewLine]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appendItem(_ itemTuple: (title:String?, imageName:String?, contentAlignment:ImagesWithTextAlignment, canMultiSelected: Bool,hasContentBg: Bool)) -> Bool {
        let itemView = FKYSearchFunctionalItemView.init(title: itemTuple.title, imageName: itemTuple.imageName, contentAlignment: itemTuple.contentAlignment, canMultiSelected: itemTuple.canMultiSelected,hasContentBg:itemTuple.hasContentBg)
        
        if nil == itemView {
            //数据不能正常展示
            return false
        }
        
        itemView?.didSelectItem = { [weak self] segment in
            if segment.canMultiSelected {
                if self!.currentMultiSelectedItems.contains(segment.tag) {
                    self!.updateSegment(segment)
                }else {
                    self!.currentMultiSelectedItems.insert(segment.tag)
                }
            }else {
                if self!.selectedItemForNotMulti != segment {
                    self!.deselectSegment()
                    self!.selectSegment(segment, isRunAction: true)
                }else {//连续点击自身更新状态
                    self!.updateSegment(segment)
                }
            }
        }
        
        itemView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(itemView!)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[itemView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["itemView" : itemView!]))
        
        if nil == lastAddItem {
            addConstraint(NSLayoutConstraint.init(item: itemView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        }else{
            addConstraint(NSLayoutConstraint.init(item: itemView!, attribute: .leading, relatedBy: .equal, toItem: lastAddItem, attribute: .leading, multiplier: 1.0, constant: 0.0))
            addConstraint(NSLayoutConstraint.init(item: itemView!, attribute: .width, relatedBy: .equal, toItem: lastAddItem, attribute: .width, multiplier: 1.0, constant: 0.0))
        }
        
        let tempRightC : NSLayoutConstraint = NSLayoutConstraint.init(item: itemView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        addConstraint(tempRightC)
        
        self.rightConstaint = tempRightC
        
        self.lastAddItem = itemView!
        
        return true
    }
    
    func updateItems(_ items: [(title:String?, imageName:String?, contentAlignment:ImagesWithTextAlignment, canMultiSelected: Bool,hasContentBg: Bool)]) {
        
        self.lastAddItem = nil
        self.rightConstaint = nil
        self.selectedItemForNotMulti = nil
        self.currentMultiSelectedItems = []
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        self.addSubItems(items)
        
        let viewLine = UIView()
        viewLine.translatesAutoresizingMaskIntoConstraints = false
        viewLine.backgroundColor = m1
        self.addSubview(viewLine)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewLine(1)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["viewLine" : viewLine]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewLine]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["viewLine" : viewLine]))
    }
    
    func setDefalutSelectedItem(_ selectedIndex: Int) {
        for item in self.subviews {
            if item.isKind(of: FKYSearchFunctionalItemView.self) && (selectedIndex == item.tag) {
                self.selectSegment((item as! FKYSearchFunctionalItemView), isRunAction: false)
            }
        }
    }
}

