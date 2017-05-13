//
//  IZChatViewController.swift
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}



class IZChatViewController: IZChatBaseViewController {
    
    //IBOutlet
    @IBOutlet weak var messageTextView  : UITextView!
    @IBOutlet weak var bottomView       : UIView!
    @IBOutlet weak var profileImageView : UIImageView!
    @IBOutlet weak var nameLabel        : UILabel!
    @IBOutlet weak var statusUserLabel  : UILabel!
    @IBOutlet weak var fotoLocationView : UIView!    
    
    @IBOutlet weak var sendButtonImageView  : UIImageView!
    @IBOutlet weak var addButtonImageView   : UIImageView!
    
    @IBOutlet weak var addButton            : UIButton!
    @IBOutlet weak var sendButton           : UIButton!
 
    @IBOutlet weak var messageLineView      : UIView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!

    
    
    //var
    var currentChat             : IZChatMessageItemModel?
    var chatArray               : [IZSingleChatMessageItemModel]?
    var chatArray2D             : [[IZSingleChatMessageItemModel]]?
    var currentShowedChatItem   : String?
    var indexPathToScroll       : IndexPath? = IndexPath(row: 0, section: 0)
    
    var ownerImage      : UIImage?
    var opponentImage   : UIImage?
    var timerOnline     : Timer?
    var timerloction    : Timer?
    
    var currentOffset = 0
    
    var heightCell : CGFloat = 0.0
    var isSendMessageButtonEnable = true
    var isNeedShowAtEnd = true
    var isLocationButtonPressed = false
    var isLoadedTable = false
        
    //let
    var socket: IZSocketProvider? = IZSocketProvider()
    
    let heightWithImageCell : CGFloat = 160.0
    let heightWithLocationCell : CGFloat = 70.0
    var headerSectionHeight :CGFloat = 32.0
    var locationImageHeight:CGFloat  = 150.0
    var tableOriginHeight:CGFloat  = 0.0
    var textViewHeight: CGFloat = 0.0
    
    let onlineStatus = "online"
    let offlineStatus = "offline"
    let defaultTextMesssage = "Type something"
    let titleToday = "Today"
    let timeForRepeatOnline   : TimeInterval = 60
    let timeForLocation       : TimeInterval = 3
    let pathLocationBottom : CGFloat = 60
    let limitPagination = 8
    let maxMessages = 4
    let maxRowsInMessageView = 8
    let colorHeaderTableView = UIColor(colorLiteralRed: 153/255.0, green: 153/255.0, blue: 153.0/255.0, alpha: 1.0)
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        IZLoaderManager.sharedInstance.hideView()
        
        self.chatArray = [IZSingleChatMessageItemModel]()
        self.chatArray2D = [[IZSingleChatMessageItemModel]]()
        
        //changes with UI
        self.updateImages()
        self.updateOpponentLabels()
        self.updateSenderPanel()
        self.setupTextVeiw()
        
        //add ui
        self.registrateCell()
        self.setupTable()
 
        // get data
        self.updateAllChatMessages((self.currentChat?.recipient?.id)!)
        
        singForObservers()
        // clear indicator missed message
        clearMissedMessage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IZLoaderManager.sharedInstance.hideView()
        self.locationImageHeight = self.fotoLocationView.frame.height
        self.tableOriginHeight = self.chatTableView.frame.height
        self.textViewHeight = self.messageTextView.frame.size.height
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !isPhotoControllerEnabled {
            self.timerOnline?.invalidate()
            self.timerloction?.invalidate()
            self.socket?.userMoveout()
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
    }
    
    fileprivate func registrateCell() {
        
        let (classLocationChatCell ,nibLocationChatCell) = NSObject.classNibFromString(IZILocationTableViewCell.self)
        guard let nameLocationCell = classLocationChatCell as String?, let cellLocationNib = nibLocationChatCell as UINib? else {
            return
        }
        self.chatTableView.register(cellLocationNib, forCellReuseIdentifier: nameLocationCell)
        
        let (classTextChatCell ,nibTextChatCell) = NSObject.classNibFromString(IZITextTableViewCell.self)
        guard let nameTextCell = classTextChatCell as String?, let cellTextNib = nibTextChatCell as UINib? else {
            return
        }
        self.chatTableView.register(cellTextNib, forCellReuseIdentifier: nameTextCell)
        
        let (classImageChatCell ,nibImageChatCell) = NSObject.classNibFromString(IZImageTableViewCell.self)
        guard let nameImageCell = classImageChatCell as String?, let cellImageNib = nibImageChatCell as UINib? else {
            return
        }
        self.chatTableView.register(cellImageNib, forCellReuseIdentifier: nameImageCell)
    }
    
