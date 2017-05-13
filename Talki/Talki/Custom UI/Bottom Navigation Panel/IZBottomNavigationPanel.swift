//
//  IZBottomNavigationPanel.swift
//  Talki
//
//  Created by Nikita Gil on 01.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

enum TypeBottomNavigationPanel : String {
    case HomeTypeBottomNavigationPanel = "home"
    case ProfileTypeBottomNavigationPanel = "profile"
    case ChatTypeBottomNavigationPanel = "chat"
    case HistoryTypeBottomNavigationPanel = "history"
    case SettingsTypeBottomNavigationPanel = "settings"
}

protocol IZBottomNavigationPanelDelegate: NSObjectProtocol {
    func homeButtonWasPressed()
    func profileButtonWasPressed()
    func matchHistoryButtonWasPressed()
    func chatButtonWasPressed()
    func settingButtonWasPressed()
}

class IZBottomNavigationPanel: UIView {
    
    // IBOutlet
    @IBOutlet weak var homeView             : UIView!
    @IBOutlet weak var profileView          : UIView!
    @IBOutlet weak var chatView             : UIView!
    @IBOutlet weak var matchedHistoryView   : UIView!
    @IBOutlet weak var settingsView         : UIView!
    
    @IBOutlet weak var homeImageView            : UIImageView!
    @IBOutlet weak var profileImageView         : UIImageView!
    @IBOutlet weak var chatImageView            : UIImageView!
    @IBOutlet weak var matchedHistoryImageView  : UIImageView!
    @IBOutlet weak var settingsImageView        : UIImageView!
    
    @IBOutlet weak var missedChatMessageView    : UIView!
    @IBOutlet weak var missedMatchView          : UIView!
    
    // var
    weak var delegate               : IZBottomNavigationPanelDelegate?
    fileprivate var viewsArray          : [UIView]!
    fileprivate var imageViewsArray     : [UIImageView]!
    fileprivate var isEnable            : Bool!
    fileprivate var alertView           : IZAlertCustom?
    
    fileprivate var currentType: TypeBottomNavigationPanel = .HomeTypeBottomNavigationPanel
    
    //let
    let defaultColor = UIColor.white
    let selectedColor = UIColor(red: 234.0/255.0, green: 96.0/255.0, blue: 83.0/255.0, alpha: 1.0)
    
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.viewsArray = [homeView, profileView, chatView, matchedHistoryView, settingsView]
        self.imageViewsArray = [homeImageView, profileImageView, chatImageView, matchedHistoryImageView, settingsImageView]
        
        self.isEnable = IZUserDefaults.isFirstProfileUserDefault()
        NotificationCenter.default.addObserver(self, selector: #selector(updatePanelForMatch), name: NSNotification.Name(rawValue: missedMathPushNotification) , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatePanelForMessage), name: NSNotification.Name(rawValue: missedMessagePushNotification) , object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        missedChatMessageView.cornerRadius = missedChatMessageView.frame.width / 2
        missedChatMessageView.clipsToBounds = true
        missedMatchView.cornerRadius = missedMatchView.frame.width / 2
        missedMatchView.clipsToBounds = true
    }
    
    fileprivate func updateIndicator() {
        missedChatMessageView.setNeedsDisplay()
        missedChatMessageView.layoutIfNeeded()
        missedMatchView.setNeedsDisplay()
        missedMatchView.layoutIfNeeded()
        missedChatMessageView.isHidden = true
        missedMatchView.isHidden = true
    }
    
    /**
     Get IZBottomNavigationPanel from xib
     
     - parameter bundle: bundle for search. Default nil
     
     - returns: object IZBottomNavigationPanel
     */
    
    class func loadFromXib(_ bundle : Bundle? = nil) -> IZBottomNavigationPanel? {
        return UINib(
            nibName: IZRouterConstant.kIZBottomNavigationPanel,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? IZBottomNavigationPanel
    }
    
    //*****************************************************************
    // MARK: - UI
    //*****************************************************************
    
    func updateUI(_ type : TypeBottomNavigationPanel) {
        self.currentType = type
        self.defaultColorAllViews()
        
        self.missedPushIndicator()
        
        switch type {
            
        case .HomeTypeBottomNavigationPanel:
            self.homeView.backgroundColor = selectedColor
            self.homeImageView.image = UIImage(named: "active_botom_panel_\(type.rawValue)")
            
        case .ProfileTypeBottomNavigationPanel:
            self.profileView.backgroundColor = selectedColor
            self.profileImageView.image = UIImage(named: "active_botom_panel_\(type.rawValue)")
            
            
        case .ChatTypeBottomNavigationPanel:
            self.chatView.backgroundColor = selectedColor
            self.chatImageView.image = UIImage(named: "active_botom_panel_\(type.rawValue)")
            if IZUserDefaults.getMissedMessage() > 0 {
                missedChatMessageView.backgroundColor = defaultColor
            }
            
        case .HistoryTypeBottomNavigationPanel:
            self.matchedHistoryView.backgroundColor = selectedColor
            self.matchedHistoryImageView.image = UIImage(named: "active_botom_panel_\(type.rawValue)")
            if IZUserDefaults.getMissedMatch() > 0 {
                missedMatchView.backgroundColor = defaultColor
            }
            
        case .SettingsTypeBottomNavigationPanel:
            self.settingsView.backgroundColor = selectedColor
            self.settingsImageView.image = UIImage(named: "active_botom_panel_\(type.rawValue)")
        }
    }
    
