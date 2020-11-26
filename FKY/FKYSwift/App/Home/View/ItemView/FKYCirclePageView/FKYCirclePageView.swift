//
//  FKYCirclePageView.swift
//  FKY
//
//  Created by 夏志勇 on 2018/2/3.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//  (首页)轮播视图（无限轮播banner）

import UIKit

// closure别名
typealias JumpToBannerDetailClosure = (Int, Any?)->()


class FKYCirclePageView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    /// 轮播图item点击事件
    static let itemClicked:String = "FKYCirclePageView-itemClicked"
    
    /// 轮播图item切换
    static let itemScrollSwitch:String = "FKYCirclePageView-itemScrollSwitch"
    
    // MARK: - Property
    // closure
    var bannerDetailCallback: JumpToBannerDetailClosure? // 查看活动详情
    
    fileprivate lazy var imgviewPlacehold: UIImageView! = {
        let view = UIImageView.init(frame: CGRect.zero)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    fileprivate lazy var collectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        //layout.itemSize = CGSize(width: SCREEN_WIDTH, height: WH(160))
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.isUserInteractionEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.register(FKYCirclePageCCell.self, forCellWithReuseIdentifier: "FKYCirclePageCCell")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = WH(4.0)
        return view
    }()
    
    fileprivate lazy var pageControl: NewCirclePageControl = {
        let view = NewCirclePageControl.init(frame: CGRect.zero)
        view.pages = self.imgDataSource.count
        //view.setPageDotsView()
        return view
    }()
    
    /// V3首页修改的page样式
    lazy var pageIndexV3:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.layer.cornerRadius = WH(17/2.0)
        lb.layer.masksToBounds = true
        lb.font = .boldSystemFont(ofSize: WH(12))
        lb.backgroundColor = RGBAColor(0x000000, alpha: 0.4)
        return lb
    }()
    
    // 是否自动滑动
    var autoScroll = true
    
    // 自动滑动间隔时间...<默认3s>
    var autoScrollTimeInterval: TimeInterval = 3
    
    // 是否无限轮播
    var infiniteLoop = true
    
    // 仅有一张图片时，是否无限轮播...<前提是无限轮播开关已开启>
    var infiniteLoopWhenOnlyOne = false
    
    // 分区section大小...<默认5个分区>...<若需要避免用户快速手动滑动至左右两侧时出现图片不连续而呈现空白的情况，可以将maxSecitons设置足够大，如100>
    var maxSecitons = 5
    
    // 轮播定时器
    fileprivate var timer: Timer!
    
    // 数据源
    var bannerModel: HomeCircleBannerModel? //首页传入字段（记录当前的pageIndex）
    // 展示数组
    var imgDataSource = [Any]()
    
    // 判断是否需要使用多分区特性，以便用于无限轮播...<若无限轮播属性关闭，则不使用多分区>
    var needToSetMultiSections: Bool {
        get {
            // 必须有图片
            guard imgDataSource.count > 0 else {
                return false
            }
            // 必须开启自动滑动
            guard autoScroll else {
                return false
            }
            // 必须开启无限轮播
            guard infiniteLoop else {
                return false
            }
            // 只有一张图片
            if imgDataSource.count == 1 {
                // 必须开启一张图片下的无限轮播
                guard infiniteLoopWhenOnlyOne else {
                    return false
                }
            }
            return true
        }
    }
    
    // 当前状态下的分区个数
    var currentTotalSection: Int {
        get {
            if needToSetMultiSections {
                return maxSecitons
            }
            return 1
        }
    }
    
    // 当前图片索引
    var currentPageIndex: Int {
        get {
            var index: Int = Int( (collectionView.contentOffset.x + (SCREEN_WIDTH - WH(20)) * 0.5) / (SCREEN_WIDTH - WH(20)) )
            if imgDataSource.count > 0  {
                index = index % imgDataSource.count
            }
            return max(0, index)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI
    
    func setupView() {
        //backgroundColor = UIColor.white
        backgroundColor = .clear
        
        addSubview(imgviewPlacehold)
        imgviewPlacehold.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(WH(-7.5))
            make.right.equalTo(self).offset(WH(-18))
            make.left.equalTo(self).offset(WH(300))
            make.height.equalTo(WH(4))
        }
        pageControl.isHidden = true
        addSubview(pageIndexV3)
        pageIndexV3.snp_makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(WH(-5))
            make.right.equalToSuperview().offset(WH(-12))
            make.height.equalTo(WH(17))
            make.width.equalTo(WH(45))
        }
    }
    
    
    // MARK: - Public
    
    // 滑动到指定索引处
    func scrollToPageIndex(_ index: Int, _ animated: Bool) {
        if imgDataSource.count > 0, index >= 0, index < imgDataSource.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.collectionView.setContentOffset(CGPoint(x: CGFloat(index)*(SCREEN_WIDTH - WH(20)), y: 0), animated: animated)
                //strongSelf.collectionView.scrollToItem(at: IndexPath.init(row: index, section: strongSelf.currentTotalSection / 2), at: .left, animated: animated)
                strongSelf.pageControl.setCurrectPage(index)
                strongSelf.showIndexPage(currentPage: index)
            }
        }
    }
    
    
    // MARK: - Private
    
    // 设置最终用于显示的数据源
    func configDataSource(_ dataArr:[Any]?) {
        if let arr = dataArr ,arr.count > 0 {
            imgDataSource.removeAll()
            let bannerWidth = WH(17) * 2 + WH(4 + 5) * CGFloat(arr.count - 1)
            pageControl.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self).offset(WH(-7.5))
                make.right.equalTo(self).offset(WH(-8))
                make.left.equalTo(self).offset(SCREEN_WIDTH - WH(10) - bannerWidth)
                make.height.equalTo(WH(4))
            }
            imgDataSource = arr
            pageControl.pages = arr.count
            self.showImageContent()
            self.autoScrollLogic()
        }
    }
    
    // 显示图片内容
    fileprivate func showImageContent() {
        collectionView.reloadData()
        pageControl.pages = imgDataSource.count
        pageControl.setPageDotsView()
        imgviewPlacehold.isHidden = imgDataSource.count > 0 ? true : false
        
        // 必须有图片
        guard imgDataSource.count > 0 else {
            return
        }
        
        // 滑动到中间section
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        // 当前索引
        var index = 0
        if let bModel = self.bannerModel {
            if bModel.pageIndex >= self.imgDataSource.count {
                bModel.pageIndex = 0
            }
            else {
                index = bModel.pageIndex
            }
        }
        pageControl.setCurrectPage(currentPageIndex)
        showIndexPage(currentPage: currentPageIndex)
        self.collectionView.setContentOffset(CGPoint(x: CGFloat(index)*(SCREEN_WIDTH - WH(20)), y: 0), animated: false)
        //self.collectionView.scrollToItem(at: IndexPath.init(row: index, section: self.currentTotalSection / 2), at: .left, animated: false)
        //        }
    }
    
    // 轮播相关
    fileprivate func autoScrollLogic() {
        // 取消timer
        stopAutoScroll()
        
        // 自动滑动属性必须开启，且图片个数必须大于0
        guard autoScroll == true, imgDataSource.count > 0 else {
            return
        }
        
        // 启动timer
        beginAutoScroll()
    }
    
    // 开始轮播
    fileprivate func beginAutoScroll() {
        // 取消timer
        stopAutoScroll()
        // 启动timer
        timer = Timer.init(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(autoScrollAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    // 停止轮播
    fileprivate func stopAutoScroll() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    // 定时器方法
    @objc fileprivate func autoScrollAction() {
        //print("autoScrollAction")
        guard (self.getFirstViewController()) != nil else{
            self.stopAutoScroll()
            return
        }
        
        // 有多分区属性
        if needToSetMultiSections {
            scrollKeyMethod()
        }
        
        // 计算indexpath
        var nextPage = currentPageIndex + 1
        var nextSection = currentTotalSection / 2
        if nextPage >= imgDataSource.count {
            nextPage = 0
            nextSection = nextSection + 1
            if nextSection >= currentTotalSection {
                nextSection = currentTotalSection / 2
            }
        }
        // 滑动到指定索引的图片处
        self.collectionView.setContentOffset(CGPoint(x: CGFloat(nextPage)*(SCREEN_WIDTH - WH(20)), y: 0), animated: true)
      //  collectionView.scrollToItem(at: IndexPath.init(row: nextPage, section: nextSection), at: .left, animated: true)
    }
    
    // 每次 (自动)滑动 or (手动)拖动 结束后均需要执行此方法
    fileprivate func scrollKeyMethod() {
        // 有多分区属性
        if needToSetMultiSections {
            self.collectionView.setContentOffset(CGPoint(x: CGFloat(currentPageIndex)*(SCREEN_WIDTH - WH(20)), y: 0), animated: false)
           // collectionView.scrollToItem(at: IndexPath.init(row: currentPageIndex, section: currentTotalSection / 2), at: .left, animated: false)
        }
    }
    
    // 实时展示当前图片索引
    fileprivate func showPageIndex() {
        // 必须有图片
        guard imgDataSource.count > 0 else {
            return
        }
        
        pageControl.setCurrectPage(currentPageIndex)
        showIndexPage(currentPage: currentPageIndex)
        if let bModel = self.bannerModel {
            bModel.pageIndex = currentPageIndex
        }
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    // 已开始滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //showPageIndex()
    }
    
    // 定时器方法滑动结束后调用此方法
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollKeyMethod()
        showPageIndex()
    }
    
    // 用户手动滑动结束后调用此方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollKeyMethod()
        showPageIndex()
    }
    
    // 用户手动滑动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoScroll == true, imgDataSource.count > 0 {
            stopAutoScroll()
        }
    }
    
    // 用户手动滑动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoScroll == true, imgDataSource.count > 0 {
            beginAutoScroll()
        }
    }
    
    
    // MARK: - UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return currentTotalSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH - WH(20), height: (SCREEN_WIDTH - 20)*110/355.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FKYCirclePageCCell", for: indexPath) as! FKYCirclePageCCell
        if let item = imgDataSource[indexPath.row] as? HomeCircleBannerItemModel {
            cell.configCell(item.imgPath)
        }else if let item = imgDataSource[indexPath.row] as? FKYShopAdArrModel {
            cell.configCell(item.adUrl)
        }else if let item = imgDataSource[indexPath.row] as? FKYHomePageV3ItemModel {
            cell.configCell(item.imgPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let closure = bannerDetailCallback {
            closure(indexPath.row, imgDataSource[indexPath.row])
        }
        if let cellData = imgDataSource[indexPath.row] as? FKYHomePageV3ItemModel{
            
            self.routerEvent(withName: FKYCirclePageView.itemClicked, userInfo: [FKYUserParameterKey:["index":indexPath.row,"cellData":cellData]])
        }
        
    }
}