    fileprivate func updateImages(){
        
        self.ownerImage = UIImage()
        self.updateImagesProfile((currentChat?.sender?.avatar?.preview)!, completed:  { (image) in
            DispatchQueue.main.async {
            self.ownerImage = image
            self.chatTableView.reloadData()
            }
        })
        
        self.opponentImage = UIImage()
        self.updateImagesProfile((currentChat?.recipient?.avatar?.preview)!, completed:  { (image) in
            self.opponentImage = image
            DispatchQueue.main.async {
                self.profileImageView.image = image
                self.chatTableView.reloadData()
            }
        })
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.setNeedsDisplay()
        self.profileImageView.layoutIfNeeded()
    }
    
    fileprivate func updateOpponentLabels() {
        self.nameLabel.text = self.currentChat?.recipient?.name
        self.updateUserOpponentStatus()
        self.timerOnline = Timer.scheduledTimer(timeInterval: self.timeForRepeatOnline, target: self, selector: #selector(IZChatViewController.updateUserOpponentStatus), userInfo: nil , repeats: true)
    }
    
    fileprivate func updateSenderPanel() {
        self.fotoLocationView.isHidden = true
        self.fotoLocationView.transform = CGAffineTransform(translationX: 0, y: pathLocationBottom)
    }
    
    fileprivate func setupTextVeiw() {
        self.messageTextView.isScrollEnabled = false
    }
    
    fileprivate func singForObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(IZChatViewController.newMessageNotification(_:)), name: NSNotification.Name(rawValue: "NewMessage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IZChatViewController.userBlockNotification(_:)), name: NSNotification.Name(rawValue: "UserBlock"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(IZChatViewController.closeSocket(_:)), name: NSNotification.Name(rawValue: "CloseSocket"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IZChatViewController.openSocket(_:)), name: NSNotification.Name(rawValue: "OpenSocket"), object: nil)
    }
    
    fileprivate func setupTable() {
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.messageTextView.delegate = self
        
        self.chatTableView.estimatedRowHeight = heightCell
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        chatTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
    }
    
    fileprivate func createBorderToMessageVIew() {
        self.messageTextView.layer.borderWidth = 1.0
        self.messageTextView.layer.borderColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        self.messageTextView.layer.cornerRadius = 5.0
        self.messageTextView.clipsToBounds = true
        
        self.messageLineView.isHidden = true
    }
    
    fileprivate func removeBorderToMessageVIew() {
        self.messageTextView.layer.borderWidth = 1.0
        self.messageTextView.layer.borderColor = UIColor.white.cgColor
            self.messageTextView.layer.cornerRadius = 5.0
        self.messageTextView.clipsToBounds = true
        
        self.messageLineView.isHidden = false
    }
    
    fileprivate func refreshMessageTextView() {
        let sizeThatFitsTextView: CGSize = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.size.width, height: CGFloat(MAXFLOAT)))
        self.textViewHeightConstraint.constant = sizeThatFitsTextView.height
        self.messageTextView.isScrollEnabled = false
    }
    
    fileprivate func clearMissedMessage() {
        IZUserDefaults.cleanMissedMessage()
    }
    
    //*****************************************************************
    // MARK: -  4 Messages
    //*****************************************************************
    
    func checkMessages() -> Int {
        
        var countCurrentYouserMessage = 0
        if self.chatArray?.count > 0 {
            for item in self.chatArray! {
                if item.senderId == IZUserDefaults.getUserIdUserDefault() {
                    countCurrentYouserMessage += 1
                }
            }
            if countCurrentYouserMessage >= maxMessages {
                self.blockSendMessage()
            }
        }
        return countCurrentYouserMessage
    }
    
    fileprivate func showAlertAtStart(){
        //show helper about 4 messages
        if checkMessages() == 0 {
           self.firstTimeHelperCreate()
        }
    }
    
    fileprivate func firstTimeHelperCreate() {
        let firstTimeInterestHelper = IZInterestHelper.loadFromXib()
        firstTimeInterestHelper?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        firstTimeInterestHelper?.hideHelher()
        firstTimeInterestHelper?.updateText(AlertText.twoMessageChat.rawValue)
        firstTimeInterestHelper?.showView()
       
        IZUserDefaults.updateFirstIChatHelperUserDefault()
    }
    
    fileprivate func blockSendMessage() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.addButton.isEnabled = false
            self.sendButton.isEnabled = false
            self.sendButtonImageView.image = UIImage(named: "send_message_inactive_chat")
            self.addButtonImageView.image = UIImage(named: "add_button_inactive_chat")
            self.gestureTap()
        })
    }
    
    //*****************************************************************
    // MARK: - Scroll
    //*****************************************************************
    
    func countLastCell() -> IndexPath {
        if self.chatArray2D?.count > 0 {
            self.isArrayIsNotEmpty = true
            let sectionLastNumber = self.chatTableView.numberOfSections - 1
            let lastRowInSection = self.chatTableView.numberOfRows(inSection: sectionLastNumber) - 1
            let index = IndexPath(row: lastRowInSection, section: sectionLastNumber)
            return index
        }
        self.isArrayIsNotEmpty = false
        return IndexPath(row: 0, section: 0)
    }
    
    func scrollToIndex(_ currentItemId : String?){
        if self.chatArray2D?.count <= 0 {
            return
        }
        var itemId = ""
        if currentItemId == nil {
            itemId = (self.chatArray2D?.last?.last)!.id!
        } else {
            itemId = currentItemId!
        }
        
        var  columnNumber = 0, rowNumber = 0
        for column in 0..<self.chatArray2D!.count   {
            for row in 0..<self.chatArray2D![column].count   {
                if IZSingleChatMessageItemModel.compareIZSingleChatMessageItem(itemId, item2: (self.chatArray2D?[column][row].id!)!) {
                    columnNumber = column
                    rowNumber = row
                    print("currentShowedChatItem \(itemId)  row  \(self.chatArray2D![column][row].id!)")
                    print("section \(columnNumber)  row  \(rowNumber)")
                    break
                }
            }
        }
        self.indexPathToScroll = IndexPath(row: rowNumber, section: columnNumber)
        
        self.scrollWithCountedHeight(columnNumber, rowNumber: rowNumber, completed: {
            
            let delay2 = 0.8 * Double(NSEC_PER_SEC)
            let time2 = DispatchTime.now() + Double(Int64(delay2)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time2, execute: {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.chatTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                })
                self.chatTableView.scrollToRow(at: self.indexPathToScroll!, at: UITableViewScrollPosition.bottom, animated: true)
            })
        })
    }
    
    func scrollWithCountedHeight(_ columnNumber:Int, rowNumber:Int , completed:@escaping () ->()) {
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            if self.isLoadedTable {
                var heightH = self.countHeightCell(self.indexPathToScroll!)
                
                if heightH == 0 {
                    let cell = self.createCell(self.chatTableView, cellForRowAtIndexPath: self.indexPathToScroll!, item: self.chatArray2D![columnNumber][rowNumber], type: IZChatCellType.izChatCellOwner)
                    heightH = (cell as? IZITextTableViewCell)!.heightCell
                }
                self.chatTableView.contentInset = UIEdgeInsetsMake(0, 0, heightH, 0)
                self.isLoadedTable = false
            }
            self.chatTableView.scrollToRow(at: self.indexPathToScroll!, at: UITableViewScrollPosition.none, animated: true)
            completed()
        })
    }
    
    func locationStatusUpdate(){
        self.isLocationButtonPressed = false
    }
    
    deinit{
        self.timerOnline?.invalidate()
        self.timerloction?.invalidate()
        self.socket?.userMoveout()
        NotificationCenter.default.removeObserver(self)
    }

    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        
        if checkMessages() >= maxMessages {
            self.firstTimeHelperCreate()
            return
        }
        
        if self.checkForEmptyTextField(self.messageTextView) {
            guard let message = self.messageTextView.text as String?, self.messageTextView.text != self.defaultTextMesssage  else{
                return
            }
                        
            socket?.sendMessage(message, image: nil, location: nil, recipientId: ((self.currentChat?.recipient?.id)!))
            self.messageTextView.text = ""
            self.removeBorderToMessageVIew()
            self.refreshMessageTextView()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if self.isSendMessageButtonEnable {
            self.animationAddView()
        } else {
            self.animationRemoveView()
        }        
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        self.updateUserProfileMatch((self.currentChat?.recipient?.id)!)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.socket?.userMoveout()
        //self.router.popViewController(true)
        self.router.showSavedChatsViewController()
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        
        if self.isLocationButtonPressed {
            return
        }
        self.animationRemoveView()
        
        let alertView = IZAlertView.loadFromXib()
        alertView?.showViewWithCustomButtons(AlertText.AddLocationChat.rawValue, action: {            
            self.isLocationButtonPressed = true
            self.timerOnline = Timer.scheduledTimer(timeInterval: self.timeForLocation, target: self, selector: #selector(IZChatViewController.locationStatusUpdate), userInfo: nil , repeats: false)
            
            let location = UserLocation.updateCoordinate()
            self.socket?.sendMessage(nil, image: nil, location: location, recipientId: ((self.currentChat?.recipient?.id)!))
        })
    }
    
    @IBAction func galleryButtonPressed(_ sender: UIButton) {
        IZLoaderManager.sharedInstance.showView()
        self.actionAddPhotoFromGallery { (image) in
            self.isPhotoControllerEnabled = false
            self.uploadImageChat(image, completed: { (item) in
                self.animationRemoveView()
                self.socket?.sendMessage(nil, image: item, location: nil, recipientId: ((self.currentChat?.recipient?.id)!))
            })
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {

        IZLoaderManager.sharedInstance.showView()
        self.actionMakePhoto { (image) in
            self.isPhotoControllerEnabled = false
            self.uploadImageChat(image, completed: { (item) in
                self.animationRemoveView()
                self.socket?.sendMessage(nil, image: item, location: nil, recipientId: ((self.currentChat?.recipient?.id)!))
            })
        }
    }
    
    //*****************************************************************
    // MARK: - Animation
    //*****************************************************************
    
    fileprivate func animationAddView() {
       
        self.view.endEditing(true)
        self.isSendMessageButtonEnable = false
        self.messageTextView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: -self.pathLocationBottom)
            self.fotoLocationView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.addButtonImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            self.fotoLocationView.isHidden = false
            self.sendButtonImageView.alpha = 0.0
            
            }, completion: { (finished) in
                self.sendButtonImageView.image = UIImage(named: "send_message_inactive_chat")
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.sendButtonImageView.alpha = 1.0
                    }, completion: { (finished) in
                        self.chatTableView.frame.size.height = self.chatTableView.frame.size.height - self.locationImageHeight
                        self.countLastCells()
                })
        })
    }
    
    fileprivate func animationRemoveView() {
        
        self.messageTextView.isUserInteractionEnabled = true
        self.isSendMessageButtonEnable = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.sendButtonImageView.alpha = 0.0
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.fotoLocationView.transform = CGAffineTransform(translationX: 0, y: self.pathLocationBottom)
            self.addButtonImageView.transform = CGAffineTransform(rotationAngle: 0.0)
            
            self.chatTableView.frame.size.height = self.tableOriginHeight
            
            }, completion: { (finished) in
                
                self.sendButtonImageView.image = UIImage(named: "send_message_chat")
                self.countLastCells()
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.sendButtonImageView.alpha = 1.0
                    }, completion: { (finished) in
                        
                })
        })
    }
    
    //*****************************************************************
    // MARK: - Notification
    //*****************************************************************

    func newMessageNotification(_ notification:Notification) {
        
        let userInfo : NSDictionary = notification.object as! NSDictionary
        let message  = IZSingleChatMessageItemModel.convertSocketInfoToIZSingleChatMessageItemModel(userInfo)
        
        if let _ = chatArray?.index(where: {$0.id == message.id}) { return }
        
        self.chatArray?.insert(message, at: 0)
        self.chatArray2D = IZSingleChatMessageItemModel.convertArrayItemsToArrayWithSection(self.chatArray!)
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
        }
        if self.isNeedShowAtEnd {
            self.scrollToIndex(nil)
        }
        let _ = self.checkMessages()
        self.currentOffset += 1
    }
    
    func userBlockNotification(_ notification:Notification) {
        loadAlert(AlertText.UserBlocked.rawValue, text2: "")
    }
    
    func closeSocket(_ notification:Notification) {
        self.socket?.userMoveout()
        self.chatArray?.removeAll()
        self.chatArray2D?.removeAll()
        self.chatTableView.reloadData()
        self.currentOffset = 0
        self.isArrayIsNotEmpty = false
        self.socket = nil
    }

    func openSocket(_ notification:Notification) {
        self.socket = IZSocketProvider()       
        self.updateAllChatMessages((self.currentChat?.recipient?.id)!)        
    }
    
    //*****************************************************************
    // MARK: - Create Cell
    //*****************************************************************
    fileprivate func createCell(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath,item : IZSingleChatMessageItemModel?, type :IZChatCellType) -> UITableViewCell {
        
        var profImage = UIImage()
        if type == IZChatCellType.izChatCellOwner {
            profImage = self.ownerImage!
        } else if type == IZChatCellType.izChatCellOpponent {
            profImage = self.opponentImage!
        }
        
        if item!.cellType == IZChatCellType.izChatCellImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IZImageTableViewCell.self)) as! IZImageTableViewCell
            cell.updateData(item, profileImage: profImage, type: type)
            self.heightCell = cell.heightCell
            return cell
        } else if item!.cellType == IZChatCellType.izChatCellLocation {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IZILocationTableViewCell.self)) as! IZILocationTableViewCell
            cell.currentIndexPath = indexPath
            cell.delegate = self
            cell.updateData(item, profileImage: profImage, type: type)
            self.heightCell = cell.heightCell
            return cell
        } else /*if item!.cellType == IZChatCellType.IZChatCellText*/ {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IZITextTableViewCell.self)) as! IZITextTableViewCell
            cell.updateData(item, profileImage: profImage, type: type)
            self.heightCell = cell.heightCell
            return cell
        }
    }
}

