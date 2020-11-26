//
//  CredentialsEnterpriseTypeController.swift
//  FKY
//
//  Created by yangyouyong on 2016/10/31.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  (填写基本信息之)企业类型

import UIKit

typealias EnterpriseTypeSaveClosure = (EnterpriseTypeModel?)->(Void)

class CredentialsEnterpriseTypeController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    //MARK: - Property
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(EnterpriseTypeCell.self, forCellWithReuseIdentifier: "EnterpriseTypeCell")
        cv.backgroundColor = bg2
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    fileprivate lazy var viewTips: FKYTipsUIView = {
        let view: FKYTipsUIView = FKYTipsUIView(frame: CGRect.zero)
        view.setTipsContent("特别提示：企业类型一定要和您的营业执照上面一致，如果不一致，客户会审核不通过哦", numberOfLines: 2)
        return view
    }()
    
    fileprivate var navBar: UIView?
    fileprivate var provider: CredentialsBaseInfoProvider = CredentialsBaseInfoProvider()
    var saveClosure: EnterpriseTypeSaveClosure?
    var selectedSecondTitle: [String] = [String]()
    var selectedEnterpriseType: EnterpriseTypeModel?
    
    // 3.7.1 added by xiazhiyong feature:修改企业类型
    var changeEnterpriseType = false // 默认不是修改企业类型流程
    var AllEnterpriseType: [EnterpriseTypeModel]? // 若为修改企业类型流程，则当前数组保存用户可选择的所有企业类型
    
    
    //MARK: - Life Cylce
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.provider.enterpriseType = selectedEnterpriseType
        
        if self.changeEnterpriseType {
            // 修改企业类型
            showRollType4Change()
        }
        else {
            // 选择企业类型
            getRollType()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar?.backgroundColor = bg1
        self.fky_setupTitleLabel("企业类型")
        self.fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        self.fky_hiddedBottomLine(false)
        
        self.view.addSubview(viewTips)
        viewTips.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.leading.trailing.equalTo(self.view)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(viewTips.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
    }
    
    
    //MARK: - Private
    
    @objc fileprivate func callBackSelectedEnterpriseType(_ enterpriseTypeModel: EnterpriseTypeModel?) {
        if let saveClosure = self.saveClosure {
            saveClosure(self.selectedEnterpriseType)
        }
        FKYNavigator.shared().topNavigationController.popViewController(animated: true)
    }
    
    // 获取企业类型数据
    fileprivate func getRollType() {
        self.showLoading()
        provider.getRollType {[weak self] in
            if let strongSelf = self {
                if let selectedEnterprise = strongSelf.selectedEnterpriseType {
                    if let enterpriseModel = (strongSelf.provider.enterpriseArray as NSArray).filtered(using: NSPredicate(format: "paramName = '\(selectedEnterprise.paramName)'")).first as? EnterpriseTypeModel {
                        enterpriseModel.selected = true
                    }
                }
                strongSelf.collectionView.reloadData()
                strongSelf.dismissLoading()
            }
        }
    }
    
    // 展示用户可修改的企业类型数据
    fileprivate func showRollType4Change() {
        if AllEnterpriseType != nil && AllEnterpriseType?.isEmpty == false {
            if let selectedEnterprise = self.selectedEnterpriseType {
                if let enterpriseModel = (self.AllEnterpriseType! as NSArray).filtered(using: NSPredicate(format: "paramName = '\(selectedEnterprise.paramName)'")).first as? EnterpriseTypeModel {
                    enterpriseModel.selected = true
                }
            }
            
            provider.enterpriseArray = AllEnterpriseType!
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - CollectionViewDelegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.provider.enterpriseArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EnterpriseTypeCell", for: indexPath) as! EnterpriseTypeCell
        let model = self.provider.enterpriseArray[indexPath.row]
        cell.configCell(model.paramName, selected: model.selected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: WH(45))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // start 3.5.1 企业类型合并成只有一级的队列,而且是单选
        self.provider.enterpriseArray.forEach { (enterpriseTypeModel) in
            enterpriseTypeModel.selected = false
        }
        self.selectedEnterpriseType = self.provider.enterpriseArray[indexPath.row]
        self.selectedEnterpriseType?.selected = true;
        collectionView.reloadData()
        callBackSelectedEnterpriseType(self.selectedEnterpriseType)
    }
}
