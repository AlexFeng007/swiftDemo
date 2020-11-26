//
//  AcountToolsListCell.swift
//  FKY
//
//  Created by 寒山 on 2020/6/2.
//  Copyright © 2020 yiyaowang. All rights reserved.
//  个人中心工具列表

import UIKit

class AcountToolsListCell: UITableViewCell  {
    var clickToolsListAction : ((_ toolModel: AccountToolsModel?,_ index:Int)->())? //点击工具栏
    var tools: [AccountToolsModel] = [] // 工具栏列表
    var isNotPerfectInformation = true // 未完善资料标记
    //背景
    fileprivate lazy var contentBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = WH(6)
        view.layer.masksToBounds = true
        return view
    }()
    
    //类型列表
    fileprivate lazy var bottomView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        // 设置item的大小
        flowLayout.itemSize = CGSize(width:(SCREEN_WIDTH - WH(32))/4.0 - 0.5, height:WH(75.75))
        //        // 设置滚动的方向
        flowLayout.scrollDirection = .vertical
        //        // 设置同一组当中，行与行之间的最小行间距
        flowLayout.minimumLineSpacing = WH(0)
        //        // 设置同一行的cell中互相之间的最小间隔
        flowLayout.minimumInteritemSpacing = WH(0)
        //        // 设置section距离边距的距离
        //        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: WH(0), bottom: 0, right: WH(0))
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.register(AccountToolCell.self, forCellWithReuseIdentifier: "AccountToolCell")
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = false
        view.delegate = self
        view.dataSource = self
        if #available(iOS 11, *) {
            let insets = UIApplication.shared.delegate?.window??.safeAreaInsets
            if (insets?.bottom)! > CGFloat.init(0) { // iPhone X
                view.contentInsetAdjustmentBehavior = .never
                view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                view.scrollIndicatorInsets = view.contentInset
            }
        }
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(contentBgView)
        contentBgView.addSubview(bottomView)
        
        contentBgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(WH(16))
            make.right.equalTo(contentView).offset(WH(-16))
            make.bottom.equalTo(contentView).offset(WH(-10))
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(contentBgView)
        }
    }
    func configCell(_ userInfoModel:AccountInfoModel?, _ isNotPerfectInformation:Bool) {
        self.tools.removeAll()
        self.isNotPerfectInformation = isNotPerfectInformation
        if let model = userInfoModel {
            if let toolList = model.tools,toolList.isEmpty == false{
                self.tools = toolList
            }
        }
        bottomView.reloadData()
    }
}
extension  AcountToolsListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //返回CollectionView有多少分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:(SCREEN_WIDTH - WH(32))/4.0 - 0.5, height:WH(75.75))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: WH(0), left: WH(0), bottom: WH(0), right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountToolCell", for: indexPath) as!  AccountToolCell
        if self.tools.count > indexPath.row{
            let toolModel = self.tools[indexPath.row]
            cell.configCell(toolModel,self.isNotPerfectInformation)
        }else{
            cell.configCell(nil,true)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.tools.count > indexPath.row{
            let toolModel = self.tools[indexPath.row]
            if let block = self.clickToolsListAction{
                block(toolModel,indexPath.row + 1)
            }
        }else{
            if let block = self.clickToolsListAction{
                block(nil,indexPath.row + 1)
            }
        }
    }
}
extension  AcountToolsListCell{
    //计算高度
    static func configAccountToolsCellH(_ userInfoModel:AccountInfoModel?) -> CGFloat{
        var baseW = WH(0)
        if let model = userInfoModel {
            if let toolList = model.tools,toolList.isEmpty == false{
                let picNum = toolList.count
                var lineNum = picNum/4
                if picNum % 4 != 0 {
                    lineNum = lineNum + 1
                }
                baseW = baseW + CGFloat(lineNum)*(WH(75.75)) + WH(7)
            }
        }
        return baseW + WH(10)
        
    }
}

class AccountToolCell: UICollectionViewCell {
    //icon图片
    fileprivate var orderTypeIcon: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    //cell title
    fileprivate var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: WH(12))
        label.textColor = RGBColor(0x333333)
        return label
    }()
    
    fileprivate var tagView: AccountTagView = {
        let tagView =  AccountTagView()
        return tagView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(orderTypeIcon)
        contentView.addSubview(typeLabel)
        contentView.addSubview(tagView)
        orderTypeIcon.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(WH(16))
            make.height.width.equalTo(WH(30))
            make.centerX.equalTo(contentView)
        }
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderTypeIcon.snp.bottom).offset(WH(10))
            make.centerX.equalTo(contentView)
        }
        tagView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(WH(6))
            make.left.equalTo(orderTypeIcon.snp.left).offset(WH(23))
            make.height.equalTo(WH(15))
            make.width.equalTo(WH(29))
        }
    }
    func configCell(_ toolModel:AccountToolsModel?,_ isNotPerfectInformation:Bool) {
        if let model = toolModel{
            orderTypeIcon.isHidden = false
            if let strProductPicUrl = (model.imgPath ?? "").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
                orderTypeIcon.sd_setImage(with: urlProductPic , placeholderImage: nil)
            }
            typeLabel.text = (model.title ?? "")
            if isNotPerfectInformation == true && (model.jumpInfo ?? "").hasPrefix("fky://account/dataManage"){
                tagView.configTagView("待完善")
                tagView.isHidden = false
                tagView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(17))
                    make.width.equalTo(WH(36))
                }
            }else if let qualificationExpiredDesc = model.qualificationExpiredDesc ,qualificationExpiredDesc.isEmpty == false ,(model.jumpInfo ?? "").hasPrefix("fky://account/dataManage"){
                //资质过期或者即将过期提醒
                tagView.configTagView(model.qualificationExpiredDesc ?? "")
                tagView.isHidden = false
                tagView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(17))
                    make.width.equalTo(WH(36))
                }
            } else{
                tagView.configTagView("NEW")
                
                var isNew = false
                let newKey = "(tools_\(model.toolId ?? "")_isNew)"
                
                if  UserDefaults.standard.value(forKey: newKey) != nil{
                    if let newFlag = UserDefaults.standard.value(forKey: newKey) as? Bool{
                        isNew = newFlag
                    }else{
                        isNew = (model.newToolFlag ?? 0) == 1
                        UserDefaults.standard.set(isNew, forKey: newKey)
                        UserDefaults.standard.synchronize()
                    }
                }else{
                    isNew = (model.newToolFlag ?? 0) == 1
                    UserDefaults.standard.set(isNew, forKey: newKey)
                    UserDefaults.standard.synchronize()
                }
 
                tagView.isHidden = !isNew
                tagView.snp.updateConstraints { (make) in
                    make.height.equalTo(WH(15))
                    make.width.equalTo(WH(29))
                }
            }
           
        }
    }
    
}
