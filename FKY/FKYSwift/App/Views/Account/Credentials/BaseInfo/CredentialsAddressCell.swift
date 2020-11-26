//
//  CredentialsAddressCell.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/1.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  地址(管理)列表界面之地址cell

import UIKit
import SnapKit
import RxSwift

class CredentialsAddressCell: UITableViewCell {
    //MARK: -
//    fileprivate var bottomSeparatorView: UIView?
//    fileprivate var nameLabel: UILabel?
//    fileprivate var phoneLabel: UILabel?
//    fileprivate lazy var addressContentLabel: UILabel = {
//        let label = UILabel()
//        label.fontTuple = t9
//        label.numberOfLines = 2
//        label.textAlignment = .left
//        return label
//    }()
//    fileprivate var separatorLine: UIView?
//    fileprivate var setDefaultBtn: UIButton?
//    fileprivate var editBtn: UIButton?
//    fileprivate var deleteBtn: UIButton?
    
    var setDefaultClosure: emptyClosure?
    var editClosure: emptyClosure?
    var deleteClosure: emptyClosure?
    
    // top (收货地址)
    fileprivate var viewTop: UIView?
    fileprivate var lblName: UILabel?
    fileprivate var lblPhone: UILabel?
    fileprivate var lblAddress: UILabel?
    
    // middle (仓库地址)
    fileprivate var viewMiddle: UIView?
    fileprivate var lblStockAddress: UILabel?
    fileprivate var lblPerson: UILabel?
    fileprivate var viewLineMiddle: UIView?
    
    // bottom (操作栏)
    fileprivate var viewBottom: UIView?
    fileprivate var btnDefault: UIButton?
    fileprivate var btnEdit: UIButton?
    fileprivate var btnDelete: UIButton?
    fileprivate var viewLineBottom: UIView?
    
