//
//  IZSettingsBaseViewController.swift
//  Talki
//
//  Created by Nikita Gil on 12.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import CoreLocation


class IZSettingsBaseViewController: UIViewController {
    
    @IBOutlet weak var topFunctionalPanelView       : UIView!
    @IBOutlet weak var bottomNavigationPanelView    : UIView!
    
    lazy var router             : IZRouter = IZRouter(navigationController: self.navigationController!)
    var topFunctionalView       : IZTopFunctionalPanel?
    var bottomNavigationView    : IZBottomNavigationPanel?
    var settingsCellModel       : IZSettingsCellModel?
    var selectedGender          : String?
    fileprivate var popGesture      : UIGestureRecognizer?
    var alertView               : IZAlertCustom?
    var saveButtonWasPressed = false
    
    let titleTopPanel = "Settings"
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load top navigation        
        self.topFunctionalView = IZTopFunctionalPanel.loadFromXib()
        self.topFunctionalView?.frame = CGRect(x: 0, y: 0, width: self.topFunctionalPanelView.frame.size.width, height: self.topFunctionalPanelView.frame.size.height)
        self.topFunctionalPanelView!.addSubview(self.topFunctionalView!)
        self.topFunctionalView?.delegate  = self
        
        // load bottom navigation
        self.bottomNavigationView = IZBottomNavigationPanel.loadFromXib()
        self.bottomNavigationView?.frame = CGRect(x: 0, y: 0, width: self.bottomNavigationPanelView.frame.size.width, height: self.bottomNavigationPanelView.frame.size.height)
        self.bottomNavigationView?.delegate = self
        self.bottomNavigationPanelView.addSubview(self.bottomNavigationView!)
        self.bottomNavigationView?.updateUI(TypeBottomNavigationPanel.SettingsTypeBottomNavigationPanel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //forbid swipe uiviewcontroller on uinavigation
        if self.navigationController!.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            
            self.popGesture = navigationController!.interactivePopGestureRecognizer
            self.navigationController!.view.removeGestureRecognizer(navigationController!.interactivePopGestureRecognizer!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //enable swipe uiviewcontroller on uinavigation
        if self.popGesture != nil {
            //navigationController!.view.addGestureRecognizer(self.popGesture!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func genderToString(_ gender : String) -> String {
        
        switch gender {
        case GenderSettingType.MenGenderSettingType.rawValue:
            return GenderSettingType.MenGenderApiSettingType.rawValue
            
        case GenderSettingType.WomenGenderSettingType.rawValue:
            return GenderSettingType.WomenGenderApiSettingType.rawValue
            
        case GenderSettingType.MenWomenGenderSettingType.rawValue:
            return GenderSettingType.MenWomenGenderApiSettingType.rawValue
            
        default:
            return GenderSettingType.MenWomenGenderApiSettingType.rawValue
        }
    }
    
    //*****************************************************************
    // MARK: - Load Alert
    //*****************************************************************
    
    func loadAlert(_ text1: String, text2: String) {
        IZAlertCustomManager.sharedInstance.showView(text1, text2: text2)
//        self.alertView = IZAlertCustom.loadFromXib()
//        self.alertView?.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
//        self.alertView?.updateData(text1, text2: text2)
//        self.alertView?.showView()
    }
}

extension IZSettingsBaseViewController: TopFunctionalPanelDelegate {
    
    //*****************************************************************
    // MARK: - TopFunctionalPanelDelegate
    //*****************************************************************
    
    func rightButtonWasPressed() {
        saveButtonWasPressed = true
        self.saveSettings()
    }
    
    func leftButtonWasPressed() {
        self.router.popViewController(true)
    }
}

extension IZSettingsBaseViewController : IZBottomNavigationPanelDelegate {
    
    //*****************************************************************
    // MARK: - IZBottomNavigationPanelDelegate
    //*****************************************************************
    
    func homeButtonWasPressed() {
        self.saveSettings()
        self.router.setupHomeRootViewController()
//        if IZRouter.switchToRootViewController() {
//            self.router.popToRootViewController()
//        } else {
//            self.router.setupHomeRootViewController()
//        }
    }
    
    func profileButtonWasPressed() {
        self.saveSettings()
        self.router.showProfileViewController(nil)
    }
    
    func matchHistoryButtonWasPressed() {
        self.saveSettings()
        self.router.showMatchHistoryViewController()
    }
    
    func chatButtonWasPressed() {
        self.saveSettings()
        self.router.showSavedChatsViewController()
    }
    
    func settingButtonWasPressed() {
        self.saveSettings()
        self.router.showSettingsViewController()
    }
}

extension IZSettingsBaseViewController {
    
    //*****************************************************************
    // MARK: - Api Calls
    //*****************************************************************
    
    fileprivate func saveSettings() {
        
        if !IZReachability.isConnectedToNetwork() {
            //self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        let notificationNewMatch = self.settingsCellModel?.newMatches
        let notificationMissedMatch = self.settingsCellModel?.missedMatchesUpdate
        let notificationUpdatedInterest = self.settingsCellModel?.interestsUpdate
        let notificationNewMessage = self.settingsCellModel?.messages
        let notificationPromotion = false
        let radius = self.settingsCellModel?.maxDistance
        let minAge = self.settingsCellModel?.ageMin
        let maxAge = self.settingsCellModel?.ageMax
        
        guard let gender = self.settingsCellModel?.genderType! else {
            return
        }
        
        let genderApi = self.genderToString(gender)
        
        IZRestAPISettingsOperations.settingsOperation(notificationNewMatch!,
                                                      notificationMissedMatch: notificationMissedMatch!,
                                                      notificationUpdatedInterest: notificationUpdatedInterest!,
                                                      notificationNewMessage: notificationNewMessage!,
                                                      notificationPromotion: notificationPromotion,
                                                      matchRadius: radius!,
                                                      matchAgeMin: minAge!,
                                                      matchAgeMax: maxAge!,
                                                      matchGender: genderApi,
            responce:{ (message, restStatus) in
             
                guard let status = restStatus as RestStatus? else {
                    return
                }
                if status == RestStatus.success {
                    if self.saveButtonWasPressed {
                        let placeHolder = IZPlaceHolderChecked.loadFromXib()
                        placeHolder?.showView()
                        let placeHolderDelay = (placeHolder?.totalTime)!
                        let delay = placeHolderDelay * Double(NSEC_PER_SEC)
                        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time, execute: {
                            self.router.popToRootViewController()
                        })
                        self.saveButtonWasPressed = false
                    }
                }
        })
    }
    
    func logoutRemovePushId () {
        
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIPushOperations.removePushIdOperation { (message, restStatus) in
            
            guard let status = restStatus as RestStatus? else {
                return
            }
            if status == RestStatus.success {
                self.clearDataUser()
                self.router.setupLoginRootViewController()
            }
        }
    }
    
    func deleteAccount() {
        
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        IZRestAPIPushOperations.removePushIdOperation { (message, restStatus) in
            
            guard let status = restStatus as RestStatus? else {
                return
            }
            if status == RestStatus.success {
                IZRestAPILoginOperations.deleteAccountOperation { (message, restStatus) in
                    
                    guard let status = restStatus as RestStatus? else {
                        return
                    }
                    
                    if status == RestStatus.success {
                        self.clearDataUser()
                        self.router.setupLoginRootViewController()
                    }
                }
            }
        }
    }
    
    fileprivate func clearDataUser() {
        IZUserDefaults.cleanTokenInUserDefault()
        IZUserDefaults.cleanFBTokenInUserDefault()
        IZUserDefaults.cleanFirstProfileUserDefault()
        IZUserDefaults.clearUserIdUserDefault()
        IZUserDefaults.cleanInterestHelperUserDefault()
        IZUserDefaults.cleanChatHelperUserDefault()
        IZUserDefaults.cleanCheckmarkedInterest()
        IZUserDefaults.cleanMissedMessage()
        IZUserDefaults.cleanMissedMatch()
        
        
        IZCurrentUserData.cleanUser()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if let location = (UIApplication.shared.delegate as? AppDelegate)?.locationManager {
            if CLLocationManager.locationServicesEnabled() {
                location.stopUpdatingLocation()
            }
        }
    }
}


