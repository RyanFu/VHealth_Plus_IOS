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
        
        return 75 + contentHeight!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let msg = VHSMessageModel()
        msg.title = "消息推送"
        msg.content = "你是我生命中最美的相遇\n我不知道流星能飞多久\n值不值得追求\n我不知道樱花能开多久\n值不值得等候\n我知道你我的友谊\n能不像樱花般美丽\n像恒星般永恒\n值得我用一生去保留\n\n如果落叶能寄去我所有的思念\n我情愿将整个秋林装进我心中\n如果归雁能传递我所有的思念\n我会用毕生感谢这美的季节\n\n孤独时仰望蓝天\n你是最近的那朵白云\n寂寞时凝视夜空\n你是最亮的那颗星星\n闲暇时漫步林中\n你是擦肩的那片落叶\n疲惫时安然入睡\n你是最美的那段梦境\n\n多一声问候 多一份温暖\n多一个朋友 多一份蓝天\n多一个知心 多一份情感\n多一个挚友 多一份感慨\n一千只纸鹤折给你\n让烦恼远离你\n\n一千朵玫瑰送给你\n让你好好爱自己\n一千颗幸运星给你\n让你好运围绕着你\n一千枚开心果给你\n让好心情时刻找到你"
        msg.imgUrl = "https://vhealthplus.valurise.com/uploadFile/header/nd2LP1489048287227.jpg"
        msg.time = "2016-12-23 18:36"
        
        let msgDetailVC = VHSMessageDetailController()
        msgDetailVC.title = "消息"
        msgDetailVC.messageModel = msg
        self.navigationController?.pushViewController(msgDetailVC, animated: true)
    }
}