    //MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: -
    func setupView() {
        //self.backgroundColor = bg1
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        /********************************************************/
        
        self.viewTop = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            self.contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.top.right.equalTo(self.contentView)
                //make.height.equalTo(WH(86))
                make.height.greaterThanOrEqualTo(WH(80))
            })
            return view
        }()
        
        self.viewBottom = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            self.contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.contentView)
                make.bottom.equalTo(self.contentView).offset(-WH(10))
                make.height.equalTo(WH(50))
            })
            return view
        }()
        
        self.viewMiddle = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.clipsToBounds = true
            self.contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.contentView)
                make.top.equalTo((self.viewTop?.snp.bottom)!)
                make.bottom.equalTo((self.viewBottom?.snp.top)!)
            })
            return view
        }()
        
        /********************************************************/
        
        self.lblPhone = {
            let lbl = UILabel()
            lbl.backgroundColor = UIColor.clear
            lbl.textAlignment = .right
            //lbl.font = UIFont.boldSystemFont(ofSize: WH(16))
            lbl.font = UIFont.systemFont(ofSize: WH(16))
            lbl.textColor = RGBColor(0x343434)
            lbl.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            lbl.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            self.viewTop?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.top.equalTo(self.viewTop!).offset(WH(10))
                make.right.equalTo(self.viewTop!).offset(-WH(10))
                make.height.equalTo(WH(20))
            })
            return lbl
        }()
        
        self.lblName = {
            let lbl = UILabel()
            lbl.backgroundColor = UIColor.clear
            lbl.textAlignment = .left
            lbl.font = UIFont.systemFont(ofSize: WH(16))
            lbl.textColor = RGBColor(0x343434)
            lbl.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 800), for: NSLayoutConstraint.Axis.horizontal)
            lbl.setContentHuggingPriority(UILayoutPriority(rawValue: 800), for: NSLayoutConstraint.Axis.horizontal)
            self.viewTop?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.top.equalTo(self.viewTop!).offset(WH(10))
                make.left.equalTo(self.viewTop!).offset(WH(10))
                make.right.equalTo((self.lblPhone?.snp.left)!).offset(-WH(10))
                make.height.equalTo(WH(20))
            })
            return lbl
        }()
        
        self.lblAddress = {
            let lbl = UILabel()
            lbl.backgroundColor = UIColor.clear
            lbl.textAlignment = .left
            lbl.font = UIFont.systemFont(ofSize: WH(14))
            lbl.textColor = RGBColor(0x343434)
            lbl.numberOfLines = 3
            lbl.minimumScaleFactor = 0.8
            lbl.adjustsFontSizeToFitWidth = true
            self.viewTop?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.left.equalTo(self.viewTop!).offset(WH(10))
                make.right.equalTo(self.viewTop!).offset(-WH(10))
                make.bottom.equalTo(self.viewTop!).offset(-WH(10))
                make.top.equalTo((self.lblName?.snp.bottom)!).offset(WH(10))
            })
            return lbl
        }()
        
        /********************************************************/
        
        self.lblStockAddress = {
            let lbl = UILabel()
            lbl.backgroundColor = UIColor.clear
            lbl.textAlignment = .left
            lbl.font = UIFont.systemFont(ofSize: WH(14))
            lbl.textColor = RGBColor(0x9F9F9F)
            lbl.text = "仓库地址："
            lbl.numberOfLines = 3
            lbl.minimumScaleFactor = 0.8
            lbl.adjustsFontSizeToFitWidth = true
            self.viewMiddle?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.left.equalTo(self.viewMiddle!).offset(WH(10))
                make.right.equalTo(self.viewMiddle!).offset(-WH(10))
                make.top.equalTo(self.viewMiddle!).offset(WH(10))
            })
            return lbl
        }()
        
        self.lblPerson = {
            let lbl = UILabel()
            lbl.backgroundColor = UIColor.clear
            lbl.textAlignment = .left
            lbl.font = UIFont.systemFont(ofSize: WH(14))
            lbl.textColor = RGBColor(0x9F9F9F)
            lbl.numberOfLines = 2
            lbl.minimumScaleFactor = 0.8
            lbl.adjustsFontSizeToFitWidth = true
            self.viewMiddle?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.left.equalTo(self.viewMiddle!).offset(WH(10))
                make.right.equalTo(self.viewMiddle!).offset(-WH(10))
                make.top.equalTo(self.lblStockAddress!.snp.bottom).offset(WH(6))
                make.bottom.equalTo(self.viewMiddle!).offset(-WH(10))
            })
            return lbl
        }()
        
        self.viewLineMiddle = {
            let view = UIView()
            view.backgroundColor = RGBColor(0xD8D8D8)
            self.viewMiddle?.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(self.viewMiddle!)
                make.left.equalTo(self.viewMiddle!).offset(WH(10))
                make.right.equalTo(self.viewMiddle!).offset(-WH(10))
                make.height.equalTo(0.5)
            })
            return view
        }()
        
        /********************************************************/
        
        self.btnDefault = {
            let btn = UIButton()
            btn.backgroundColor = UIColor.clear
            btn.fontTuple = t3
            btn.setImage(UIImage(named: "icon_cart_unselected"), for: UIControl.State())
            btn.setTitle("默认地址", for: UIControl.State())
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -WH(10), bottom: 0, right: 0)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -WH(20), bottom: 0, right: 0)
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if let _ = strongSelf.setDefaultClosure {
                    strongSelf.setDefaultClosure!()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            self.viewBottom?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.viewBottom!)
                make.left.equalTo(self.viewBottom!).offset(WH(5))
                make.width.equalTo(WH(100))
                make.height.equalTo(WH(40))
            })
            return btn
        }()
        
        self.btnDelete = {
            let btn = UIButton()
            btn.backgroundColor = UIColor.clear
            btn.fontTuple = t3
            btn.setImage(UIImage(named: "icon_search_delete"), for: UIControl.State())
            btn.setTitle("删除", for: UIControl.State())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if let _ = strongSelf.deleteClosure {
                    strongSelf.deleteClosure!()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            self.viewBottom?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.viewBottom!)
                make.right.equalTo(self.viewBottom!).offset(WH(-10))
                make.width.equalTo(WH(50))
                make.height.equalTo(WH(40))
            })
            return btn
        }()
        
        self.btnEdit = {
            let btn = UIButton()
            btn.backgroundColor = UIColor.clear
            btn.fontTuple = t3
            btn.setImage(UIImage(named: "icon_credentials_edit"), for: UIControl.State())
            btn.setTitle("编辑", for: UIControl.State())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if let _ = strongSelf.editClosure {
                    strongSelf.editClosure!()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            self.viewBottom?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self.viewBottom!)
                make.right.equalTo(self.btnDelete!.snp.left).offset(WH(-20))
                make.width.equalTo(WH(50))
                make.height.equalTo(WH(40))
            })
            return btn
        }()
        
        self.viewLineBottom = {
            let view = UIView()
            view.backgroundColor = RGBColor(0xD8D8D8)
            self.viewBottom?.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(self.viewBottom!)
                make.height.equalTo(0.5)
            })
            return view
        }()
        
        /*
        self.nameLabel = {
            let title = UILabel()
            self.contentView.addSubview(title)
            title.snp.makeConstraints({ (make) in
                make.left.top.equalTo(self.contentView).offset(WH(10))
                make.height.equalTo(WH(25))
                make.width.lessThanOrEqualTo(WH(200))
            })
            title.fontTuple = t7
            title.textAlignment = .left
            return title
        }()
        
        self.phoneLabel = {
            let title = UILabel()
            self.contentView.addSubview(title)
            title.snp.makeConstraints({ (make) in
                make.top.equalTo(self.contentView).offset(WH(10))
                make.right.equalTo(self.contentView).offset(WH(-10))
                make.height.equalTo(WH(25))
                make.width.lessThanOrEqualTo(WH(110))
            })
            title.fontTuple = t7
            title.textAlignment = .right
            return title
        }()
        
        self.contentView.addSubview(self.addressContentLabel)
        self.addressContentLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(self.nameLabel!.snp.bottom)
            make.right.equalTo(self.contentView).offset(WH(-10))
            make.height.equalTo(WH(45))
            make.left.equalTo(self.contentView).offset(WH(10))
        })
        
        self.separatorLine = {
            let v = UIView()
            self.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(WH(10))
                make.right.equalTo(self.contentView).offset(WH(-10))
                make.top.equalTo(self.addressContentLabel.snp.bottom)
                make.height.equalTo(1)
            })
            v.backgroundColor = m2
            return v
        }()
        
        self.setDefaultBtn = {
            
            let btn = UIButton()
            btn.setImage(UIImage(named: "icon_cart_unselected"), for: UIControlState())
            btn.setTitle("默认地址", for: UIControlState())
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, WH(10), 0, 0)
            btn.fontTuple = t3
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
                if let _ = self.setDefaultClosure {
                    self.setDefaultClosure!()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            self.contentView.addSubview(btn)
            
            btn.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(WH(10))
                make.width.equalTo(WH(100))
//                make.height.lessThanOrEqualTo(WH(40))
                make.top.equalTo(self.separatorLine!.snp.bottom)
                make.bottom.equalTo(self.contentView.snp.bottom)
            })
            return btn
        }()
        
        self.deleteBtn = {
            let btn = UIButton()
            self.contentView.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.right.equalTo(self.contentView).offset(WH(-10))
                make.width.equalTo(WH(50))
                make.height.equalTo(WH(40))
                make.top.equalTo(self.separatorLine!.snp.bottom)
            })
            
            btn.fontTuple = t3
            btn.setImage(UIImage(named: "icon_search_delete"), for: UIControlState())
            btn.setTitle("删除", for: UIControlState())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
                if let _ = self.deleteClosure {
                    self.deleteClosure!()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
        
        self.editBtn = {
            let btn = UIButton()
            self.contentView.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.right.equalTo(self.deleteBtn!.snp.left).offset(WH(-20))
                make.width.equalTo(WH(50))
                make.height.equalTo(WH(40))
                make.top.equalTo(self.separatorLine!.snp.bottom)
            })
            
            btn.fontTuple = t3
            btn.setImage(UIImage(named: "icon_credentials_edit"), for: UIControlState())
            btn.setTitle("编辑", for: UIControlState())
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
                if let _ = self.editClosure {
                    self.editClosure!()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            return btn
        }()
        
        self.bottomSeparatorView = {
            let v = UIView()
            self.contentView.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.bottom.right.left.equalTo(self.contentView)
                make.height.equalTo(5)
            })
            v.backgroundColor = bg2
            return v
        }()
        
        self.backgroundColor = bg1
        self.selectionStyle = .none
    */
        
    }
    
    
    //MARK: -
    
    func configCell(_ address: ZZReceiveAddressModel?) {
        self.lblName?.text = address?.receiverName
        self.lblPhone?.text  = address?.contactPhone
        self.lblAddress?.text = address?.addressDetailDesc
        
        if address?.defaultAddress == 1 {
            self.btnDefault?.setImage(UIImage(named:"icon_cart_selected"), for: UIControl.State())
        } else {
            self.btnDefault?.setImage(UIImage(named:"icon_cart_unselected"), for: UIControl.State())
        }
        
        if (address?.print_address) != nil {
            self.lblStockAddress?.text = "仓库地址：" + (address?.print_address)!
        }
        else {
            self.lblStockAddress?.text = "仓库地址："
        }
        
        if let purchaser = address?.purchaser,
            purchaser.count > 0,
            let phone = address?.purchaser_phone,
            phone.count > 0 {
            
            self.lblPerson?.text = "采购员：" + purchaser + " " + phone
        } else {
            self.lblPerson?.text = ""
        }
    }
    
