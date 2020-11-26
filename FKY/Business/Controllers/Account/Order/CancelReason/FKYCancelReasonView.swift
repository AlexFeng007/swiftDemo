//
//  FKYCancelReasonView.swift
//  FKY
//
//  Created by My on 2019/12/10.
//  Copyright © 2019 yiyaowang. All rights reserved.
//

import UIKit

@objc class FKYCancelReasonView: UIView {
    
    @objc var modelsArray = [FKYOrderResonModel]()
    @objc var closeClouser: (() -> ())?
    @objc var confirmClouser: ((_ type: String, _ reasonStr: String?, _ biReason: String?, _ position: Int) -> ())?
    var reasonStr: String? //取消原因
    
    //选中的Index
    var selectedIndex = -1
    
    lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var sepLineOne: UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "btn_pd_group_close"), for: .normal)
        btn.setImage(UIImage(named: "btn_pd_group_close"), for: .highlighted)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {  [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.endEditing(true)
            strongSelf.closeClouser?()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    lazy var titleLb: UILabel = {
        let lb = UILabel()
        lb.text = "取消订单"
        lb.textColor = RGBColor(0x000000)
        lb.font = UIFont.systemFont(ofSize: WH(17))
        return lb
    }()
    
    lazy var confirmBg: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(63)))
        view.backgroundColor  = RGBColor(0xF7F7F7)
        view.addSubview(confirmBtn)
        confirmBtn.snp_makeConstraints { (make) in
            make.height.equalTo(WH(43))
            make.left.equalToSuperview().offset(WH(30))
            make.right.equalToSuperview().offset(-WH(30))
            make.top.equalToSuperview().offset(WH(10))
        }
        return view
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = RGBColor(0xFF2D5C)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(16))
        _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: {  [weak self] (_) in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.endEditing(true)
            if strongSelf.selectedIndex == -1 {
                FKYAppDelegate!.showToast("请选择取消订单原因")
                return
            }
            
            let model = strongSelf.modelsArray[strongSelf.selectedIndex]
            if let type = model.type, type == 7 {
                if let reason = strongSelf.reasonStr, reason.isEmpty == false {
                    strongSelf.confirmClouser?(String(model.type!), strongSelf.reasonStr, model.reason,strongSelf.selectedIndex + 1)
                }else {
                    strongSelf.confirmClouser?(String(model.type!), "", model.reason,strongSelf.selectedIndex + 1)
                }
            }else {
                strongSelf.confirmClouser?(String(model.type!),"", model.reason, strongSelf.selectedIndex + 1)
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        return btn
    }()
    
    
    lazy var remindLb: YYLabel = {
        let lb  = YYLabel()
        lb.numberOfLines = 0
        lb.backgroundColor =  RGBColor(0xFFFCF1)
        lb.textContainerInset = UIEdgeInsets(top: WH(5), left: WH(16), bottom: WH(5), right: WH(16))
        let attributes = NSMutableAttributedString(string: "温馨提示：\n1.订单一旦取消，无法恢复\n2.如订单已支付，金额会在1~3个工作日返还到原支付方式\n3.使用的优惠券和返利金将返还")
        attributes.yy_font = UIFont.systemFont(ofSize: WH(12))
        attributes.yy_color = RGBColor(0xE8772A)
        attributes.yy_lineSpacing = WH(1)
        lb.attributedText = attributes
        return lb
    }()
    
    lazy var tipLb: UILabel = {
        let lb  = UILabel()
        lb.font = UIFont.systemFont(ofSize: WH(14))
        lb.textColor = RGBColor(0x999999)
        return lb
    }()
    
    
    lazy var reasonTable: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.tableHeaderView = selectedTipView
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        view.separatorColor = RGBColor(0xE5E5E5) // 分隔线颜色
        if #available(iOS 11, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        view.showsVerticalScrollIndicator  = false
        view.register(FKYCancelReasonCell.self, forCellReuseIdentifier: "FKYCancelReasonCell")
        view.register(FKYOtherReasonCell.self, forCellReuseIdentifier: "FKYOtherReasonCell")
        
        return view
    }()
    
    lazy var selectedTipView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: WH(112)))
        view.backgroundColor = .white
        let lb = UILabel()
        lb.text = "请选择取消订单原因"
        lb.font = UIFont.systemFont(ofSize: WH(13))
        lb.textColor = RGBColor(0x666666)
        view.addSubview(remindLb)
        view.addSubview(lb)
        remindLb.snp_makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(WH(83))
        }
        
        lb.snp_makeConstraints { (make) in
            make.top.equalTo(remindLb.snp_bottom)
            make.left.equalToSuperview().offset(WH(30))
            make.bottom.equalToSuperview()
        }
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension FKYCancelReasonView {
    func setupUI() {
        addSubview(titleView)
        titleView.addSubview(closeBtn)
        titleView.addSubview(titleLb)
        titleView.addSubview(sepLineOne)
        addSubview(reasonTable)
        addSubview(confirmBg)
        
        titleView.snp_makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(WH(55))
        }
        
        closeBtn.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-WH(0.5))
            make.left.equalToSuperview().offset(WH(13))
            make.size.equalTo(CGSize(width: WH(30), height: WH(30)))
        }
        
        titleLb.snp_makeConstraints { (make) in
            make.centerY.equalTo(closeBtn)
            make.centerX.equalToSuperview()
        }
        
        sepLineOne.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(WH(1))
        }
        
        confirmBg.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(WH(63) + COInputController.getScreenBottomMargin())
        }
        reasonTable.snp_makeConstraints { (make) in
            make.top.equalTo(titleView.snp_bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(confirmBg.snp_top)
        }
    }
}

