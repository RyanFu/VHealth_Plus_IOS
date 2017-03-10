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
    
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
//        self.getMesageQueue()
        
        tableView.frame = CGRect(x: CGFloat(0), y: CGFloat(NAVIAGTION_HEIGHT), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - CGFloat(NAVIAGTION_HEIGHT))
        tableView.register(VHSMessageCell.self, forCellReuseIdentifier: reuse_identifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse_identifier) as? VHSMessageCell
        
        if cell != nil {
            cell?.textLabel?.text = String(indexPath.section) + "---" + String(indexPath.row)
            return cell!
        }
        return UITableViewCell()
    }
}

extension VHSMessageQueueController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
