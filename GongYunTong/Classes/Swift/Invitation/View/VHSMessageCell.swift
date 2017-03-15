//
//  VHSMessageCell.swift
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/9.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

import UIKit

class VHSMessageCell: UITableViewCell {
    
    private let headImageView = UIImageView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let contentLabel = UILabel()
    private let bottomSeparatedLine = UIView()
    
    private let screenW = UIScreen.main.bounds.size.width;
    
    // MARK: - getter or setter
    
    private var _messageModel: VHSMessageModel? = nil
    public var messageModel: VHSMessageModel! {
        get {
            return self._messageModel
        }
        set(messageModel) {
            if messageModel != self._messageModel {
                self._messageModel = messageModel
                
                headImageView.image = UIImage(named: "me_msg_list_msg_push")
                titleLabel.text = self._messageModel?.title
                timeLabel.text = self._messageModel?.time
                contentLabel.text = self._messageModel?.content
                
                let contentHeight = self._messageModel?.content.heightWithFont(font: contentLabel.font, fixedWidth: contentLabel.frame.width)
                contentLabel.frame = CGRect(x: 12.0, y: timeLabel.frame.maxY + 13.0, width: screenW - 12 * 2, height: contentHeight!)
            }
        }
    }
    
    // MARK: - initail method
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        headImageView.frame = CGRect(x: CGFloat(12), y: CGFloat(0), width: CGFloat(44), height: CGFloat(48))
        self.contentView.addSubview(headImageView)
        
        titleLabel.frame = CGRect(x: headImageView.frame.maxX + CGFloat(13), y: CGFloat(10), width: screenW - headImageView.frame.width - 50, height: CGFloat(20))
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = UIColor.hex("#3a8fb7")
        self.contentView.addSubview(titleLabel)
        
        timeLabel.frame = CGRect(x: headImageView.frame.maxX + 13.0, y: titleLabel.frame.maxY + 4.0, width: titleLabel.frame.width, height: 14.0)
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.hex("#a7999b")
        self.contentView.addSubview(timeLabel)
        
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = UIColor.hex("#443d3d")
        contentLabel.textAlignment = .left
        contentLabel.numberOfLines = 0
        contentLabel.frame = CGRect(x: 12.0, y: timeLabel.frame.maxY + 10, width: screenW - 12 * 2, height: 60)
        self.contentView.addSubview(contentLabel)
        
        bottomSeparatedLine.backgroundColor = UIColor.hex("#EFEFF4")
        self.contentView.addSubview(bottomSeparatedLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomSeparatedLine.frame = CGRect(x: 0, y: self.contentView.frame.maxY - 10, width: screenW, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