//    static func calculatorHeightForModel(_ content: String?) -> CGFloat {
//        return WH(115)
//    }
//
//    func configCell(_ address: ZZReceiveAddressModel?){
//        self.nameLabel?.text = address?.receiverName
//        self.phoneLabel?.text  = address?.contactPhone
//
//        self.addressContentLabel.text = address?.addressDetailDesc
//        if address?.defaultAddress == 1 {
//            self.setDefaultBtn?.setImage(UIImage(named:"icon_cart_selected"), for: UIControlState())
//        }else{
//            self.setDefaultBtn?.setImage(UIImage(named:"icon_cart_unselected"), for: UIControlState())
//        }
//    }
//
//    func configDetailCell(_ address: ZZReceiveAddressModel?) {
//        self.nameLabel?.text = address?.receiverName
//        self.phoneLabel?.text  = address?.contactPhone
//        self.editBtn?.isHidden = true
//        self.deleteBtn?.isHidden = true
//        self.separatorLine?.isHidden = true
//        self.setDefaultBtn?.isHidden = true
//        self.addressContentLabel.text = address?.addressDetailDesc
//        if address?.defaultAddress == 1 {
//            self.separatorLine?.isHidden = false
//            self.setDefaultBtn?.isHidden = false
//            self.setDefaultBtn?.setImage(UIImage(named:"icon_cart_selected"), for: UIControlState())
//        }else{
//            self.setDefaultBtn?.setImage(UIImage(named:"icon_cart_unselected"), for: UIControlState())
//        }
//    }
}
