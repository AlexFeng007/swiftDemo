//
//  FKYCredentialsInfoCell.swift
//  FKY
//
//  Created by airWen on 2017/7/17.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

import UIKit

class FKYCredentialsInfoCell: UICollectionViewCell {
    fileprivate lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x9A9A9A)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    fileprivate lazy var lblContent: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.numberOfLines = -1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(8))
            make.leading.equalTo(contentView.snp.leading).offset(WH(16))
        })
        
        self.contentView.addSubview(lblContent)
        lblContent.snp.makeConstraints({ (make) in
            make.top.equalTo(lblTitle.snp.top)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-WH(16))
            make.leading.equalTo(lblTitle.snp.trailing).offset(WH(10))
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method
    func configCell(title: String, contentTitle: String?) {
        lblTitle.text = title
        lblContent.text = contentTitle
    }
}

class FKYCredentialsInfoOneLineCell: UICollectionViewCell {
    fileprivate lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x9A9A9A)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        return label
    }()
    
    fileprivate lazy var lblContent: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.numberOfLines = -1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints({ (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(WH(16))
        })
        
        self.contentView.addSubview(lblContent)
        lblContent.snp.makeConstraints({ (make) in
            make.top.equalTo(lblTitle.snp.top)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-WH(16))
            make.leading.equalTo(lblTitle.snp.trailing).offset(WH(10))
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method
    func configCell(title: String, contentTitle: String?) {
        lblTitle.text = title
        lblContent.text = contentTitle
    }
}

class FKYCredentialsJustInfoCell: UICollectionViewCell {
    fileprivate lazy var lblContent: UILabel = {
        let label = UILabel()
        label.textColor = RGBColor(0x343434)
        label.font = UIFont.systemFont(ofSize: WH(16))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(lblContent)
        lblContent.snp.makeConstraints({ (make) in
            make.leading.equalTo(contentView.snp.leading).offset(WH(16))
            make.trailing.equalTo(contentView.snp.trailing).offset(-WH(16))
            make.top.equalTo(contentView.snp.top).offset((WH(5)))
            make.bottom.equalTo(contentView.snp.bottom).offset(WH(-5))
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public Method
    func configCell(content: String?) {
        lblContent.text = content
    }
}

class FKYCredentialsAddressCell: UICollectionViewCell {
    var addAddressBlock: (()->())?
    var setDefaultClosure: emptyClosure?
    var editClosure: emptyClosure?
    var deleteClosure: emptyClosure?
    
    fileprivate var headerView: FKYStockAddressTipView = FKYStockAddressTipView()
    
    // top (收货地址)
  //  fileprivate var viewTop: UIView?
    fileprivate var lblName: UILabel?
    fileprivate var lblPhone: UILabel?
    fileprivate var lblAddress: UILabel?
    
    // middle (仓库地址)
    fileprivate var viewMiddle: UIView?
    fileprivate var lblStockAddress: UILabel?
    fileprivate var lblPerson: UILabel?
    // fileprivate var viewLineMiddle: UIView?
    
    // bottom (操作栏)
    fileprivate var viewEmpty: UIView?
    fileprivate var btnAddAddress: UIButton?
    fileprivate var addressLabel: UILabel?
    // fileprivate var btnDelete: UIButton?
    fileprivate var viewLineBottom: UIView?
    
    //MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -
    func setupView() {
        //self.backgroundColor = bg1
        self.backgroundColor = UIColor.clear
        // self.selectionStyle = .none
        
        /********************************************************/
        
        self.headerView = {
            let view = FKYStockAddressTipView()
            self.contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.top.right.equalTo(self.contentView)
                make.height.equalTo(WH(62))
                //make.height.greaterThanOrEqualTo(WH(62))
            })
            return view
        }()
//        self.viewTop = {
//            let view = UIView()
//            view.backgroundColor = UIColor.white
//            self.contentView.addSubview(view)
//            view.snp.makeConstraints({ (make) in
//                make.left.right.equalTo(self.contentView)
//                make.top.equalTo(self.headerView.snp.bottom)
//                make.height.greaterThanOrEqualTo(WH(80))
//            })
//            return view
//        }()
        
        self.viewEmpty = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            self.contentView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.contentView)
                make.bottom.equalTo(self.contentView).offset(-WH(10))
                make.top.equalTo(self.headerView.snp.bottom)
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
                make.top.equalTo(self.headerView.snp.bottom)
                make.bottom.equalTo(self.contentView).offset(-WH(5))
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
            self.viewMiddle?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.top.equalTo(self.viewMiddle!).offset(WH(10))
                make.right.equalTo(self.viewMiddle!).offset(-WH(10))
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
             self.viewMiddle?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.top.equalTo(self.viewMiddle!).offset(WH(10))
                make.left.equalTo(self.viewMiddle!).offset(WH(10))
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
           // lbl.minimumScaleFactor = 0.8
           // lbl.adjustsFontSizeToFitWidth = true
            self.viewMiddle?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.left.equalTo(self.viewMiddle!).offset(WH(10))
                make.right.equalTo(self.viewMiddle!).offset(-WH(10))
               // make.bottom.equalTo(self.viewMiddle!).offset(-WH(10))
                make.top.equalTo((self.lblName?.snp.bottom)!).offset(WH(10))
            })
            return lbl
        }()
        
        self.viewLineBottom = {
            let view = UIView()
            view.backgroundColor = RGBColor(0xD8D8D8)
            self.viewMiddle?.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.right.equalTo(self.viewMiddle!)
                make.top.equalTo(self.lblAddress!.snp.bottom).offset(WH(10))
                make.height.equalTo(0.5)
            })
            return view
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
           // lbl.minimumScaleFactor = 0.8
           // lbl.adjustsFontSizeToFitWidth = true
            self.viewMiddle?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.left.equalTo(self.viewMiddle!).offset(WH(10))
                make.right.equalTo(self.viewMiddle!).offset(-WH(10))
                make.top.equalTo(self.viewLineBottom!.snp.bottom).offset(WH(10))
            })
            return lbl
        }()
        
        self.lblPerson = {
            let lbl = UILabel()
            lbl.backgroundColor = UIColor.clear
            lbl.textAlignment = .left
            lbl.font = UIFont.systemFont(ofSize: WH(14))
            lbl.textColor = RGBColor(0x9F9F9F)
//            lbl.numberOfLines = 2
//            lbl.minimumScaleFactor = 0.8
//            lbl.adjustsFontSizeToFitWidth = true
            self.viewMiddle?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.left.equalTo(self.viewMiddle!).offset(WH(10))
                make.right.equalTo(self.viewMiddle!).offset(-WH(10))
                make.top.equalTo(self.lblStockAddress!.snp.bottom).offset(WH(10))
                make.height.equalTo(WH(14))
            })
            return lbl
        }()
        
