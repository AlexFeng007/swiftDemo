//
//  InvoiceQualificationViewController.swift
//  FKY
//
//  Created by Rabe on 20/07/2017.
//  Copyright © 2017 yiyaowang. All rights reserved.
//  增票资质确认书

import Foundation

class InvoiceQualificationViewController: UIViewController {
    
    // MARK: - Properties
    var navBar : UIView?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar = {
            if let _ = self.NavigationBar {
            } else {
                self.fky_setupNavBar()
                self.fky_hiddedBottomLine(false)
            }
            return self.NavigationBar!
        }()
        
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabel("增票资质确认书")
        self.NavigationTitleLabel!.fontTuple = t50
        self.fky_hiddedBottomLine(false)
        self.setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Action
    
    // MARK: - UI
    func setupView() -> () {
        self.view.backgroundColor = bg1
        
        let titleLabel = UILabel()
        titleLabel.text = "申请开具增值税专用发票确认书"
        titleLabel.fontTuple = t49
        self.view.addSubview(titleLabel)
        
        let contentLabel = UILabel()
        let content = "根据国家税法及发票管理相关规定，任何单位和个人不得要求他人为自己开具与实际经营业务情况不符的增值税专用发票【包括并不限于\n\n（1）在没有货物采购或者没有接受应税劳务的情况下要求他人为自己开具增值税专用发票；\n\n（2）虽有货物采购或者接受应税劳务但要求他人为自己开具数量或金额与实际情况不符的增值税专用发票】，否则属于“虚开增值税专用发票”。\n\n我已充分了解上述各项相关国家税法和发票管理规定，并确认仅就我司实际购买商品或服务索取发票。\n\n如我司未按国家相关规定申请开具或使用增值税专用发票，由我司自行承担相应法律后果。"
        let mContent: NSMutableAttributedString = NSMutableAttributedString(string: content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        mContent.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, content.count))
        contentLabel.attributedText = mContent
        contentLabel.fontTuple = t16
        contentLabel.numberOfLines = 0
        self.view.addSubview(contentLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo((self.navBar?.snp.bottom)!).offset(WH(27))
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(WH(33))
            make.right.equalTo(self.view).offset(WH(-33))
            make.top.equalTo(titleLabel.snp.bottom).offset(WH(24))
        }
    }
    
    // MARK: - Private Method
    
    
}
