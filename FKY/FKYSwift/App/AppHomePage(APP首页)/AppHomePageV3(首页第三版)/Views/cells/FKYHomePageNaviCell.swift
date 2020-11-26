//
//  FKYHomePageNaviCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageNaviCell: UITableViewCell {

    
    /// 导航item点击
    static let naviItemClicked = "FKYHomePageNaviCell-naviItemClicked"
    
    // 容器视图
    var containerView = UIView()
    
    lazy var naviCollection:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = false
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(FKYHomePageNaviItem.self, forCellWithReuseIdentifier: NSStringFromClass(FKYHomePageNaviItem.self))
        return collection
    }()
    
    var cellData:FKYHomePageV3CellModel = FKYHomePageV3CellModel()
    
    var naviCollectionHeight = WH(77)
    
    var pageControlView:FKYHomePageNaviPageControlView = FKYHomePageNaviPageControlView()
    
    var naviList:[FKYHomePageV3ItemModel] = [FKYHomePageV3ItemModel]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - 数据显示
extension FKYHomePageNaviCell{
    /*
    func showTestData(){
        self.naviList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19"]
        self.naviList = ["0","1","2","3"]
        self.configCellData(naviList: self.naviList)
    }
    */
    func configCell(cellData:FKYHomePageV3CellModel){
        self.cellData = cellData
        configCellData(naviList: self.cellData.cellModel.contents.Navigation)
        if self.cellData.cellDisplayType == .haveBackImageType{
            pageControlView.configDisplayType(type: 1)
        }else if cellData.cellDisplayType == .normalType{
            pageControlView.configDisplayType(type: 2)
        }
    }
    
    func configCellData(naviList:[FKYHomePageV3ItemModel]){
        self.naviList = naviList
        var pageControlHeight:CGFloat = 0
        
        /// 请勿改变这个约束更新的代码顺序，否则可能会出UI现展示不符合需求的情况
        naviCollection.snp_updateConstraints { (make) in
            make.height.equalTo(self.getNaviCollectionHeight())
        }
        
        if self.naviList.count <= 5 {
            //self.pageControlView.isHidden = true
        }else if self.naviList.count > 5,self.naviList.count < 10 {
            // 凑整，好翻页
            // 产品要求去除翻页逻辑
            /*
            for _ in 0..<10-naviList.count {
                self.naviList.append(FKYHomePageV3ItemModel())
            }
            */
            //self.pageControlView.isHidden = false
            pageControlHeight = WH(5)
        }else if self.naviList.count >= 10 {
            // 调整item顺序
            let pageSize = 10
            var totlePage:Int = self.naviList.count/10
            if self.naviList.count%10>0 {
                totlePage+=1
            }
            // 先凑成10的整数
            let totleCount = totlePage*pageSize
            for _ in 0..<totleCount-naviList.count {
                self.naviList.append(FKYHomePageV3ItemModel())
            }
            var tempList2:[FKYHomePageV3ItemModel] = [FKYHomePageV3ItemModel]()
            _ = stride(from: 0, to: self.naviList.count, by: pageSize).map {
                let temp1 = self.naviList[$0...$0+(pageSize-1)]
                var temp2:[FKYHomePageV3ItemModel] = [FKYHomePageV3ItemModel]()
                _ = temp1.filter({ (item) -> Bool in
                    temp2.append(item)
                    return true
                })
                /*
                _ = temp1.filter { (str) -> Bool in
                    temp2.append(str)
                    return true
                }
                */
                for index in 0..<Int(temp2.count/2) {
                    tempList2.append(temp2[index])
                    tempList2.append(temp2[index+Int(pageSize/2)])
                }
            }
            
            self.naviList.removeAll()
            self.naviList.append(contentsOf: tempList2)
            self.pageControlView.isHidden = false
            if self.naviList.count == 10{
                pageControlHeight = WH(0)
            }else{
                pageControlHeight = WH(5)
            }
        }
        pageControlView.snp_updateConstraints { (make) in
            make.height.equalTo(pageControlHeight)
        }
        self.naviCollection.reloadData()
    }
}

//MARK: - 私有方法
extension FKYHomePageNaviCell{
    func getNaviCollectionHeight() -> CGFloat{
        if self.naviList.count <= 5 {
            return WH(70)
        }else if self.naviList.count > 5,self.naviList.count < 10 {
            return WH(70)
        }else if self.naviList.count >= 10 {
            return WH(160)
        }
        return WH(80)
    }
    
    /// 计算当前页码
    func calculatIndex(scrollView:UIScrollView) -> Int{
        return Int(scrollView.contentOffset.x/(SCREEN_WIDTH-WH(20)-WH(10)))
    }
}

//MARK: - UICollectionView代理
extension FKYHomePageNaviCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.naviList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FKYHomePageNaviItem.self), for: indexPath) as! FKYHomePageNaviItem
        item.configItemData(itemModel: self.naviList[indexPath.row])
        if cellData.cellDisplayType == .haveBackImageType{
            item.configDisplayStyle(type: 1)
        }else if cellData.cellDisplayType == .normalType{
            item.configDisplayStyle(type: 2)
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WH(64), height: WH(70))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return WH(7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return WH(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: WH(0), bottom: 0, right: WH(0))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemData = self.naviList[indexPath.row]
        self.routerEvent(withName: FKYHomePageNaviCell.naviItemClicked, userInfo: [FKYUserParameterKey:["index":indexPath.row,"itemData":itemData]])
    }
    
}

//MARK: - Scroll代理
extension FKYHomePageNaviCell:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetPoint = scrollView.contentOffset.x / (scrollView.contentSize.width - (SCREEN_WIDTH - WH(10) - WH(10)))
        pageControlView.moveToPoint(point: offsetPoint)
    }
    
    /*(
    /// 停止拖拽
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pageControlView.swichToIndex(index: self.calculatIndex(scrollView: scrollView)+1)
    }

    // 停止惯性
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControlView.swichToIndex(index: self.calculatIndex(scrollView: scrollView)+1)
    }
    */
}


//MARK: - UI
extension FKYHomePageNaviCell{
    func setupUI(){
        backgroundColor = .clear
        selectionStyle = .none
        //containerView.layer.cornerRadius = WH(8)
        //containerView.layer.masksToBounds = true
        //containerView.backgroundColor = RGBColor(0xFFFFFF)
        containerView.backgroundColor = .clear
        contentView.addSubview(containerView)
        
        containerView.addSubview(self.naviCollection)
        containerView.addSubview(self.pageControlView)
        /*
        contentView.addSubview(self.naviCollection)
        contentView.addSubview(self.pageControlView)
        */
        containerView.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
            make.top.equalToSuperview().offset(WH(0))
            make.bottom.equalToSuperview().offset(WH(-8))
        }
        
        self.naviCollection.snp_makeConstraints { (make) in
            make.left.equalToSuperview().offset(WH(0))
            make.right.equalToSuperview().offset(WH(0))
            make.top.equalToSuperview().offset(WH(8))
            //make.bottom.equalTo(pageControlView.snp_top).offset(WH(-10))
            make.bottom.equalToSuperview().offset(WH(-10))
            make.height.equalTo(WH(77))
        }
        
        self.pageControlView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(WH(5))
            //make.top.equalTo(self.naviCollection.snp_bottom).offset(WH(0))
        }
    }
    
    override func configCellDisplayInfo() {
        super.configCellDisplayInfo()
        //containerView.setRoundedCorners(UIRectCorner.allCorners, radius: WH(8))
        
    }
}
