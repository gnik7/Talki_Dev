//
//  IZSavedChatViewController.swift
//  Talki
//
//  Created by Nikita Gil on 13.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class IZSavedChatsViewController: IZBaseHomeViewController {
    
    //IBOutlet
    @IBOutlet weak var savedChatsTableView: UITableView!
    
    //var
    var savedChatsArray : [IZChatMessageItemModel]?
    var offsetPagination = 0
    var startDeleting = false
    
    //let
    let titleTopPanel = "Chats"
    let heightCell : CGFloat = 70.0
    let limitPagination = 15
    
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load top navigation
        self.loadTopBar()
        
        //bottom panel
        self.bottomNavigationView?.updateUI(TypeBottomNavigationPanel.ChatTypeBottomNavigationPanel)
        
        //registrate cells for tableView
        self.registrateCell()
        
        // asign settingsTableView
        self.savedChatsTableView.delegate = self
        self.savedChatsTableView.dataSource = self
        self.savedChatsTableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateListMessage), name: NSNotification.Name(rawValue: missedMessageChatPushNotification) , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear(_:)), name: NSNotification.Name(rawValue: updateSavedChatView) , object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // init data for table
        self.offsetPagination = 0
        self.savedChatsArray = [IZChatMessageItemModel]()
        self.updateData()
        self.updateBudge()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func loadTopBar() {
        self.topFunctionalView!.updateUI(self.titleTopPanel, titleRightButton :nil, rightTitleText : nil, titleLeftButton : nil)
    }
    
    fileprivate func registrateCell() {
        
        let (classNameSavedChatCell ,nibSavedChatCell) = NSObject.classNibFromString(IZSavedChatsTableViewCell.self)
        guard let nameCell = classNameSavedChatCell as String?, let cellNib = nibSavedChatCell as UINib? else {
            return
        }
        self.savedChatsTableView.register(cellNib, forCellReuseIdentifier: nameCell)
    }
    
    fileprivate func checkMessageIndicator() {
        var counter = 0
        if savedChatsArray?.count > 0 {
            for item in savedChatsArray! {
                if item.isView == false {
                    counter += 1
                }
            }
            if counter == 0 {
                IZUserDefaults.cleanMissedMessage()
                DispatchQueue.main.async(execute: { () -> Void in
                    self.bottomNavigationView?.updateUI(TypeBottomNavigationPanel.ChatTypeBottomNavigationPanel)
                })
            } else {
                IZUserDefaults.recordMissedMessage()
                DispatchQueue.main.async(execute: { () -> Void in
                    self.bottomNavigationView?.updateUI(TypeBottomNavigationPanel.ChatTypeBottomNavigationPanel)
                })
            }
        } else {
            updateMissedIndicator()
        }
    }
    
    //*****************************************************************
    // MARK: - Notification
    //*****************************************************************
    
    func updateListMessage() {
        offsetPagination = 0
        updateDataFromPush()
    }
}

extension IZSavedChatsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.savedChatsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IZSavedChatsTableViewCell.self)) as! IZSavedChatsTableViewCell
        cell.updateData(self.savedChatsArray![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let isViewed = self.savedChatsArray![indexPath.row].isView {
            if !isViewed {
                UIApplication.shared.applicationIconBadgeNumber -= 1
            }
        }
        IZLoaderManager.sharedInstance.showView() 
        self.router.showChatViewController(self.savedChatsArray![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.savedChatsArray?.count)! - 1 {
            self.updateData()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            if !startDeleting {
                startDeleting = true
                self.removeSavedChat((self.savedChatsArray?[indexPath.row].recipient?.id)!, completed: {
                    self.savedChatsArray?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    self.offsetPagination -= 1
                    self.startDeleting = false
                })
            }            
        }
    }
}

extension IZSavedChatsViewController {
    
    //*****************************************************************
    // MARK: - Api Calls
    //*****************************************************************
    
    fileprivate func updateData() {
        
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIChatOperations.historyChatOperation(self.offsetPagination, limit: self.limitPagination, completed: { [weak self] (responceObject, statusResponse) in
            
            guard let strongSelf = self else { return }
            
//            strongSelf.updateMissedIndicator()
            
            guard let status = statusResponse as RestStatus? else {
                return
            }
            if status == RestStatus.success {
                if let respObjectsArray = responceObject as IZChatMessageModel? {
                    if respObjectsArray.items?.count > 0 {
                        strongSelf.savedChatsArray = strongSelf.savedChatsArray! + respObjectsArray.items!
                        strongSelf.convertMySelfToSenderChat()
                        strongSelf.savedChatsTableView.reloadData()
                        strongSelf.offsetPagination += (respObjectsArray.items?.count)! + 1
                        strongSelf.checkMessageIndicator()
                    }
                }
            }
        })
    }
    
    fileprivate func updateDataFromPush() {
        
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIChatOperations.historyChatOperation(self.offsetPagination, limit: self.limitPagination, completed: { [weak self] (responceObject, statusResponse) in
            
            guard let strongSelf = self else { return }
            guard let status = statusResponse as RestStatus? else {
                return
            }
            if status == RestStatus.success {
                if let respObjectsArray = responceObject as IZChatMessageModel? {
                    if respObjectsArray.items?.count > 0 {
                        strongSelf.savedChatsArray?.removeAll()
                        strongSelf.savedChatsArray = respObjectsArray.items!
                        strongSelf.convertMySelfToSenderChat()
                        strongSelf.savedChatsTableView.reloadData()
                        strongSelf.offsetPagination += (respObjectsArray.items?.count)! + 1
                        strongSelf.checkMessageIndicator()
                    }
                }
            }
            })
    }

    
    fileprivate func convertMySelfToSenderChat() {
        
        for item in self.savedChatsArray! {
            if item.recipient!.id == IZUserDefaults.getUserIdUserDefault() {
                let tmp = item.copy() as! IZChatMessageItemModel
                
                item.recipient = IZChatRecipientModel.convertSenderToRecipient(item.sender!)
                item.sender = IZChatSenderModel.convertRecipientToSender(tmp.recipient!)
            }
        }
    }
    
    fileprivate func removeSavedChat(_ userId: String, completed:@escaping (() -> ())) {
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIChatOperations.removeSavedChatOperation(userId, completed: {  [weak self]  (statusResponse) in
            guard let strongSelf = self else { return }
            guard let status = statusResponse as RestStatus? else {
                return
            }

            if status == RestStatus.success {
                 completed()
                 strongSelf.updateBudge()
            } else {
                strongSelf.savedChatsTableView.reloadData()
                strongSelf.offsetPagination += (strongSelf.savedChatsArray?.count)! + 1
                strongSelf.checkMessageIndicator()
            }
        })
    }
    
    fileprivate func updateBudge() {
        IZRestAPIProfileOperations.profileGetOperation { (responceObject, restStatus) in
        }
    }
    
    fileprivate func updateMissedIndicator(){        
        IZRestAPIInterestsOperations.updateNewMissedPushesOperation {(responceObject) in
        }
    }
}
