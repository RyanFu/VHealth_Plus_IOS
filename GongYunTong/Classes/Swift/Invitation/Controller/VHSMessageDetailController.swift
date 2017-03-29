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
                
                titleLabel.text = messageModel.msgTitle
                timeLabel.text = messageModel.msgTime
                contentLabel.text = messageModel.msgContent
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "消息详情"
    
        scrollView.frame = CGRect(x: CGFloat(0), y: CGFloat(NAVIAGTION_HEIGHT), width: screenW, height: screenH - CGFloat(NAVIAGTION_HEIGHT))
        self.view.addSubview(scrollView)
        
        self.initUI()
    }
    
    private func initUI() {
        let marginLeft = CGFloat(10)
        let marginTop = CGFloat(20)
        let imgW = CGFloat(66)
        let imgH = CGFloat(72)
        
        imageView.frame = CGRect(x: marginLeft, y: 5, width: imgW, height: imgH)
        imageView.image = UIImage(named: "me_msg_list_msg_push")
        scrollView.addSubview(imageView)
        
        titleLabel.frame = CGRect(x: imageView.frame.maxX + marginLeft, y: marginTop, width: screenW - imageView.frame.maxX - marginLeft, height: 20)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.hex("#3a8fb7")
        scrollView.addSubview(titleLabel)
        
        timeLabel.frame = CGRect(x: titleLabel.frame.minX, y: titleLabel.frame.maxY + 10, width: 150, height: 16)
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 14.0)
        timeLabel.textColor = UIColor.hex("#a7999b")
        scrollView.addSubview(timeLabel)
        
        contentLabel.frame = CGRect(x: marginLeft, y: imageView.frame.maxY, width: screenW - 2 * marginLeft, height: 300)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.textColor = UIColor.hex("#443d3d")
        contentLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        let height = messageModel.msgContent.heightWithFont(font: contentLabel.font, fixedWidth: contentLabel.frame.width)
        var frame = contentLabel.frame
        frame.size.height = height
        contentLabel.frame = frame
        
        scrollView.addSubview(contentLabel)
        
        if height > (scrollView.frame.size.height + CGFloat(10)) {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: height + imgH + 5)
        } else {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height + CGFloat(10))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
