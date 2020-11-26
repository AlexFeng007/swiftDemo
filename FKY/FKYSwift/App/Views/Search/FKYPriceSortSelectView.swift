//
//  FKYPriceSortSelectView.swift
//  FKY
//
//  Created by 寒山 on 2018/6/30.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

import UIKit

internal class FKYPriceSortSelectView: FKYBasePopUpView ,
    UITableViewDelegate,
    UITableViewDataSource{
    typealias selectNodeItem = (_ node: FKYSortItemModel?) -> Void
    var callBack : selectNodeItem?
    fileprivate lazy var sortArray: [FKYSortItemModel] =  {
        let sortArray : [FKYSortItemModel] = []
        return sortArray
    }()
    fileprivate var top:CGFloat = 0.0
    func initWithContentAraay(_ frame:CGRect,_ fkySortInfo:FKYSortListModel) {
        self.isShowIng = true
        self.sortArray = fkySortInfo.sortArray
        let rootView :UIWindow = UIApplication.shared.keyWindow!
        self.sourceFrame = frame
        top =  (self.sourceFrame?.maxY)!
        let maxHeight:CGFloat = SCREEN_HEIGHT - 88.0 - top - 44.0;
        let resultHeight:CGFloat = min(maxHeight, CGFloat(fkySortInfo.sortArray.count * 44));
        self.frame = CGRect(x: 0, y: top, width: SCREEN_WIDTH, height: 0)
        
        rootView.addSubview(self)
        
        self.mainTableView = {
            let tv = UITableView.init(frame: self.bounds, style: .plain )
            tv.delegate = self
            tv.dataSource = self
            tv.separatorStyle = .none
            tv.backgroundColor = UIColor.clear
            tv.backgroundView = nil
            tv.estimatedRowHeight = 44 // cell高度动态自适应
            tv.register(FKYSortItemCell.self, forCellReuseIdentifier: "FKYSortItemCell")
            self.addSubview(tv)
            return tv
        }()
        
       
        self.shadowView = {
            let v = UIView()
            v.frame = CGRect(x: 0, y: top, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - top)//CGRectMake(0, top, kScreenWidth, kScreenHeigth - top);
            v.backgroundColor = RGBColor(0x484848);
            v.alpha = 0.0
            v.isUserInteractionEnabled = true
            rootView.addSubview(v)
            rootView.insertSubview(v, belowSubview: self)
            return v
        }()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FKYPriceSortSelectView.respondsToTapGestureRecognizer))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        self.shadowView?.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.5, animations:{[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.frame = CGRect(x: 0, y: strongSelf.top, width: SCREEN_WIDTH, height: resultHeight)
            strongSelf.mainTableView?.frame = strongSelf.bounds
            strongSelf.shadowView?.alpha = 0.8 }, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.sortArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "FKYSortItemCell", for: indexPath) as! FKYSortItemCell
         let nodeInfo: FKYSortItemModel = self.sortArray[indexPath.row]
         cell .configCell(nodeInfo.title, isSelected: nodeInfo.isSelected!)
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let nodeInfo: FKYSortItemModel = self.sortArray[indexPath.row]
        if callBack != nil {
            callBack!(nodeInfo)
            self.dissmissView()
        }
    }
    
    @objc func respondsToTapGestureRecognizer(){
        if callBack != nil {
            callBack!(nil)
            self.dissmissView()
        }
    }
    func dissmissView() -> () {
        UIView.animate(withDuration: 0.5, animations:{[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.frame = CGRect(x: 0, y: strongSelf.top, width: SCREEN_WIDTH, height: 0)
            strongSelf.mainTableView?.frame = strongSelf.bounds
            strongSelf.shadowView?.alpha = 0.0
        }, completion: {[weak self] finish in
            guard let strongSelf = self else {
                return
            }
               strongSelf.isShowIng = false
                strongSelf.shadowView?.removeFromSuperview()
                strongSelf.mainTableView?.removeFromSuperview()
                if (strongSelf.superview != nil) {
                    strongSelf.removeFromSuperview()
                }
        })
    }
    func dissmissViewRightNow() -> () {
        self.isShowIng = false
        if callBack != nil {
            callBack!(nil)
        }
        self.shadowView?.removeFromSuperview()
        self.mainTableView?.removeFromSuperview()
        if (self.superview != nil) {
            self.removeFromSuperview()
        }
    }
    func dissmissViewForScroll() -> () {
        self.isShowIng = false
        self.shadowView?.removeFromSuperview()
        self.mainTableView?.removeFromSuperview()
        if (self.superview != nil) {
            self.removeFromSuperview()
        }
    }
    func callBackBlock(_ block: @escaping selectNodeItem) {
        
        callBack = block
    }
}

class FKYSortItemCell: UITableViewCell {
    
    fileprivate lazy var selectedImageview: UIImageView =  {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.clear
        imageV.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageV)
        return imageV
    }()
    
    fileprivate lazy var titleLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(14))
        label.textColor = RGBColor(0x555555);
        label.textAlignment = .left
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        self.contentView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var bottomLine: UIView =  {
        let lineV = UIView ()
        lineV.backgroundColor = RGBColor(0xE5E5E5)
        self.contentView.addSubview(lineV)
        return lineV
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectedImageview.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(WH(-40))
            make.height.width.equalTo(WH(20))
        })
        self.titleLabel.snp.makeConstraints({ (make) in
//            make.centerY.equalTo(self)
            make.top.equalTo(self.contentView).offset(WH(10))
            make.bottom.equalTo(self.contentView).offset(WH(-10))
            make.left.equalTo(self.contentView).offset(WH(18))
            make.right.equalTo(self.selectedImageview.snp_left)
        })
        self.bottomLine.snp.makeConstraints({ (make) in
            make.bottom.right.left.equalTo(self.contentView)
            make.height.equalTo(0.5)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configCell(_ title: String?, isSelected: Bool) {
        self.titleLabel.text = title
        
        if isSelected {
            self.titleLabel.textColor = RGBColor(0xFF2D5C)
            self.selectedImageview.image = UIImage.init(named: "Search_Selected")
        }else {
            self.titleLabel.textColor = RGBColor(0x555555)
            self.selectedImageview.image = nil
        }
    }
}