extension IZChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.chatArray2D?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.chatArray2D?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return self.countHeightCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.chatArray2D?.count <= 0 && self.chatArray?.count <= 0 {
            return UITableViewCell()
        }
       
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        //let currentRow = (self.chatArray2D![currentSection].count - 1) - indexPath.row
        
        if IZUserDefaults.getUserIdUserDefault() == self.chatArray2D![currentSection][currentRow].senderId {
            let cell = self.createCell(tableView, cellForRowAtIndexPath: indexPath, item: self.chatArray2D![currentSection][currentRow], type: IZChatCellType.izChatCellOwner)
            return cell
        } else {
            let cell = self.createCell(tableView, cellForRowAtIndexPath: indexPath, item: self.chatArray2D![currentSection][currentRow], type: IZChatCellType.izChatCellOpponent)
            return cell
        }
  }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let tmpTitle = self.chatArray2D![section].first!.time as String? else {
            return UIView()
        }
        
        let date = IZHelper.convertTimeFromString(tmpTitle)
        var title = ""
        let result = IZHelper.compareDateInChat(date, previousDate: Date())
        if result {
            title = self.titleToday
        } else {
            title = IZHelper.convertTimeToString(date)
        }
        
        let header = UIView()
        header.center.x = self.view.center.x
        
        let headerLabel = IZHelper.createUILabelForSectionTitle(0 , width: 0, text:title)
        
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: headerLabel.frame.width + 15, height: headerLabel.frame.height))
        backView.backgroundColor = colorHeaderTableView
        backView.layer.cornerRadius = backView.frame.size.height / 2
        backView.clipsToBounds = true
        
        backView.center.x = self.view.center.x
        headerLabel.center.y = backView.center.y
        headerLabel.center.x = self.view.center.x
        
        header.addSubview(backView)
        header.addSubview(headerLabel)
        
        return header
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Section \(indexPath.section)  Row \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            print("Scrolling up!")
            self.isNeedShowAtEnd = true
        } else {
            print("Scrolling down!")
            self.isNeedShowAtEnd = false
            
            let indexPathZero = IndexPath(row: 0, section: 0)
            guard let cellZero = chatTableView.cellForRow(at: indexPathZero), self.chatArray?.count > 0  else {
                return
            }
            if self.chatTableView.visibleCells.contains(cellZero) {
                if self.chatArray?.count > 0 {
                    self.currentShowedChatItem = self.chatArray2D?[0][0].id!
                }
                self.updateAllChatMessages((self.currentChat?.recipient?.id)!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerSectionHeight
    }
    
    fileprivate func countHeightCell(_ indexPath: IndexPath) -> CGFloat {
        
        if self.chatArray2D![indexPath.section][indexPath.row].cellType == IZChatCellType.izChatCellImage {
            return self.heightWithImageCell
        } else if self.chatArray2D![indexPath.section][indexPath.row].cellType == IZChatCellType.izChatCellLocation {
            return self.heightWithLocationCell
        } else if self.chatArray2D![indexPath.section][indexPath.row].cellType == IZChatCellType.izChatCellText {
            return self.heightCell
        }
        return UITableViewAutomaticDimension
    }
 }

extension IZChatViewController: UITextViewDelegate {
    
    //*****************************************************************
    // MARK: - UITextViewDelegate
    //*****************************************************************
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.messageTextView.contentSize.height = self.messageTextView.requiredHeight()
        self.textViewHeightConstraint.constant = self.messageTextView.requiredHeight()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        self.messageTextView.text = ""
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.messageTextView.text = self.defaultTextMesssage
        self.removeBorderToMessageVIew()
        self.refreshMessageTextView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let rowsInTextView = messageTextView.numberOfLines()
        
        if rowsInTextView < maxRowsInMessageView  {
            messageTextView.isScrollEnabled = false
            let sizeThatFitsTextView: CGSize = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.size.width, height: CGFloat(MAXFLOAT)))
            self.textViewHeightConstraint.constant = sizeThatFitsTextView.height
            
            if rowsInTextView > 1 {
                self.createBorderToMessageVIew()
            } else {
                self.removeBorderToMessageVIew()
            }
            if self.chatArray2D?.count > 0 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.chatTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                })
                self.chatTableView.scrollToRow(at: self.indexPathToScroll!, at: UITableViewScrollPosition.bottom, animated: true)
            }
            
        } else if rowsInTextView >= maxRowsInMessageView {
            if self.chatArray2D?.count > 0 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.chatTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                })
                self.chatTableView.scrollToRow(at: self.indexPathToScroll!, at: UITableViewScrollPosition.bottom, animated: true)
            }
        } else {
            messageTextView.isScrollEnabled = true
        }
    }
}

