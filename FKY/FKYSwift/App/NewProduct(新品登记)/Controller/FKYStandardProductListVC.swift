//
//  FKYStandardProductListVCViewController.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
// 标品

import UIKit

class FKYStandardProductListVC: UIViewController {

    ///viewModel
    var viewModel = FKYStandardProductListViewModel()
    
    /// 搜索的条码
    var barcode = ""
    /// 当前是否有选中的标品
//    var isHaveSelectedProduct = false
    /// 选中标品后的回调
    var selectProductCallBack:((_ selectBank : FKYStandardProductModel ) -> ())?
    
    /// 容器视图
    var containerView:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xFFFFFF)
        return view
    }()
    
    /// 头部视图
    lazy var headerView:UIView = {
        let view = UIView()
        return view
    }()
    
    /// 头部分割线
    lazy var headerMarginLine:UIView = {
        let view = UIView()
        view.backgroundColor = RGBColor(0xE5E5E5)
        return view
    }()
    /// 标题文字
    lazy var titleLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = RGBColor(0x000000)
        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
        lb.text = "选择品种"
        return lb
    }()
    
    /// 退出按钮
    lazy var dismissButton:UIButton = {
        let bt = UIButton()
        bt.setBackgroundImage(UIImage(named:"btn_pd_group_close"), for: .normal)
        bt.addTarget(self, action: #selector(FKYStandardProductListVC.dismissButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    /// 确定按钮
    lazy var confirmButton:UIButton = {
        let bt = UIButton()
        bt.setTitle("确定", for: .normal)
        bt.setTitleColor(RGBColor(0xFFFFFF), for: .normal)
        bt.layer.cornerRadius = WH(4)
        bt.layer.masksToBounds = true
        bt.backgroundColor = RGBColor(0xFF2D5C)
        bt.addTarget(self, action: #selector(FKYStandardProductListVC.confirmButtonClicked), for: .touchUpInside)
        return bt
    }()
    
    /// mainTableView
    lazy var mainTableView:UITableView = {
        let tableV = UITableView(frame: CGRect.null, style: .grouped)
        tableV.backgroundColor = RGBColor(0xFFFFFF)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.showsVerticalScrollIndicator = false
        tableV.bounces = false
        tableV.estimatedRowHeight = WH(300) //最多
        tableV.rowHeight = UITableView.automaticDimension // 设置高度自适应
        tableV.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableV.register(FKYNewProductRegisterProductInfoCell.self, forCellReuseIdentifier: NSStringFromClass(FKYNewProductRegisterProductInfoCell.self ))
        if #available(iOS 11, *) {
            tableV.contentInsetAdjustmentBehavior = .never
        }
        return tableV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.requestProductList()
//        self.updataSubmitButtonStatus()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.popView()
    }
    
    deinit {
        print("FKYStandardProductListVC deinit~!@")
    }

}

//MARK: - 事件响应
extension FKYStandardProductListVC{
    
    /// 退出按钮点击
    @objc func dismissButtonClicked(){
        self.dismissView()
        
    }
    
    /// 确定按钮点击
    @objc func confirmButtonClicked(){
        if let callBack = self.selectProductCallBack {
            var isHaveChoose = false
            var productModel = FKYStandardProductModel()
            for cellModel in self.viewModel.cellModelList {
                if cellModel.isSelected{
                    productModel = cellModel.product
                    isHaveChoose = true
                }
            }
            if isHaveChoose == false{
                self.toast("请选择商品！")
                return
            }
            callBack(productModel)
            self.dismissView()
        }
    }
}

//MARK: - UI
extension FKYStandardProductListVC{
    
    func setupUI(){
        
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.view.addSubview(self.containerView)
        
        self.containerView.addSubview(self.headerView)
        self.containerView.addSubview(self.mainTableView)
        self.containerView.addSubview(self.confirmButton)
        
        self.headerView.addSubview(self.titleLabel)
        self.headerView.addSubview(self.dismissButton)
        self.headerView.addSubview(self.headerMarginLine)
        
        self.containerView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.snp_bottom)
        }
        
        self.headerView.snp_makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(WH(56))
        }
        
        self.mainTableView.snp_makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp_bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(WH(297))
        }
        
        self.confirmButton.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mainTableView.snp_bottom)
            make.width.equalTo(WH(315))
            make.height.equalTo(WH(42))
            make.bottom.equalToSuperview().offset((WH(-27)))
        }
        
        self.titleLabel.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.dismissButton.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(WH(-10))
            make.width.height.equalTo(WH(30))
        }
        
        self.headerMarginLine.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
//    func updataSubmitButtonStatus(){
//        if self.isHaveSelectedProduct {
//            self.confirmButton.isUserInteractionEnabled = true
//            self.confirmButton.backgroundColor = RGBColor(0xFF2D5C)
//        }else{
//            self.confirmButton.isUserInteractionEnabled = false
//            self.confirmButton.backgroundColor = .gray
//        }
//    }
    
    ///弹出银行选择界面
    func popView(){
        var height:CGFloat = 0
        self.view.layoutIfNeeded()
        height += self.headerView.hd_height
        height += self.mainTableView.hd_height
        height += self.confirmButton.hd_height
        height += WH(27)
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.containerView.transform = CGAffineTransform(translationX: 0, y:-height);//xy移动距离;
            strongSelf.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }) { (isComplete) in
            
        }
    }
    
    ///移除选择界面
    func dismissView(){
        var height:CGFloat = 0
        self.view.layoutIfNeeded()
        height += self.headerView.hd_height
        height += self.mainTableView.hd_height
        height += self.confirmButton.hd_height
        height += WH(27)
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.containerView.transform = .identity
            strongSelf.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) {[weak self] (isComplete) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dismiss(animated: false) {
                
            }
        }
    }
}

//MARK: - TableViewDelegate & DataSource
extension FKYStandardProductListVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cellModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(FKYNewProductRegisterProductInfoCell.self)) as! FKYNewProductRegisterProductInfoCell
        let cellModel = self.viewModel.cellModelList[indexPath.row]
        cell.showStandarProduct(cellModel:cellModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = self.viewModel.cellModelList[indexPath.row]
        var haveSelected = false
        for model in self.viewModel.cellModelList {
            if model == cellModel {
                model.isSelected = !model.isSelected
            }else{
                model.isSelected = false
            }
            if model.isSelected {
                haveSelected = true
            }
        }
//        self.isHaveSelectedProduct = haveSelected
//        self.updataSubmitButtonStatus()
        self.mainTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - 网络请求
extension FKYStandardProductListVC{
    
}

//MARK: - 网络请求
extension FKYStandardProductListVC{
    
    func requestProductList(){
        let param = ["barcode":self.barcode]
        self.viewModel.requestStandardProductList(param: param as [String:AnyObject]) { (isSuccess, Msg) in
            guard isSuccess else{
                self.toast(Msg)
                return
            }
            self.mainTableView.reloadData()
        }
    }
}
