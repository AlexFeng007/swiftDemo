//
//  CredentialsBusinessScopeForBaseInfoController.swift
//  FKY
//
//  Created by airWen on 2017/5/25.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//  (填写基本信息之)选择经营范围

import UIKit

//基本资料的经营范围页

class CredentialsBusinessScopeForBaseInfoController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - Property
    
    fileprivate var navBar: UIView?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: SCREEN_WIDTH/2.0, height: WH(55))
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(BusinessScopeCell.self, forCellWithReuseIdentifier: "BusinessScopeCell")
        cv.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView")
        cv.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CredentialsRefuseHeaderView")
        cv.backgroundColor = bg2
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    fileprivate lazy var viewTips: FKYTipsUIView = {
        let view: FKYTipsUIView = FKYTipsUIView(frame: CGRect.zero)
        //view.setTipsContent("已经为您选择了常用经营范围，如不准确您可以继续修改", numberOfLines: 0)
        view.setTipsContent("请严格根据药品经营许可证、食品经营许可证（如有）、二类医疗器械经营备案凭证（如有）、三类医疗器械经营许可证（如有）勾选经营范围，否则卖家会拒绝为您发货。", numberOfLines: 0)
        return view
    }()
    
    // 保存原始的用户选项，用来判断是否有修改
    fileprivate var originSelectedScopeIds: [String]?
    // 用于本地实时勾选更新的临时列表
    fileprivate var listTemp: [DrugScopeModel] = []
    // 上个界面传来的经营范围列表
    var drugScopes: [DrugScopeModel] = [] {
        didSet {
            self.listTemp.removeAll()
            for item in drugScopes {
                let obj = DrugScopeModel(drugScopeId: item.drugScopeId, drugScopeName: item.drugScopeName, selected: item.selected)
                self.listTemp.append(obj)
                self.collectionView.reloadData()
            } // for
        }
    }
    // 保存操作回调blokc
    var saveClosure: DrugScopeSaveClosure?
    
    
    //MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        saveOriginalSelectedString()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - UI
    
    fileprivate func setupView() {
        self.navBar = {
            if let _ = self.NavigationBar {
                //
            }
            else {
                self.fky_setupNavBar()
            }
            return self.NavigationBar!
        }()
        self.navBar?.backgroundColor = bg1
        self.fky_setupTitleLabel("选择经营范围")
        self.fky_hiddedBottomLine(false)
        
        // 返回
        self.fky_setupLeftImage("icon_back_new_red_normal"){ [weak self] in
            guard let strongSelf = self else {
                return
            }
            if strongSelf.isChageChoose() {
                // 有修改
                FKYProductAlertView.show(withTitle: nil, leftTitle: "取消", rightTitle: "确定", message: "您更改的信息还未保存，确定返回？", handler: { (alertView, isRight) in
                    if isRight {
                        FKYNavigator.shared().pop()
                    }
                })
            }
            else {
                // 未修改
                FKYNavigator.shared().pop()
            }
        }
        
        // 保存
        self.fky_setupRightImage("") {
            if let closure = self.saveClosure {
                // 保存选中的
                self.saveSelectedStatus()
                // 只返回选中的
                let selectedScopes = self.drugScopes.filter({ (e) -> Bool in
                    return e.selected
                })
                closure(selectedScopes)
            }
            FKYNavigator.shared().pop()
        }
        self.NavigationBarRightImage!.setTitle("保存", for: UIControl.State())
        self.NavigationBarRightImage!.fontTuple = t19
        self.NavigationBarRightImage!.setTitleColor(UIColor.init(red: 113.0/255, green: 0, blue: 0, alpha: 1), for: .highlighted)
        self.fky_hiddedBottomLine(false)
        
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
        collectionView.reloadData()
    }
    
    
    //MARK: - Private
    
    // 保存原始的选中状态...<用于判断返回时有无修改>
    fileprivate func saveOriginalSelectedString() {
        // 遍历
        if let originSelectedScope = (drugScopes as NSArray).filtered(using: NSPredicate(format: "selected==\(true)")) as? [DrugScopeModel] {
            // 保存
            originSelectedScopeIds = (originSelectedScope as NSArray).value(forKeyPath: "drugScopeId") as? [String]
        }
    }
    
    // 保存用户选择
    fileprivate func saveSelectedStatus() {
        guard drugScopes.count == listTemp.count else {
            return
        }
        for index in 0..<drugScopes.count {
            let item = drugScopes[index]
            let itemTemp = listTemp[index]
            item.selected = itemTemp.selected
        } // for
    }
    
    // 判断是否有修改
    fileprivate func isChageChoose() -> Bool {
        // 获取所有选中项
        if let currentSelectedScopes = (listTemp as NSArray).filtered(using: NSPredicate(format: "selected==\(true)")) as? [DrugScopeModel] {
            // 当前有选中项
            if let currentSelectedScopesIds = (currentSelectedScopes as NSArray).value(forKeyPath: "drugScopeId") as? [String] {
                // 选中项id
                if let originSelected = originSelectedScopeIds {
                    return !(currentSelectedScopesIds == originSelected)
                }
                else {
                    if currentSelectedScopesIds.count > 0 {
                        return true
                    }
                    else {
                        return false
                    }
                }
            }
            else {
                //
                if let originSelected = originSelectedScopeIds {
                    if originSelected.count > 0 {
                        return true
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
            }
        }
        else {
            // 当前无选中项
            if let originSelected = originSelectedScopeIds {
                if originSelected.count > 0 {
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
    }
    
    
    // MARK: - CollectionViewDelegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listTemp.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessScopeCell", for: indexPath) as! BusinessScopeCell
        let scopeModel = listTemp[indexPath.row]
        cell.configCell(scopeModel.drugScopeName, selected: scopeModel.selected, hidRightLine: (indexPath.row % 2 != 0))
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        return CGSize(width: SCREEN_WIDTH/2.0, height: WH(55))
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView", for: indexPath) as! CredentialsRefuseHeaderView
            v.backgroundColor = bg1
            return v
        }else{
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView", for: indexPath) as! CredentialsRefuseHeaderView
            return v
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scopeModel = listTemp[indexPath.row]
        scopeModel.selected = !scopeModel.selected
        self.collectionView.reloadData()
    }
}
