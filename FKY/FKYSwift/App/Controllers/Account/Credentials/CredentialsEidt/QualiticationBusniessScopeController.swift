//
//  QualiticationBusniessScopeController.swift
//  FKY
//
//  Created by mahui on 2016/11/2.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  经营范围

import Foundation

class QualiticationBusniessScopeController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate {
    
    var collectionView : UICollectionView?
    var navBar : UIView?
    var zzinfoModel : ZZModel?
    var refuseReason: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() -> () {
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
        self.fky_setupTitleLabel("经营范围")
        self.NavigationTitleLabel!.fontTuple = t14
        self.fky_hiddedBottomLine(false)
        collectionView = {
            let layout = UICollectionViewFlowLayout.init()
            layout.itemSize = CGSize(width: SCREEN_WIDTH / 2, height: WH(45))
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
            self.view.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.equalTo(self.navBar!.snp.bottom)
                make.left.right.bottom.equalTo(self.view)
            })
            view.register(BusinessScopeCell.self, forCellWithReuseIdentifier: "BusinessScopeCell")
            view.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView")
            view.register(CredentialsRefuseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CredentialsRefuseHeaderView")
            view.backgroundColor = bg2
            view.delegate = self

            view.dataSource = self
            return view
        }()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if zzinfoModel != nil && zzinfoModel?.drugScopeList != nil {
            return (zzinfoModel?.drugScopeList?.count)!
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BusinessScopeCell", for: indexPath) as! BusinessScopeCell
        
        if zzinfoModel != nil && zzinfoModel?.drugScopeList != nil {
            
            let drug = (zzinfoModel?.drugScopeList![indexPath.row])! as DrugScopeModel
            cell.configCell(drug.drugScopeName, selected: drug.selected,hidRightLine: (indexPath.row % 2 != 0))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: SCREEN_WIDTH / 2, height: WH(45))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.refuseReason != nil {
            let height = self.refuseReason!.heightForRefuseReason() + h8 + h1
            return CGSize(width: SCREEN_WIDTH,height: height)
        }
        return CGSize(width: SCREEN_WIDTH, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView", for: indexPath) as! CredentialsRefuseHeaderView
            v.configCell("拒绝原因:", content: self.refuseReason)
            v.backgroundColor = bg1
            return v
        }else{
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CredentialsRefuseHeaderView", for: indexPath) as! CredentialsRefuseHeaderView
            return v
        }
    }
    
}
