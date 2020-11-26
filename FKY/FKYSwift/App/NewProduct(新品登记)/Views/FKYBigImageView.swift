//
//  FKYBigImageView.swift
//  FKY
//
//  Created by 油菜花 on 2020/3/9.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

/// 移除大图
let FKY_DismissBigImageView = "DismissBigImageView"

class FKYBigImageView: UIView {
    /// 查看大图
    lazy var bigImageView:UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .black
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    /// 正在加载LB
    lazy var loadingLabel:UILabel = {
        let lb = UILabel()
        lb.textColor = .white
        lb.text = "正在加载..."
        lb.font = UIFont.boldSystemFont(ofSize: WH(18))
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI
extension FKYBigImageView{
    
    func setupUI(){
        self.addSubview(self.bigImageView)
        self.addSubview(self.loadingLabel)
        
        self.bigImageView.snp_makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        self.loadingLabel.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

//MARK: - 显示数据
extension FKYBigImageView{
    
    func showImage(imageModel:UploadImageModel){
        self.bigImageView.image = nil
        self.loadingLabel.isHidden = false
        self.bigImageView.sd_setImage(with: URL(string:imageModel.imageUrl)) { (image, error, SDImageCacheType, URL) in
            self.loadingLabel.isHidden = true
        }
    }
}

//MARK: - 响应事件
extension FKYBigImageView{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.routerEvent(withName: FKY_DismissBigImageView, userInfo: [FKYUserParameterKey:""])
    }
}