extension FKYCancelReasonView {
    @objc func reloadReasonsTable(data: [FKYOrderResonModel]?) {
        guard let models = data, models.count > 0 else {
            return
        }
        modelsArray = models
        reasonStr = ""
        selectedIndex = -1
        reasonTable.reloadData()
    }
}

extension FKYCancelReasonView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if modelsArray.count > indexPath.row {
            let model = modelsArray[indexPath.row]
            if let type = model.type, type == 7 {
                if indexPath.row == selectedIndex {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FKYOtherReasonCell", for: indexPath) as! FKYOtherReasonCell
                    cell.configCell(model, true)
                    cell.beginEditingClosure = { [weak self] in
                        if let strongSelf = self {
                            strongSelf.fky_YYTextViewTextDidBeginEditing()
                        }
                    }
                    cell.endEditingClosure = { [weak self] in
                        if let strongSelf = self {
                            strongSelf.fky_YYTextViewTextDidEndEditing()
                        }
                    }
                    cell.didChangeClosure = { [weak self](str) in
                        if let strongSelf = self {
                            strongSelf.reasonStr = str
                        }
                    }
                    return cell
                }
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FKYCancelReasonCell", for: indexPath) as! FKYCancelReasonCell
            cell.configCell(model, (indexPath.row == selectedIndex), (indexPath.row == modelsArray.count - 1))
            // 点击btn后选中
            cell.selectBlock = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.selectedIndex = indexPath.row
                strongSelf.reasonTable.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if strongSelf.modelsArray.count > strongSelf.selectedIndex {
                        let model = strongSelf.modelsArray[strongSelf.selectedIndex]
                        if let type = model.type, type == 7 {
                            if  let cell = strongSelf.reasonTable.cellForRow(at: IndexPath(row: strongSelf.modelsArray.count - 1, section: 0)) as? FKYOtherReasonCell {
                                cell.becomeResponser()
                            }
                        }
                    }
                }
            }
            return cell
        }
        
        return UITableViewCell.init(style: .default, reuseIdentifier: "error")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        tableView.deselectRow(at: indexPath, animated: true)
        if selectedIndex == indexPath.row {
            return
        }
        self.endEditing(true)
        selectedIndex = indexPath.row
        reasonTable.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
            if let strongSelf = self {
                if strongSelf.modelsArray.count > strongSelf.selectedIndex {
                    let model = strongSelf.modelsArray[strongSelf.selectedIndex]
                    if let type = model.type, type == 7 {
                        if  let cell = strongSelf.reasonTable.cellForRow(at: IndexPath(row: strongSelf.modelsArray.count - 1, section: 0)) as? FKYOtherReasonCell {
                            cell.becomeResponser()
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if modelsArray.count > indexPath.row {
            let model = modelsArray[indexPath.row]
            if let type = model.type, type == 7 {
                if indexPath.row == selectedIndex {
                    return WH(43 + 85 + 30)
                }
            }
        }
        return WH(43)
    }
}


extension FKYCancelReasonView {
    
    @objc func fky_YYTextViewTextDidBeginEditing() {
        self.reasonTable.scrollToRow(at: IndexPath(row: self.modelsArray.count - 1, section: 0), at: .bottom, animated: false)
    }
    
    @objc func fky_YYTextViewTextDidEndEditing() {
        
    }
}


