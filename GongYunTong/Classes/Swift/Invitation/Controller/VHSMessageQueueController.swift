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
        
        self.getMesageQueue()
        
        tableView.frame = CGRect(x: CGFloat(0), y: CGFloat(NAVIAGTION_HEIGHT), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - CGFloat(NAVIAGTION_HEIGHT))
        tableView.register(VHSMessageCell.self, forCellReuseIdentifier: reuse_identifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        let footerRefresh = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(pullupFooterRefresh))
        footerRefresh?.setTitle("释放加载", for: .pulling)
        footerRefresh?.setTitle("加载中...", for: .refreshing)
        footerRefresh?.setTitle("上拉加载", for: .idle)
        self.tableView.mj_footer = footerRefresh
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - 获取服务器消息列表
    
    private func getMesageQueue() {
        let msg: VHSRequestMessage = VHSRequestMessage()
        msg.path = URL_GET_MESSAGE_LIST;
        msg.httpMethod = .POST
//        msg.params = ["" : ""]
        
        VHSHttpEngine.sharedInstance().send(msg, success: { (response: [AnyHashable : Any]?) in
            let result = response as! [String : Any]
            let code = result["result"] as! Int
            
            guard code == 200 else {
                return
            }
            
            let msgList = result["msgList"] as! [[String : Any]]
            
            for msg in msgList {
                let msgModel = VHSMessageModel.yy_model(with: msg)
                self.messageQueueList.append(msgModel!)
            }
            self.tableView.reloadData()
        }) { (error: Error?) in
            print("\(msg.path)--->>>\(error)")
        }
    }
    
    // MARK: - MJRefresh 
    
    func pullupFooterRefresh() {
        print("----->>> footerRefresh");
        self.tableView.mj_footer.endRefreshing()
    }
}

extension VHSMessageQueueController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageQueueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuse_identifier) as? VHSMessageCell
        if cell == nil {
            cell = VHSMessageCell(style: .default, reuseIdentifier: reuse_identifier)
        }
    
        let message = messageQueueList[indexPath.row]
        cell?.messageModel = message
        return cell!;
    }
}

extension VHSMessageQueueController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messageQueueList[indexPath.row]
        var contentHeight = message.msgContent.heightWithFont(font: UIFont.systemFont(ofSize: 16), fixedWidth: UIScreen.main.bounds.size.width - 20)
        if contentHeight > 57.5 {
            contentHeight = 66.0
        }
        return 75 + contentHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let msg = messageQueueList[indexPath.row]
        
        guard msg.sourceUrl != "" else {
            let msgDetailVC = VHSMessageDetailController()
            msgDetailVC.messageModel = msg
            self.navigationController?.pushViewController(msgDetailVC, animated: true)
            
            return
        }
        
        if msg.sourceType == MessageType.news.rawValue || msg.sourceType == MessageType.meet.rawValue || msg.sourceType == MessageType.dynamic.rawValue || msg.sourceType == MessageType.activity.rawValue {
            let web = PublicWKWebViewController()
            web.urlString = msg.sourceUrl
            self.navigationController?.pushViewController(web, animated: true)
        } else {
            let msgDetailVC = VHSMessageDetailController()
            msgDetailVC.messageModel = msg
            self.navigationController?.pushViewController(msgDetailVC, animated: true)
        }
    }
}