    fileprivate func defaultColorAllViews(){
        for (i, _) in self.viewsArray.enumerated() {
            self.viewsArray[i].backgroundColor = self.defaultColor
            self.imageViewsArray[i].image = UIImage(named: "default_botom_panel_\(i + 1)")
        }
    }
    
    fileprivate func missedPushIndicator() {
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if IZUserDefaults.getMissedMatch() > 0 {
            self.missedMatchView.backgroundColor = self.selectedColor
            self.missedMatchView.isHidden = false
        } else {
            self.missedMatchView.isHidden = true
        }
        if IZUserDefaults.getMissedMessage() > 0 {
            self.missedChatMessageView.backgroundColor = self.selectedColor
            self.missedChatMessageView.isHidden = false
        } else {
            self.missedChatMessageView.isHidden = true
        }
        //})
    }
    
    fileprivate func hideMissedPushIndicator() {
        DispatchQueue.main.async(execute: { () -> Void in
            if IZUserDefaults.getMissedMatch() > 0 {
                self.missedMatchView.backgroundColor = self.defaultColor
                self.missedMatchView.isHidden = false
            } else {
                self.missedMatchView.isHidden = true
            }
            if IZUserDefaults.getMissedMessage() > 0 {
                self.missedChatMessageView.backgroundColor = self.defaultColor
                self.missedChatMessageView.isHidden = false
            } else {
                self.missedChatMessageView.isHidden = true
            }
        })
    }

    
    //*****************************************************************
    // MARK: - Notification
    //*****************************************************************
    
    func updatePanelForMatch() {
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.missedMatchView.isHidden = false
            
            if self.currentType == .HistoryTypeBottomNavigationPanel {
                self.missedMatchView.backgroundColor = self.defaultColor
            } else {
                self.missedMatchView.backgroundColor = self.selectedColor
            }
            
            if IZUserDefaults.getMissedMatch() == 0 {
                self.missedMatchView.isHidden = true
            }
        })
    }
    
    func updatePanelForMessage() {
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.missedChatMessageView.isHidden = false
            
            if self.currentType == .ChatTypeBottomNavigationPanel {
                self.missedChatMessageView.backgroundColor = self.defaultColor
            } else {
                self.missedChatMessageView.backgroundColor = self.selectedColor
            }
            
            if IZUserDefaults.getMissedMessage() == 0 {
                self.missedChatMessageView.isHidden = true
            }
        })
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        
        if !self.isEnable {
            self.loadAlert(AlertText.FirstTimeProfile.rawValue, text2: "")
            return
        }
        
        if let delegate = self.delegate as IZBottomNavigationPanelDelegate?  {
            delegate.homeButtonWasPressed()
        }
    }
    
    @IBAction func profileButtonPressed(_ sender: UIButton) {
        
        if !self.isEnable {
            self.loadAlert(AlertText.FirstTimeProfile.rawValue, text2: "")
            return
        }
        
        if let delegate = self.delegate as IZBottomNavigationPanelDelegate?  {
            delegate.profileButtonWasPressed()
        }
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        
        if !self.isEnable {
            self.loadAlert(AlertText.FirstTimeProfile.rawValue, text2: "")
            return
        }
        
        if let delegate = self.delegate as IZBottomNavigationPanelDelegate?  {
            delegate.chatButtonWasPressed()
        }
    }
    
    @IBAction func matchHistoryButtonPressed(_ sender: UIButton) {
        
        if !self.isEnable {
            self.loadAlert(AlertText.FirstTimeProfile.rawValue, text2: "")
            return
        }
        
        if let delegate = self.delegate as IZBottomNavigationPanelDelegate?  {
            delegate.matchHistoryButtonWasPressed()
        }
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        
        if !self.isEnable {
            self.loadAlert(AlertText.FirstTimeProfile.rawValue, text2: "")
            return
        }
        
        if let delegate = self.delegate as IZBottomNavigationPanelDelegate?  {
            delegate.settingButtonWasPressed()
        }
    }
    
    //*****************************************************************
    // MARK: - Load Alert
    //*****************************************************************
    
    func loadAlert(_ text1: String, text2: String) {

        IZAlertCustomManager.sharedInstance.showView(text1, text2: text2)
        
//        self.alertView = IZAlertCustom.loadFromXib()
//        self.alertView?.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(UIScreen.mainScreen().bounds))
//        self.alertView?.updateData(text1, text2: text2)
//        self.alertView?.showView()
    }
    
}

