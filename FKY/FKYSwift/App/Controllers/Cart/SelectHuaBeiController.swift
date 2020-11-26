//
//  SelectHuaBeiController.swift
//  FKY
//
//  Created by 乔羽 on 2018/10/18.
//  Copyright © 2018 yiyaowang. All rights reserved.
//

import UIKit

class SelectHuaBeiCell: UITableViewCell {
    
    fileprivate lazy var poundageL: UILabel = {
        let label = UILabel()
        label.fontTuple = t3
        return label
    }()
    
    fileprivate lazy var amountL: UILabel = {
        let label = UILabel()
        label.fontTuple = t7
        return label
    }()
    
    fileprivate lazy var selectIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cart_list_unselect_new")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        self.contentView.addSubview(poundageL)
        self.contentView.addSubview(amountL)
        self.contentView.addSubview(selectIcon)
        
        amountL.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(WH(15))
            make.top.equalTo(self.contentView).offset(WH(15.5))
            make.height.equalTo(WH(14))
        }
        
        poundageL.snp.makeConstraints { (make) in
            make.left.equalTo(amountL)
            make.top.equalTo(amountL.snp.bottom).offset(WH(6))
            make.height.equalTo(12)
        }
        
        selectIcon.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-WH(15))
            make.centerY.equalTo(self.contentView)
        }
        
        let line = UIView()
        line.backgroundColor = RGBColor(0xebedec)
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView.snp.leading).offset(WH(15))
            make.trailing.equalTo(self.contentView.snp.trailing).offset(-WH(15))
            make.bottom.equalTo(self.contentView.snp.bottom)
            make.height.equalTo(WH(1))
        }
    }
    
    func configView(model: FKYSubInstallmentModel) {
        amountL.text = "￥\(String(format: "%.2f", model.eachPrin))x\(model.hbFqNum!)期"
        poundageL.text = "手续费￥\(model.eachFee)/期"
    }
    
    func selectCell(_ isSelect: Bool) {
        if isSelect {
            selectIcon.image = UIImage(named: "cart_new_selected")
        } else {
            selectIcon.image = UIImage(named: "cart_list_unselect_new")
        }
    }
}

class SelectHuaBeiController: UIViewController {

    fileprivate var navBar : UIView?
    
    fileprivate lazy var tableView : UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.register(SelectHuaBeiCell.self, forCellReuseIdentifier: "SelectHuaBeiCell")
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        return view
    }()

    fileprivate lazy var allAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "￥0.00元"
        label.font = UIFont.boldSystemFont(ofSize: WH(14))
        label.textColor = RGBColor(0xFF2D5C)
        return label
    }()
    
    fileprivate lazy var allPoundageLabel: UILabel = {
        let label = UILabel()
        label.text = "￥0.00元"
        label.font = UIFont.boldSystemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x999999)
        return label
    }()
    
    // Public
    
    var selectIndex: Int = 0
    
    var dataSource: Array<FKYSubInstallmentModel>?
    
    var selectBlock: ((_ index: Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    fileprivate func setupNavigationBar() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.fky_setupLeftImage("icon_back_new_red_normal") {
            FKYNavigator.shared().pop()
        }
        self.navBar!.backgroundColor = bg1
        self.fky_setupTitleLabel("花呗分期详情")
        self.NavigationTitleLabel!.fontTuple = t14
    }
    
    fileprivate func setupView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar!.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        addBottomView()
        updateBottomView()
    }
    
    fileprivate func sureBtnClicked() {
        if let block = selectBlock {
            block(selectIndex)
            FKYNavigator.shared().pop()
        }
    }
    
    fileprivate func updateBottomView() {
        if let list = dataSource {
            if selectIndex <= list.count - 1 {
                let model = list[selectIndex]
                allAmountLabel.text = "￥\(String(format: "%.2f", model.totalPrinAndFee))元"
                allPoundageLabel.text = "￥\(String(format: "%.2f", model.totalEachFee))元"
            } else {
                allAmountLabel.text = "￥0.00元"
                allPoundageLabel.text = "￥0.00元"
            }
        }
    }
    
    fileprivate func addBottomView() {
        let bottomView = UIView()
        bottomView.backgroundColor = RGBColor(0xF7F7F7)
        self.view.addSubview(bottomView)
        
        let allAmountL = UILabel()
        allAmountL.text = "分期总金额"
        allAmountL.font = UIFont.boldSystemFont(ofSize: WH(14))
        allAmountL.textColor = RGBColor(0x333333)
        bottomView.addSubview(allAmountL)
        
        bottomView.addSubview(allAmountLabel)
        
        let allPoundageL = UILabel()
        allPoundageL.text = "分期总手续费"
        allPoundageL.font = UIFont.boldSystemFont(ofSize: WH(12))
        allPoundageL.textColor = RGBColor(0x999999)
        bottomView.addSubview(allPoundageL)
        
        bottomView.addSubview(allPoundageLabel)
        
        let sureBtn = UIButton(type: .system)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: WH(16))
        sureBtn.backgroundColor = RGBColor(0xFF2D5C)
        sureBtn.clipsToBounds = true
        sureBtn.layer.cornerRadius = 5
        sureBtn.bk_addEventHandler({ (btn) in
            self.sureBtnClicked()
        }, for: .touchUpInside)
        bottomView.addSubview(sureBtn)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.height.equalTo(WH(64))
        }
        
        allAmountL.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView.snp.left).offset(WH(15))
            make.top.equalTo(bottomView.snp.top).offset(WH(15))
        }
        
        allAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(allAmountL.snp.right).offset(WH(10))
            make.top.equalTo(bottomView.snp.top).offset(WH(15))
        }
        
        allPoundageL.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView.snp.left).offset(WH(15))
            make.top.equalTo(allAmountL.snp.bottom).offset(WH(5))
        }
        
        allPoundageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(allPoundageL.snp.right).offset(WH(10))
            make.top.equalTo(allAmountL.snp.bottom).offset(WH(5))
        }
        
        sureBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView.snp.right).offset(-WH(10))
            make.centerY.equalTo(bottomView)
            make.height.equalTo(WH(43))
            make.width.equalTo(WH(117))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SelectHuaBeiController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(62.5)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        tableView.reloadData()
        updateBottomView()
    }
}

extension SelectHuaBeiController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectHuaBeiCell = tableView.dequeueReusableCell(withIdentifier: "SelectHuaBeiCell", for: indexPath) as! SelectHuaBeiCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.configView(model: dataSource![indexPath.row])
        cell.selectCell(indexPath.row == selectIndex)
        return cell
    }
}
