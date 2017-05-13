//
//  IZGenderSettingsViewController.swift
//  Talki
//
//  Created by Nikita Gil on 12.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit


enum GenderSettingType : String {
    case MenGenderSettingType       = "Only Men"
    case WomenGenderSettingType     = "Only Women"
    case MenWomenGenderSettingType  = "Men and Women"
    
    case MenGenderApiSettingType        = "male"
    case WomenGenderApiSettingType      = "female"
    case MenWomenGenderApiSettingType   = "all"
}

class IZGenderSettingsViewController: IZSettingsBaseViewController {
    
    @IBOutlet weak var genderTableView: UITableView!
    
    //var
    var genderArray     : [String]!
    var genderType      : String?
    weak var parentVC   : IZSettingsViewController!
    
    //let
    let heightCell :CGFloat = 44.0
    let titleTopPanelGender = "Select Gender"
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load top navigation
        self.loadTopBar()
        
        // init data for table
        self.genderArray = [GenderSettingType.MenGenderSettingType.rawValue, GenderSettingType.WomenGenderSettingType.rawValue, GenderSettingType.MenWomenGenderSettingType.rawValue]
        
        //registrate cells for tableView
        self.registrateCell()
        
        // asign settingsTableView
        self.genderTableView.delegate = self
        self.genderTableView.dataSource = self
        
        self.genderTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        if let type = self.selectedGender as String? {
            self.genderType = type
        } else {
            self.genderType = nil
        }
    }
    
    fileprivate func loadTopBar() {       
        
        self.topFunctionalView!.updateUI(self.titleTopPanelGender, titleRightButton : nil, rightTitleText : nil, titleLeftButton : BackgroundLeftButton.backBackgroundLeftButton)
    }
    
    fileprivate func registrateCell() {
        
        let (classNameCell ,nibClassCell) = NSObject.classNibFromString(IZGenderChooseSettingTableViewCell.self)
        guard let nameCell = classNameCell as String?, let cellNib = nibClassCell as UINib? else {
            return
        }
        self.genderTableView.register(cellNib, forCellReuseIdentifier: nameCell)
    }
}

extension IZGenderSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.genderArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IZGenderChooseSettingTableViewCell.self)) as! IZGenderChooseSettingTableViewCell
        cell.updateData(self.genderType, setting: self.genderArray[indexPath.row])
        cell.delegate = self
        cell.delegateParent = parentVC

        return cell
    }    
}

extension IZGenderSettingsViewController : IZGenderChooseDelegate {
    
    //*****************************************************************
    // MARK: - IZGenderChooseDelegate
    //*****************************************************************
    
    func genderWasChoose(_ type :String?) {

        self.selectedGender = type
        self.genderType = type
        self.genderTableView.reloadData()
    }
}






