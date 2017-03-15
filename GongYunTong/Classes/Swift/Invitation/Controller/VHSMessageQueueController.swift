//
//  VHSMessageQueueController.swift
//  GongYunTong
//
//  Created by pingjun lin on 2017/3/8.
//  Copyright © 2017年 vhs_health. All rights reserved.
//

import UIKit

class VHSMessageQueueController: VHSBaseViewController {

    let reuse_identifier = "VHSMessageCell"
    
    fileprivate var messageQueueList = [VHSMessageModel]()
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
//        self.getMesageQueue()
        
        let message = VHSMessageModel()
        message.content = "内容是图内容是乳内容是图内容是乳内容是图内容是乳内容是图内容是乳内容是图内容是乳"
        message.title = "消息推送"
        message.time = "2017-04-16 09:45:34"
        
        messageQueueList.append(message)
        
        tableView.frame = CGRect(x: CGFloat(0), y: CGFloat(NAVIAGTION_HEIGHT), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - CGFloat(NAVIAGTION_HEIGHT))
        tableView.register(VHSMessageCell.self, forCellReuseIdentifier: reuse_identifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - 获取服务器消息列表
    
    private func getMesageQueue() {
        let msg: VHSRequestMessage = VHSRequestMessage()
        msg.path = URL_GET_ICON
        msg.httpMethod = .POST
        
        VHSHttpEngine.sharedInstance().send(msg, success: { (resultObject: [AnyHashable : Any]?) in
            let result = resultObject as! Dictionary<String, Any>
            let code = result["result"] as! Int
            if code != 200 {
                return
            } else {
                print("\(result["info"] as! String)")
            }
            
            let iconList: Array<AnyObject> = result["iconList"] as! Array<AnyObject>
            
            for iconDict in iconList {
                print("\(iconDict)")
                let iconItem: [AnyHashable : Any] = iconDict as! [AnyHashable : Any]
                let msgModel: VHSMessageModel = VHSMessageModel.yy_model(with: iconItem)!
                print("--->>>>\(msgModel.title)--\(msgModel.time)--\(msgModel.imgUrl)")
            }
            
        }) { (error: Error?) in
            print("\(error)")
        }
    }
}

extension VHSMessageQueueController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuse_identifier) as? VHSMessageCell
        if cell == nil {
            cell = VHSMessageCell(style: .default, reuseIdentifier: reuse_identifier)
        }
    
        let message = messageQueueList.first
        cell?.messageModel = message
        
        if indexPath.row == 3 {
            let message = VHSMessageModel()
            message.content = "心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息"
            message.title = "消息推送"
            message.time = "2017-04-16 09:45:34"
            cell?.messageModel = message
        }
        return cell!;
    }
}

extension VHSMessageQueueController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messageQueueList.first
        var contentHeight = message?.content.heightWithFont(font: UIFont.systemFont(ofSize: 16), fixedWidth: UIScreen.main.bounds.size.width - 20)
        
        if (indexPath.row == 3) {
            contentHeight = "心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息心信息信息的测试信息".heightWithFont(font: UIFont.systemFont(ofSize: 16), fixedWidth: UIScreen.main.bounds.size.width - 20)
        }
        
        print("--->>>\(message?.content)--->>>\(contentHeight))")
        return 75 + contentHeight!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let msg = VHSMessageModel()
        msg.title = "这个是tile"
        msg.content = "这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容这个内容"
        msg.imgUrl = "https://vhealthplus.valurise.com/uploadFile/header/nd2LP1489048287227.jpg"
        msg.time = "2016-12-23 18:36"
        
        let msgDetailVC = VHSMessageDetailController()
        msgDetailVC.title = "消息"
        msgDetailVC.messageModel = msg
        self.navigationController?.pushViewController(msgDetailVC, animated: true)
    }
}
