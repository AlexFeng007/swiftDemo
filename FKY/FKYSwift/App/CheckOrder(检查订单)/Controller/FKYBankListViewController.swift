//
//  FKYBankListViewController.swift
//  FKY
//
//  Created by yyc on 2020/5/7.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYBankListViewController: UIViewController {
    
    //MARK: - Property
    // 响应视图
    fileprivate lazy var viewDismiss: UIView! = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // 标题
    fileprivate lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = RGBColor(0x000000)
        lbl.font = UIFont.boldSystemFont(ofSize: WH(18))
        lbl.textAlignment = .center
        lbl.text = "支持银行卡"
        return lbl
    }()
    //快速选择提示
    fileprivate lazy var totastLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = RGBColor(0xffffff)
        label.font = t15.font
        label.textAlignment = .center
        label.backgroundColor = RGBColor(0xFF2D5C)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = WH(50)/2.0
        return label
    }()
    fileprivate lazy var tableView: UITableView = { [weak self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.estimatedRowHeight = WH(200)
        tableView.sectionIndexColor = RGBColor(0x008EFF)
        tableView.register(FKYPopShopListTableViewCell.self, forCellReuseIdentifier: "FKYPopShopListTableViewCell")
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        return tableView
        }()
    
    // 内容视图...<包含所有内容的容器视图>
    fileprivate lazy var viewContent: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = WH(4)
        view.layer.masksToBounds = true
        
        // top
        view.addSubview(self.viewTop)
        self.viewTop.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(WH(56))
        }
        view.addSubview(self.lblTip)
        self.lblTip.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(self.viewTop.snp.bottom)
            make.height.equalTo(WH(32))
        }
        // tableview
        view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(self.lblTip.snp.bottom)
        }
        view.addSubview(self.totastLabel)
        self.totastLabel.snp.makeConstraints({ (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(WH(50))
        })
        return view
    }()
    fileprivate lazy var aryLetterIndexForMore: [String] =  {
        let stringArray : [String] = []
        return stringArray
    }()
    //银行列表
    lazy var bankDicDataForMore:[String:Array<FKYBankIndeModel>] = {
        let dicMoreData : [String:Array<FKYBankIndeModel>] = [:]
        return dicMoreData
    }()
    // 顶部视图...<标题、关闭>
    fileprivate lazy var viewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        // 标题
        view.addSubview(self.lblTitle)
        self.lblTitle.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
        
        // 关闭
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.alpha = 1.0
        btn.setImage(UIImage.init(named: "btn_pd_group_close"), for: .normal)
        btn.rx.tap.bind(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.view.superview != nil {
                strongSelf.showOrHideBankPopView(false)
                if let block = strongSelf.closePopView {
                    block()
                }
            }
        }).disposed(by: disposeBag)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(WH(30))
            make.width.equalTo(WH(50))
        }
        
        // 分隔线
        let viewLine = UIView.init(frame: CGRect.zero)
        viewLine.backgroundColor = RGBColor(0xE5E5E5)
        view.addSubview(viewLine)
        viewLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(WH(0.5))
        }
        return view
    }()
    
    // 标题
    fileprivate lazy var lblTip: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = RGBColor(0xFFFCF1)
        lbl.textColor = RGBColor(0xE8772A)
        lbl.font = t3.font
        lbl.textAlignment = .center
        lbl.text = "仅支持储蓄卡，不支持信用卡"
        return lbl
    }()
    
    // 店铺列表是否弹出是否已弹出
    var viewShowFlag: Bool = false
    var bankArr = [FKYBankIndeModel]() //店铺列表
    var closePopView : (()->(Void))?  //关闭弹框
    //MARK:入参数
    fileprivate  var contentView_H : CGFloat = 0.0 //内容视图的高度
    
    //MARK: - LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.showOrHideBankPopView(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("...>>>>>>>>>>>>>>>>>>>>>FKYBankListViewController deinit~!@")
    }
    
}
extension FKYBankListViewController {
    //MARK: - SetupView
    func setupView() {
        self.setupSubview()
    }
    
    // 设置整体子容器视图
    func setupSubview() {
        self.view.backgroundColor = UIColor.clear
        self.view.isUserInteractionEnabled = true
        self.view.addSubview(self.viewDismiss)
        self.viewDismiss.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
//        self.viewDismiss.bk_(whenTapped:  { [weak self] in
//            if let strongSelf = self {
//                strongSelf.showOrHideBankPopView(false)
//                if let block = strongSelf.closePopView {
//                    block()
//                }
//            }
//        })
        self.view.addSubview(self.viewContent)
        self.viewContent.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
            make.width.equalTo(SCREEN_WIDTH-WH(32))
            make.height.equalTo(contentView_H)
        }
    }
}