extension IZChatViewController: IZChatLocationCellDelegate {
    
    //*****************************************************************
    // MARK: - IZChatLocationCellDelegate
    //*****************************************************************
    
    func locationLoaded(_ indexPath : IndexPath, text : String?) {
       
        if self.isLocationButtonPressed {
            self.isLocationButtonPressed = false
        }
        
        guard let cell = chatTableView.cellForRow(at: indexPath) as? IZILocationTableViewCell else {
            return
        }
        DispatchQueue.main.async {
            if let locText = text {
                print(text ?? "")
                cell.locationLabel.text = locText
            } else {
                cell.locationLabel.text = ""
            }
        }
    }
    
    func showChatLocation(_ item : IZSingleChatMessageItemModel) {
        self.router.showChatLocationViewController(item, name: currentChat?.recipient?.name)
    }
}

extension IZChatViewController {

    //*****************************************************************
    // MARK: - Api Calls
    //*****************************************************************
    
    fileprivate func updateAllChatMessages(_ recepientId : String) {
        
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIChatOperations.singleChatMessagesOperations(recepientId, offset: self.currentOffset, limit: self.limitPagination,
            completed:  { [weak self] (responceObject, statusResponse) in
                
                guard let strongSelf = self else { return }
                strongSelf.updateMissedIndicator()
                
                guard let status = statusResponse as RestStatus? else {
                    return
                }
                
                if status == RestStatus.success {
                    if let messages = responceObject as IZSingleChatMessageModel? {
                        if let messArray = messages.items as [IZSingleChatMessageItemModel]? {
                            if messArray.count > 0 {
                                strongSelf.isArrayIsNotEmpty = true
                                for item in messArray {
                                    if let index = strongSelf.chatArray?.index(where: {$0.id == item.id}) {
                                        strongSelf.chatArray?.remove(at: index)
                                    }
                                }
                                strongSelf.chatArray?.append(contentsOf: messArray)
                                strongSelf.currentOffset += messArray.count + 1
                                strongSelf.chatArray2D = IZSingleChatMessageItemModel.convertArrayItemsToArrayWithSection(strongSelf.chatArray!)
                                let _ = strongSelf.checkMessages()
                               
                                if strongSelf.isNeedShowAtEnd {
                                    strongSelf.isLoadedTable = true
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        strongSelf.chatTableView.reloadData()
                                        strongSelf.chatTableView.layoutIfNeeded()
                                    })
                                    
                                    UIView.animate(withDuration: 0.5, animations: {
                                        
                                        }, completion: { (fin) in
                                            strongSelf.scrollToIndex(nil)
                                    })
                                } else {                                    
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        strongSelf.chatTableView.reloadData()
                                        strongSelf.chatTableView.layoutIfNeeded()
                                    })
                                    UIView.animate(withDuration: 0.5, animations: {
                                         strongSelf.scrollToIndex(strongSelf.currentShowedChatItem)
                                        }, completion: { (fin) in
                                    })
                                }
                            }
                        }
                    }
                }
        })
    }
    
    func updateImagesProfile(_ url : String, completed:@escaping (_ image : UIImage) -> ()) {
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }

        IZRestAPIDownloadOperations.downloadImageOperations(url, responceObject:  { (responceObject) in
            
            if let image = responceObject as UIImage? {
                completed(image)
            }
        })
    }
    
    func updateUserOpponentStatus() {
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIChatOperations.statusUserOperations((self.currentChat?.recipient?.id)!, completed:  { [weak self] (responceObject, statusResponse) in
            
            guard let strongSelf = self else { return }
            
            if statusResponse == RestStatus.success {
                guard let status = responceObject as Bool? else {
                    return
                }
                if status  {
                   strongSelf.statusUserLabel.text = strongSelf.onlineStatus
                } else {
                   strongSelf.statusUserLabel.text = strongSelf.offlineStatus
                }
            }
        })
    }
    
    fileprivate func uploadImageChat(_ image : UIImage, completed:@escaping (_ item : IZSingleChatPictureModel)->()) {
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        DispatchQueue.main.async {
            IZLoaderManager.sharedInstance.showView()
        }
        
        IZRestAPIChatOperations.uploadImageChatOperation(image, responce: { (responceObject, restStatus) in
            
            DispatchQueue.main.async {
                IZLoaderManager.sharedInstance.hideView()
            }
            if restStatus == RestStatus.success {
                if let imageItem = responceObject as IZSingleChatPictureModel? {
                    completed(imageItem)
                }
            }
        })
    }
    
    fileprivate func updateUserProfileMatch(_ recipientId : String) {
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIMatchOperations.matchedUserByIdOperation(recipientId, responce: { [weak self](responceObject, statusResponse) in
            
            guard let strongSelf = self else { return }
            
            if statusResponse == RestStatus.success {
                if let respObj = responceObject as IZMatchUserModel? {
                    let user = IZMatchUserModel.convertMatchUserToIZPushMatchItemModel(respObj)
                    strongSelf.router.showMatchProfileViewController(user, firstInterest: (user.interests?.first?.interest)!)
                }
            }
        })
    }
    
    fileprivate func updateMissedIndicator(){
        IZRestAPIInterestsOperations.updateNewMissedPushesOperation { (responceObject) in }
    }
}
