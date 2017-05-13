//
//  IZSettingsViewController.swift
//  Talki
//
//  Created by Nikita Gil on 11.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZSettingsViewController : IZSettingsBaseViewController {

    @IBOutlet weak var settingsTableView: UITableView!    
    
    //var   
    var settingDataArray : [IZSettingsCellModel]!
    
    let rightButtonTitle = "Done"
    let genderCellNumber = 2
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load top navigation
        self.loadTopBar()
        
        //registrate cells for tableView
        self.registrateCell()
        
        //get user settings
        self.userUpdateSettings()
        
        // asign settingsTableView
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if selectedGender != nil {
            self.settingsCellModel?.genderType = self.selectedGender
            self.settingDataArray[genderCellNumber].genderType = self.selectedGender
            self.settingsTableView.reloadRows(at: [IndexPath(row: genderCellNumber, section: 0)], with: UITableViewRowAnimation.fade)
        }
    }
    
    fileprivate func loadTopBar() {

        self.topFunctionalView!.updateUI(self.titleTopPanel, titleRightButton :BackgroundRightButton.textBackgroundRightButton, rightTitleText : self.rightButtonTitle, titleLeftButton : nil)
    }
    
    fileprivate func registrateCell() {
        
        let (classNameHeaderCell ,nibHeaderCell) = NSObject.classNibFromString(IZHeaderSettingTableViewCell.self)
        guard let headerCell = classNameHeaderCell as String?, let headerCellNib = nibHeaderCell as UINib? else {
            return
        }
        self.settingsTableView.register(headerCellNib, forCellReuseIdentifier: headerCell)
        
        let (classNameGenderCell ,nibGenderCell) = NSObject.classNibFromString(IZGenderSettingTableViewCell.self)
        guard let genderCell = classNameGenderCell as String?, let genderCellNib = nibGenderCell as UINib? else {
            return
        }
        self.settingsTableView.register(genderCellNib, forCellReuseIdentifier: genderCell)
        
        let (classNameMaxDistanceCell ,nibMaxDistanceCell) = NSObject.classNibFromString(IZMaxDistanceSettingTableViewCell.self)
        guard let maxDistanceCell = classNameMaxDistanceCell as String?, let maxDistanceNib = nibMaxDistanceCell as UINib? else {
            return
        }
        self.settingsTableView.register(maxDistanceNib, forCellReuseIdentifier: maxDistanceCell)
        
        let (classNameAgeCell ,nibAgeCell) = NSObject.classNibFromString(IZAgeSettingTableViewCell.self)
        guard let ageCell = classNameAgeCell as String?, let ageNib = nibAgeCell as UINib? else {
            return
        }
        self.settingsTableView.register(ageNib, forCellReuseIdentifier: ageCell)
        
        let (classNameCheckCell ,nibCheckCell) = NSObject.classNibFromString(IZCheckSettingTableViewCell.self)
        guard let checkCell = classNameCheckCell as String?, let checkNib = nibCheckCell as UINib? else {
            return
        }
        self.settingsTableView.register(checkNib, forCellReuseIdentifier: checkCell)
        
        let (classNameButtonCell ,nibButtonCell) = NSObject.classNibFromString(IZButtonsSettingTableViewCell.self)
        guard let buttonCell = classNameButtonCell as String?, let buttonNib = nibButtonCell as UINib? else {
            return
        }
        self.settingsTableView.register(buttonNib, forCellReuseIdentifier: buttonCell)
    }
    
}

extension IZSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.settingDataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.settingDataArray[indexPath.row].heightCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.settingDataArray[indexPath.row]
        let type = item.typeCell.rawValue
        
        let cell = tableView.dequeueReusableCell(withIdentifier: type)
        (cell as! IZGenericCell).delegate = self
        (cell as! IZGenericCell).updateData(item)

        return cell!
    }
}

extension IZSettingsViewController: IZGenericCellDelegate {
    
    //*****************************************************************
    // MARK: - Cells Delegates
    //*****************************************************************
    
    func selectedDistance(_ value : Int) {
        self.settingsCellModel?.maxDistance = value
    }
    
    func typeGenderButtonWasPressed(){
        
        self.selectedGender = self.settingsCellModel?.genderType
        self.router.showGenderSettingsViewController(self.selectedGender, parentViewController: self)
    }
    
    func selectedAge(_ minAge : Int, maxAge : Int) {
        self.settingsCellModel?.ageMin = minAge
        self.settingsCellModel?.ageMax = maxAge
    }
    
    func checkedCellWithType(_ typeCell : SettingsTypeCell, state : Bool, notificationType : NotificationType) {
        switch notificationType {
            
        case NotificationType.newMatchesNotificationType : self.settingsCellModel?.newMatches = state
        case NotificationType.missedMatchesNotificationType : self.settingsCellModel?.missedMatchesUpdate = state
        case NotificationType.interestNotificationType : self.settingsCellModel?.interestsUpdate = state
        case NotificationType.messagesNotificationType : self.settingsCellModel?.messages = state
        }
    }
    
    func logoutButtonWasPressed() {
        let alertView = IZAlertView.loadFromXib()
        alertView?.showViewWithCustomButtons(AlertText.LogoutAccount.rawValue, action: {
            self.logoutRemovePushId()
        })
    }
    
    func deleteAccountButtonWasPressed() {
        let alertView = IZAlertView.loadFromXib()
        alertView?.showViewWithCustomButtons(AlertText.RemoveAccount.rawValue, action: {
            self.deleteAccount()
        })
    }
}

extension IZSettingsViewController:  IZGenderChooseToParentDelegate {
    
    func genderWasChoose(_ type :String?) {
        self.selectedGender = type
    }
}

extension IZSettingsViewController {
    
    //*****************************************************************
    // MARK: - Api Calls
    //*****************************************************************
    
    fileprivate func userUpdateSettings() {
        
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPISettingsOperations.userGetSettingsOperation { (responceObject, statusResponse) in
            
            if statusResponse == RestStatus.success {
                if let userSettings = responceObject as IZSettingsModel? {
                    self.settingsCellModel = IZSettingsCellModel.settingsModetToCells(userSettings)
                    self.settingDataArray = IZSettingsCellModel.setupAllTableCell(self.settingsCellModel!)
                    self.settingsTableView.reloadData()
                }
            }
        }
    }
}





