//
//  VHSMessageDetailController.swift
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/9.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

import UIKit

class VHSMessageDetailController: VHSBaseViewController {
    
    let screenW = UIScreen.main.bounds.size.width
    let screenH = UIScreen.main.bounds.size.height
    
    private let scrollView = UIScrollView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let imageView = UIImageView(frame: .zero)
    private let contentLabel = UILabel(frame: .zero)
    private let timeLabel = UILabel(frame: .zero)
    
    private var _messageModel: VHSMessageModel? = nil
    public var messageModel: VHSMessageModel! {
        get {
            return self._messageModel
        }
        set(messageModel) {
            if self._messageModel != messageModel {
                self._messageModel = messageModel
                
                titleLabel.text = messageModel.title
                timeLabel.text = messageModel.time
                contentLabel.text = messageModel.content
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    
        scrollView.frame = CGRect(x: CGFloat(0), y: CGFloat(NAVIAGTION_HEIGHT), width: screenW, height: screenH - CGFloat(NAVIAGTION_HEIGHT))
        self.view.addSubview(scrollView)
        
        self.initUI()
    }
    
    private func initUI() {
        let marginLeft = CGFloat(15)
        let marginTop = CGFloat(20)
        let marginRight = CGFloat(20)
        let imgW = CGFloat(80)
        
        titleLabel.frame = CGRect(x: marginLeft, y: marginTop, width: screenW - marginLeft - marginRight, height: 20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        scrollView.addSubview(titleLabel)
        
        imageView.frame = CGRect(x: marginLeft, y: titleLabel.frame.maxY + marginTop, width: imgW, height: imgW)
        scrollView.addSubview(imageView)
        imageView.sd_setImage(with: URL.init(string: messageModel.imgUrl), placeholderImage: UIImage.init(named: "icon_onlogin"))
        
        contentLabel.frame = CGRect(x: imageView.frame.maxX + marginLeft, y: imageView.frame.minY - 7, width: screenW - (imageView.frame.maxX + marginLeft) - marginRight, height: 300)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 16.0)
        contentLabel.backgroundColor = UIColor.yellow
        
        let height = messageModel.content.heightWithFont(font: contentLabel.font, fixedWidth: contentLabel.frame.width)
        var frame = contentLabel.frame
        frame.size.height = height
        contentLabel.frame = frame
        
        scrollView.addSubview(contentLabel)
        
        timeLabel.frame = CGRect(x: contentLabel.frame.minX, y: contentLabel.frame.maxY + 50, width: 200, height: 20)
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 14.0)
        scrollView.addSubview(timeLabel)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height + CGFloat(10))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