//        self.viewLineMiddle = {
//            let view = UIView()
//            view.backgroundColor = RGBColor(0xD8D8D8)
//             self.viewTop?.addSubview(view)
//            view.snp.makeConstraints({ (make) in
//                make.top.equalTo( self.viewTop!)
//                make.left.equalTo(self.viewTop!).offset(WH(10))
//                make.right.equalTo(self.viewTop!).offset(-WH(10))
//                make.height.equalTo(0.5)
//            })
//            return view
//        }()
        
        /********************************************************/
        
        self.addressLabel = {
            let lbl = UILabel()
            lbl.backgroundColor = UIColor.clear
            lbl.textAlignment = .center
            lbl.font = UIFont.systemFont(ofSize: WH(16))
            lbl.textColor = RGBColor(0x333333)
            lbl.text = "您还没有收货地址哦！"
            self.viewEmpty?.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.left.equalTo(self.viewEmpty!).offset(WH(10))
                make.right.equalTo(self.viewEmpty!).offset(-WH(10))
                make.top.equalTo(self.viewEmpty!).offset(WH(27))
            })
            return lbl
        }()
        
        self.btnAddAddress = {
            let btn = UIButton()
            btn.backgroundColor = RGBColor(0xFE4F50)
            btn.fontTuple = t34
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 3
            // btn.setImage(UIImage(named: "icon_cart_unselected"), for: UIControlState())
            btn.setTitle("+ 新增地址", for: UIControl.State())
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -WH(10), bottom: 0, right: 0)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -WH(20), bottom: 0, right: 0)
            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] (_) in
                guard let strongSelf = self else {
                    return
                }
                if let _ = strongSelf.addAddressBlock {
                    strongSelf.addAddressBlock!()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            self.viewEmpty?.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self.viewEmpty!)
                make.top.equalTo((self.addressLabel?.snp.bottom)!).offset(WH(12))
                make.width.equalTo(WH(127))
                make.height.equalTo(WH(37))
            })
            return btn
        }()
        
        //
//        self.btnDelete = {
//            let btn = UIButton()
//            btn.backgroundColor = UIColor.clear
//            btn.fontTuple = t3
//            btn.setImage(UIImage(named: "icon_search_delete"), for: UIControlState())
//            btn.setTitle("删除", for: UIControlState())
//            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
//                if let _ = self.deleteClosure {
//                    self.deleteClosure!()
//                }
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
//            self.viewBottom?.addSubview(btn)
//            btn.snp.makeConstraints({ (make) in
//                make.centerY.equalTo(self.viewBottom!)
//                make.right.equalTo(self.viewBottom!).offset(WH(-10))
//                make.width.equalTo(WH(50))
//                make.height.equalTo(WH(40))
//            })
//            return btn
//        }()
//
//        self.btnEdit = {
//            let btn = UIButton()
//            btn.backgroundColor = UIColor.clear
//            btn.fontTuple = t3
//            btn.setImage(UIImage(named: "icon_credentials_edit"), for: UIControlState())
//            btn.setTitle("编辑", for: UIControlState())
//            _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
//                if let _ = self.editClosure {
//                    self.editClosure!()
//                }
//            }, onError: nil, onCompleted: nil, onDisposed: nil)
//            self.viewBottom?.addSubview(btn)
//            btn.snp.makeConstraints({ (make) in
//                make.centerY.equalTo(self.viewBottom!)
//                make.right.equalTo(self.btnDelete!.snp.left).offset(WH(-20))
//                make.width.equalTo(WH(50))
//                make.height.equalTo(WH(40))
//            })
//            return btn
//        }()
        
    }
    
    
    //MARK: -
    
    func configCell(_ address: ZZReceiveAddressModel?) {
        if address != nil {
            self.viewEmpty?.isHidden = true
            self.viewMiddle?.isHidden = false
          //  self.viewTop?.isHidden = false
            
            self.lblName?.text = address?.receiverName
            self.lblPhone?.text  = address?.contactPhone
            self.lblAddress?.text = address?.addressDetailDesc
            
            if (address?.print_address) != nil {
                self.lblStockAddress?.text = "仓库地址：" + (address?.print_address)!
            }
            else {
                self.lblStockAddress?.text = "仓库地址："
            }
            
            if let purchaser = address?.purchaser, purchaser.count > 0,
                let phone = address?.purchaser_phone, phone.count > 0 {
                self.lblPerson?.text = "采购员：" + purchaser + " " + phone
            }
            else {
                self.lblPerson?.text = ""
            }
        }
        else {
            self.viewEmpty?.isHidden = false
            self.viewMiddle?.isHidden = true
           // self.viewTop?.isHidden = true
        }
    }
}
