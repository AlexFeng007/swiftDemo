//
//  FKYSearchCollectionViewHeader.swift
//  FKY
//
//  Created by mahui on 16/8/26.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  搜索界面之搜索历史Collectionview的header

import Foundation
import SnapKit
import RxSwift

typealias CancelClick = ()->Void

class FKYSearchCollectionViewHeader: UICollectionReusableView {
    // MARK: - Property
    fileprivate var typeLabel : UILabel?
    fileprivate var cancelButn : UIButton?
    fileprivate var historyImageView : UIImageView?
    var cancelClick : CancelClick?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    fileprivate func setupView() -> () {
        historyImageView = UIImageView.init(image: UIImage.init(named: "icon_search_history"))
        self.addSubview(historyImageView!)
        historyImageView!.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(j5)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        typeLabel = UILabel()
        self.addSubview(typeLabel!)
        typeLabel!.snp.makeConstraints { (make) in
            make.left.equalTo(historyImageView!.snp.left).offset(j5)
            make.centerY.equalTo(self.snp.centerY)
        }
        typeLabel!.font = UIFont.systemFont(ofSize: 13)
        typeLabel!.textColor = RGBColor(0x8F8E94)
        
        
        cancelButn = UIButton()
        self.addSubview(cancelButn!)
        cancelButn!.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-j5)
            make.centerY.equalTo(self.snp.centerY)
        }
        cancelButn!.setImage(UIImage.init(named: "icon_search_delete"), for: UIControl.State())
        cancelButn!.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        cancelButn!.setTitle("删除历史记录", for: UIControl.State())
        cancelButn!.titleLabel?.font = t3.font
        cancelButn?.setTitleColor(RGBColor(0x8F8E94), for: UIControl.State())
        _ = cancelButn?.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.cancelClick != nil{
                strongSelf.cancelClick!()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        let line = UIView()
        line.backgroundColor = m1
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(WH(0.5))
        }
    }
    
    // MARK: - Public
    func congigView(_ title : String, cancleApper : Bool) -> () {
        typeLabel?.text = title
        cancelButn?.isHidden = cancleApper
    }
}
