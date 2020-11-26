//
//  CredentialsBusinessScopeController.swift
//  FKY
//
//  Created by yangyouyong on 2016/11/3.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  选择经营范围

import UIKit

// MARK: - 经营范围
typealias DrugScopeSaveClosure = ([DrugScopeModel]?)->()

class CredentialsBusinessScopeController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout  {
    
    //MARK: Private Property
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(BusinessScopeCell.self, forCellWithReuseIdentifier: "BusinessScopeCell")
        cv.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView")
        cv.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CredentialsRefuseHeaderView")
        cv.backgroundColor = bg2
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    fileprivate var navBar: UIView?
    fileprivate var rightBar: UIButton?
    fileprivate var titleArray: [String] = ["订单起售金额","卖方销售区域"]
    fileprivate var salesDestrictProvider: CredentialsBaseInfoProvider = CredentialsBaseInfoProvider()
    
    fileprivate lazy var viewTips: FKYTipsUIView = {
        let view: FKYTipsUIView = FKYTipsUIView(frame: CGRect.zero)
        return view
    }()
    
    var saveClosure: DrugScopeSaveClosure?
    var refuseReason: String = ""
    var selectedScopes: [DrugScopeModel]? {
        willSet{
            self.salesDestrictProvider.inputBaseInfo.drugScopeList = newValue
        }
    }
    //MARK: Private Method
    fileprivate func getServiceData(){
        //
        showLoading()
        salesDestrictProvider.getDrugScope {[weak self] in
            if let strongSelf = self {
                strongSelf.dismissLoading()
                strongSelf.collectionView.reloadData()
            }
        }
    }
    
    //MARK: Life Cycle
    func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
            }else{
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar?.backgroundColor = bg1
        self.fky_setupTitleLabel("选择经营范围")
        self.fky_hiddedBottomLine(false)
        self.fky_setupLeftImage("icon_back_new_red_normal"){
            FKYNavigator.shared().pop()
        }
        self.fky_setupRightImage("") { [weak self] in
            guard let strongSelf = self else {
                return
            }
            // 保存
            if let closure = strongSelf.saveClosure {
                let selectedScopes = strongSelf.salesDestrictProvider.drugScopes?.filter({ (e) -> Bool in
                    return e.selected
                })
                
                closure(selectedScopes)
            }
            
            FKYNavigator.shared().pop()
        }
        self.NavigationBarRightImage!.setTitle("保存", for: UIControl.State())
        self.NavigationBarRightImage!.fontTuple = t19
        self.fky_hiddedBottomLine(false)
        
        viewTips.setTipsContent(self.refuseReason, numberOfLines: 0)
        self.view.addSubview(viewTips)
        viewTips.snp.makeConstraints { (make) in
            make.top.equalTo(self.navBar!.snp.bottom)
            make.leading.trailing.equalTo(self.view)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(viewTips.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        })
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        getServiceData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: CollectionViewDelegate&DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.salesDestrictProvider.drugScopes!.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessScopeCell", for: indexPath) as! BusinessScopeCell
        let scopeModel = self.salesDestrictProvider.drugScopes![indexPath.row]
        cell.configCell(scopeModel.drugScopeName, selected: scopeModel.selected,hidRightLine: (indexPath.row % 2 != 0))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH/2.0, height: WH(45))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scopeModel = self.salesDestrictProvider.drugScopes![indexPath.row]
        scopeModel.selected = !scopeModel.selected
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
