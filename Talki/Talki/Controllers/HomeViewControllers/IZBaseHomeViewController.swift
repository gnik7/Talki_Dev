//
//  IZBaseHomeViewController.swift
//  Talki
//
//  Created by Nikita Gil on 30.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import TextFieldEffects

/** 
 - IZBaseHomeViewController is base for next ViewControllers
     |                      |                       |
     V                      V                       V
  IZHomeViewController | IZProfileViewController | IZMatchedHistoryViewController | IZSavedChatsViewController
 */

class IZBaseHomeViewController: UIViewController {
    
    
    @IBOutlet weak var topFunctionalPanelView       : UIView!
    @IBOutlet weak var bottomNavigationPanelView    : UIView!
    
    //var
    lazy var router :IZRouter = IZRouter(navigationController: self.navigationController!)
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IZBaseHomeViewController.gestureTap))
    
    var topFunctionalView       :IZTopFunctionalPanel?
    var bottomNavigationView    :IZBottomNavigationPanel?
    var alertView               : IZAlertCustom?
  
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // load top navigation
        self.topFunctionalView = IZTopFunctionalPanel.loadFromXib()
        self.topFunctionalView?.frame = CGRect(x: 0, y: 0, width: self.topFunctionalPanelView.frame.size.width, height: self.topFunctionalPanelView.frame.size.height)        
        self.topFunctionalPanelView!.addSubview(self.topFunctionalView!)

        // load bottom navigation
        self.bottomNavigationView = IZBottomNavigationPanel.loadFromXib()
        self.bottomNavigationView?.frame = CGRect(x: 0, y: 0, width: self.bottomNavigationPanelView.frame.size.width, height: self.bottomNavigationPanelView.frame.size.height)
        self.bottomNavigationView?.delegate = self
        self.bottomNavigationPanelView.addSubview(self.bottomNavigationView!)        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    final func gestureTap() {
        self.view.endEditing(true)
    }
    
    //*****************************************************************
    // MARK: - Notification
    //*****************************************************************
    
    func keyboardWasShown(_ aNotification:Notification) {        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func keyboardWillBeHidden(_ aNotification:Notification) {
        self.view.removeGestureRecognizer(tapGesture)
    }
    
    //*****************************************************************
    // MARK: - Check TextFiels
    //*****************************************************************
    
    func checkForEmptyTextField(_ textField :HoshiTextField) -> Bool {
        
        if textField.text!.characters.isEmpty ||
            (textField.text!.trimmingCharacters(in: CharacterSet.whitespaces)).characters.count == 0  {
            return false
        }
        return true
    }
    
    //*****************************************************************
    // MARK: - Load Alert
    //*****************************************************************
    
    func loadAlert(_ text1: String, text2: String) {
        IZAlertCustomManager.sharedInstance.showView(text1, text2: text2)
    }
    
    func loadAlertOk(_ text1: String, text2: String) {
        self.alertView = IZAlertCustom.loadFromXib()
        self.alertView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.alertView?.updateData(text1, text2: text2)
        self.alertView?.showView()
    }
}

extension IZBaseHomeViewController : IZBottomNavigationPanelDelegate {
    
    //*****************************************************************
    // MARK: - IZBottomNavigationPanelDelegate
    //*****************************************************************
    
    func homeButtonWasPressed() {
        
        let root = self.navigationController?.viewControllers[0]
        if root!.isKind(of: IZMatchViewController.self) || root!.isKind(of: IZMatchStartChatViewController.self) || root!.isKind(of: IZLoginViewController.self) {
            self.router.setupHomeRootViewController()
            return
        }
        
        if IZRouter.switchToRootViewController() {
            self.router.popToRootViewController()
        } else {
            self.router.setupHomeRootViewController()
        }
    }
    
    func profileButtonWasPressed() {
        let visibleVC = self.router.visibleViewController()
        if visibleVC.isKind(of: IZProfileViewController.self) {
            return
        }
        self.router.showProfileViewController(nil)
    }
    
    func matchHistoryButtonWasPressed() {
        self.router.showMatchHistoryViewController()
    }
    
    func chatButtonWasPressed() {
        self.router.showSavedChatsViewController()
    }
    
    func settingButtonWasPressed() {
        self.router.showSettingsViewController()
    }
}