//MARK: - Public(弹框)
extension FKYBankListViewController {
    // 显示or隐藏可用银行列表视图
    @objc func showOrHideBankPopView(_ show: Bool) {
        //防止弹两次
        if show == viewShowFlag {
            return
        }
        viewShowFlag = show
        if show {
            //添加在根视图上面
            if let window = UIApplication.shared.keyWindow {
                if let rootView = window.rootViewController?.view {
                    window.rootViewController?.addChild(self)
                    rootView.addSubview(self.view)
                    self.view.snp.makeConstraints({ (make) in
                        make.edges.equalTo(rootView)
                    })
                }
            }
            
            self.viewContent.snp.updateConstraints({ (make) in
                make.height.equalTo(contentView_H)
            })
            self.view.layoutIfNeeded()
            self.viewTop.isHidden = true
            self.viewContent.isHidden = true
            self.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.6)
                    strongSelf.viewTop.isHidden = false
                    strongSelf.viewContent.isHidden = false
                    strongSelf.totastLabel.isHidden = true
                    strongSelf.view.layoutIfNeeded()
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { (_) in
                    //
            })
        }
        else {
            self.view.endEditing(true)
            // 隐藏
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                if let strongSelf = self {
                    strongSelf.viewDismiss.backgroundColor = RGBColor(0x333333).withAlphaComponent(0.0)
                    strongSelf.viewTop.isHidden = true
                    strongSelf.viewContent.isHidden = true
                    strongSelf.totastLabel.isHidden = true
                    strongSelf.view.layoutIfNeeded()
                }
                
                }, completion: { [weak self] (_) in
                    if let strongSelf = self {
                        strongSelf.view.removeFromSuperview()
                        strongSelf.removeFromParent()
                        // 移除通知
                    }
            })
        }
    }
    func removeMySelf() {
        if viewShowFlag == true {
            viewShowFlag = false
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    //视图赋值
    @objc func configPopBankListViewController(_ arr:[FKYBankIndeModel]) {
        var allKeyArr :[String] = []
        
        if arr.count > 0 {
            self.bankArr = arr
            for item in self.bankArr {
                let firstLetterOfPinyin:String = self.getPinyinOfStringFirstLetters(item.bankName ?? "")
                var strAry:Array<FKYBankIndeModel>? = self.bankDicDataForMore[firstLetterOfPinyin]
                if nil == strAry {
                    strAry = []
                }
                strAry?.append(item)
                self.bankDicDataForMore[firstLetterOfPinyin] = strAry
                //记录字母
                if allKeyArr.contains(firstLetterOfPinyin) == false {
                    allKeyArr.append(firstLetterOfPinyin)
                }
            } //排序及调整
            let arr = allKeyArr.sorted()
            if (arr.contains("#") && arr.count > 1) {
                self.aryLetterIndexForMore =  arr[1...arr.count-1] + ["#"]
            }else {
                self.aryLetterIndexForMore = arr
            }
            let totalNum = WH(44)*CGFloat(arr.count) + WH(56+32)
            if totalNum < CONTENT_POP_SHOP_LIST_MIN_VIEW_H {
                self.contentView_H = CONTENT_POP_SHOP_LIST_MIN_VIEW_H
            }else {
                self.contentView_H = totalNum > CONTENT_POP_SHOP_LIST_MAX_VIEW_H ? CONTENT_POP_SHOP_LIST_MAX_VIEW_H : totalNum
            }
            self.showOrHideBankPopView(true)
            self.tableView.reloadData()
        }
    }
    // MARK: - Private
    fileprivate func getPinyinOfStringFirstLetters(_ factoryName: String) -> String {
        var py="#"
        if factoryName.count > 0 {
            
            let index = (factoryName as NSString).character(at: 0)
            
            if( index > 0x4e00 && index < 0x9fff)
            {
                let strPinYin:String = factoryName.transformToPinyin()
                py  = (strPinYin as NSString).substring(to: 1).uppercased()
                
            }
            else{
                
                py = (factoryName as NSString).substring(to: 1).uppercased()
                //不是字母
                if (py < "A" || py > "Z") {
                    py = "#"
                }
                
            }
        }
        return py
    }
}

extension FKYBankListViewController : UITableViewDataSource,UITableViewDelegate {
   func numberOfSections(in tableView: UITableView) -> Int {
        return self.aryLetterIndexForMore.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyLetter:String = self.aryLetterIndexForMore[section]
        return self.bankDicDataForMore[keyLetter]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FKYPopShopListTableViewCell(style: .default, reuseIdentifier: "FKYPopShopListTableViewCell")
        let keyLetter:String = self.aryLetterIndexForMore[indexPath.section]
        let bankModel: FKYBankIndeModel = (self.bankDicDataForMore[keyLetter])![indexPath.row]
        if indexPath.row == bankArr.count-1{
            cell.configPopBankListTableViewCellData(bankModel,true)
        }else {
            cell.configPopBankListTableViewCellData(bankModel,false)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WH(44)
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        let arr = self.aryLetterIndexForMore.filter { $0 != ""}
        return  arr
        
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        self.totastLabel.isHidden = false
//        self.totastLabel.text = title
//        self.hideToatLabel()
        return self.aryLetterIndexForMore.index(of: title) ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView ()
        headView.backgroundColor = RGBColor(0xF4F4F4)
        
        let titleLabel = UILabel ()
        titleLabel.font = UIFont.systemFont(ofSize: WH(14))
        titleLabel.textColor = RGBColor(0x666666);
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headView.addSubview(titleLabel)
        let titleStr = self.aryLetterIndexForMore[section]
        
        titleLabel.text = titleStr
        
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(headView).offset(WH(18))
            make.centerY.right.equalTo(headView)
        })
        return headView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showOrHideBankPopView(false)
        if let block = self.closePopView {
            block()
        }
    }
    func hideToatLabel() {
        let deadline = DispatchTime.now() + 1.0 //刷新数据的时候有延迟，所以推后1S刷新
        DispatchQueue.global().asyncAfter(deadline: deadline) {[weak self] in
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.totastLabel.isHidden = true
            }
        }
    }
}