//MARK: - 数据展示
extension FKYCirclePageView{
    
    /// 显示当前滑动到第几个
    func showIndexPage(currentPage:Int){
        
        let str1 = "\(currentPage+1)/\(imgDataSource.count)"
        let attrStr = NSMutableAttributedString.init(string: str1)
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:RGBColor(0xFFFFFF), range:NSRange.init(location:0, length: "\(currentPage+1)".count))
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:RGBAColor(0xFFFFFF, alpha: 0.5), range:NSRange.init(location:"\(currentPage+1)".count, length:str1.count-"\(currentPage+1)".count))
        pageIndexV3.attributedText = attrStr
        
        routerEvent(withName: FKYCirclePageView.itemScrollSwitch, userInfo: [FKYUserParameterKey:currentPage])
    }
    /*
    func showTestData(){
        let imaList:[String] = ["https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1689053532,4230915864&fm=26&gp=0.jpg",
                                "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1689053532,4230915864&fm=26&gp=0.jpg",
                                "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1689053532,4230915864&fm=26&gp=0.jpg",
                                "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1689053532,4230915864&fm=26&gp=0.jpg",
                                "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1689053532,4230915864&fm=26&gp=0.jpg"]
        var modelList:[HomeCircleBannerItemModel] = [HomeCircleBannerItemModel]()
        for url in imaList {
            let model = HomeCircleBannerItemModel(id: 0, imgPath: url, jumpInfo: "", jumpType: 0, name: "", siteCode: "", type: 0, jumpExpandOne: "", jumpExpandTwo: "", jumpExpandThree: "")
            //model.imgPath = url
            modelList.append(model)
        }
        self.configDataSource(modelList);
    }
    */
}
