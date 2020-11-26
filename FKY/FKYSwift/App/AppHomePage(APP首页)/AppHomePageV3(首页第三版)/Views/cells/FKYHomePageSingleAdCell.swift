//
//  FKYHomePageSingleAdCell.swift
//  FKY
//
//  Created by 油菜花 on 2020/10/20.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

class FKYHomePageSingleAdCell: UITableViewCell {

    
    /// 广告图片点击
    static let adImageClicked = "FKYHomePageSingleAdCell-adImageClicked"
    
    /// 广告图片
    lazy var adImage:UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = WH(8)
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(FKYHomePageSingleAdCell.adBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    /// gif时候的广告
    let adGifImageView:YYAnimatedImageView = YYAnimatedImageView()
    
    /// 点击按钮
    lazy var actionBtn:UIButton = {
        let bt = UIButton()
        bt.addTarget(self, action: #selector(FKYHomePageSingleAdCell.adBtnClicked), for: .touchUpInside)
        return bt
    }()
    
    var cellData:FKYHomePageV3CellModel = FKYHomePageV3CellModel()
    
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

//MARK: - 数据展示
extension FKYHomePageSingleAdCell{
    /*
    func showTestData(){
        //self.adImage.sd_setImage(with: URL(string: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1689053532,4230915864&fm=26&gp=0.jpg"))
        adImage.sd_setImage(with: URL(string: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1689053532,4230915864&fm=26&gp=0.jpg"), placeholderImage: UIImage(named: "img_product_default"))
    }
    */
    func configCell(cellData:FKYHomePageV3CellModel){
        self.cellData = cellData
        guard self.cellData.cellModel.contents.recommend.iconImgDTOList.count > 0 else{
            return
        }
        //congfigGitImageView(self.cellData.cellModel.contents.recommend.iconImgDTOList[0].imgPath, adImage.image, "image_placeholder_rect")
        loadImage(url: self.cellData.cellModel.contents.recommend.iconImgDTOList[0].imgPath)
//        adImage.sd_setBackgroundImage(with: URL(string: self.cellData.cellModel.contents.recommend.iconImgDTOList[0].imgPath), for: .normal, placeholderImage: UIImage(named: "image_placeholder_rect"))
    }
}

//MARK: - 事件响应
extension FKYHomePageSingleAdCell{
    
    @objc func adBtnClicked(){
        self.routerEvent(withName: FKYHomePageSingleAdCell.adImageClicked, userInfo: [FKYUserParameterKey:self.cellData.cellModel.contents.recommend])
    }
}


//MARK: - 私有方法
extension FKYHomePageSingleAdCell {
    /// 加载图片
    func loadImage(url:String){
        if url.lowercased().hasSuffix("gif") {
            adGifImageView.yy_setImage(with: URL(string: url), placeholder: UIImage(named: "image_placeholder_rect"), options: [.progressiveBlur,.setImageWithFadeAnimation]) { (img, url, type, statu, error) in
                
            }
            adGifImageView.isHidden = false
            adImage.isHidden = true
        }else{
            adImage.yy_setBackgroundImage(with: URL(string: url), for: .normal, placeholder: UIImage(named: "image_placeholder_rect"))
            adGifImageView.isHidden = true
            adImage.isHidden = false
        }
    }
    
    //加载图片
    fileprivate func congfigGitImageView(_ str:String?,_ desImage:UIButton, _ defalutStr:String){
        let defaultAwardImage = UIImage.init(named: defalutStr)
        desImage.setBackgroundImage(defaultAwardImage, for: .normal)
        //desImage.image = defaultAwardImage
        if let imageStr = str,  let strProductPicUrl = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let urlProductPic = URL(string: strProductPicUrl) {
            if strProductPicUrl.lowercased().hasSuffix("gif") {
                // gif
                DispatchQueue.global().async {[weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let imageData = NSData(contentsOf: urlProductPic)
                    DispatchQueue.main.async {[weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        if let gifData = imageData, gifData.length > 0 {
                            //self.imgView.gifData = gifData
                            // 解决tableview滑动时Gif动画停止的问题
                            if let img = UIImage.sd_animatedGIF(with: gifData as Data) {
                                //desImage.image = img
                                desImage.setBackgroundImage(img, for: .normal)
                            }
                            else {
                                //desImage.image = defaultAwardImage
                                desImage.setBackgroundImage(defaultAwardImage, for: .normal)
                            }
                        }
                        else {
                            desImage.sd_setImage(with: urlProductPic, for: .normal, placeholderImage: defaultAwardImage)
                            //desImage.sd_setImage(with: urlProductPic, placeholderImage: defaultAwardImage)
                        }
                    }
                }
            }
            else {
                // 非gif
                desImage.sd_setBackgroundImage(with: urlProductPic, for: .normal, placeholderImage: defaultAwardImage)
                //desImage.sd_setImage(with: urlProductPic, placeholderImage: defaultAwardImage)
            }
        }
    }
}

//MARK: - UI
extension FKYHomePageSingleAdCell{
    
    override func configCellDisplayInfo() {
        super.configCellDisplayInfo()
    }
    
    func setupUI(){
        selectionStyle = .none
        backgroundColor = .clear
        adImage.backgroundColor = .clear
        
        contentView.addSubview(self.adImage)
        contentView.addSubview(self.adGifImageView)
        contentView.addSubview(self.actionBtn)
        
        adImage.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(-8))
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        adGifImageView.snp_makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(WH(-8))
            make.left.equalToSuperview().offset(WH(10))
            make.right.equalToSuperview().offset(WH(-10))
        }
        
        actionBtn.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}

