//
//  IZSettingsCellModel.swift
//  Talki
//
//  Created by Nikita Gil on 05.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

enum SettingsTypeCell:String {
    
    case HeaderTypeCell = "IZHeaderSettingTableViewCell"
    case MaxDistanceTypeCell = "IZMaxDistanceSettingTableViewCell"
    case GenderTypeCell = "IZGenderSettingTableViewCell"
    case AgeTypeCell = "IZAgeSettingTableViewCell"
    case CheckTypeCell = "IZCheckSettingTableViewCell"
    case ButtonsTypeCell = "IZButtonsSettingTableViewCell"
}

enum NotificationType {
    case newMatchesNotificationType
    case missedMatchesNotificationType
    case interestNotificationType
    case messagesNotificationType
}

struct IZHeightCell  {
    
    static let heightHeader : CGFloat = 45.0
    static let heightDistance : CGFloat = 80.0
    static let heightGender : CGFloat = 50.0
    static let heightAge : CGFloat = 80.0
    static let heightSelect : CGFloat = 50.0
    static let heightButtons : CGFloat = 90.0
}

class IZSettingsCellModel {
    
    var typeCell            : SettingsTypeCell!
    var title               : String?
    
    var genderType          : String!
    var maxDistance         : Int!
    var ageMin              : Int!
    var ageMax              : Int!
    
    var newMatches          : Bool!
    var missedMatchesUpdate : Bool!
    var interestsUpdate     : Bool!
    var messages            : Bool!
    var notificationType    : NotificationType?
    
    var checkboxSelected    : Bool?
    var heightCell          : CGFloat!
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    init(){
        self.maxDistance = 250
        self.genderType = "Men and Women"
        self.ageMin = 10
        self.ageMax = 90
        self.newMatches = true
        self.missedMatchesUpdate = true
        self.interestsUpdate = false
        self.messages = true
    }
    
    init(typeCell :SettingsTypeCell, title :String?, genderType :String?, maxDistance :Int?, ageMin :Int?, ageMax :Int?, checkboxSelected :Bool?, heightCell : CGFloat, notificationType: NotificationType?){
        self.typeCell = typeCell
        self.title = title
        self.genderType = genderType
        self.maxDistance = maxDistance
        self.ageMin = ageMin
        self.ageMax = ageMax
        self.checkboxSelected = checkboxSelected
        self.heightCell = heightCell
        self.notificationType = notificationType
    }
    /*  // TODO: Delete
    class func setupAllTableCell() -> [IZSettingsCellModel] {
        
        let header1 = IZSettingsCellModel(typeCell: SettingsTypeCell.HeaderTypeCell , title: "Match Settings", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: 35.0, notificationType: nil)
        let maxDistance2 = IZSettingsCellModel(typeCell: SettingsTypeCell.MaxDistanceTypeCell, title: "Maximum distance", genderType: nil, maxDistance: 250, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: 60.0, notificationType: nil)
        let gender3 = IZSettingsCellModel(typeCell: SettingsTypeCell.GenderTypeCell, title: "Gender", genderType: "Men and Women", maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: 44.0, notificationType: nil)
        let age4 = IZSettingsCellModel(typeCell: SettingsTypeCell.AgeTypeCell, title: "Age", genderType: nil, maxDistance: nil, ageMin: 16, ageMax: 25, checkboxSelected: nil, heightCell: 60.0, notificationType: nil)
        
        let header5 = IZSettingsCellModel(typeCell: SettingsTypeCell.HeaderTypeCell , title: "Push Notifications", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: 35.0, notificationType: nil)
        let check6 = IZSettingsCellModel(typeCell: SettingsTypeCell.CheckTypeCell, title: "New Matches", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: true, heightCell: 40.0, notificationType: NotificationType.NewMatchesNotificationType)
        let check7 = IZSettingsCellModel(typeCell: SettingsTypeCell.CheckTypeCell, title: "Missed Matches update", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: true, heightCell: 40.0, notificationType: NotificationType.MissedMatchesNotificationType)
        let check8 = IZSettingsCellModel(typeCell: SettingsTypeCell.CheckTypeCell, title: "Interests update", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: false, heightCell: 40.0, notificationType: NotificationType.InterestNotificationType)
        let check9 = IZSettingsCellModel(typeCell: SettingsTypeCell.CheckTypeCell, title: "Messages", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: true, heightCell: 40.0, notificationType: NotificationType.MessagesNotificationType)
        
        let buttons10 = IZSettingsCellModel(typeCell: SettingsTypeCell.ButtonsTypeCell, title: nil, genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: 100.0, notificationType: nil)
        
        return [header1, maxDistance2, gender3 , age4 , header5, check6, check7, check8, check9, buttons10]
    }
    */
    
    //*****************************************************************
    // MARK: - Setup Table data for cell
    //*****************************************************************
    
    class func setupAllTableCell(_ cellModel : IZSettingsCellModel) -> [IZSettingsCellModel] {
        
        let header1 = IZSettingsCellModel(typeCell: SettingsTypeCell.HeaderTypeCell , title: "Match Settings", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: IZHeightCell.heightHeader , notificationType: nil)
        let maxDistance2 = IZSettingsCellModel(typeCell: SettingsTypeCell.MaxDistanceTypeCell, title: "Maximum Distance", genderType: nil, maxDistance: cellModel.maxDistance, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: IZHeightCell.heightDistance , notificationType: nil)
        let gender3 = IZSettingsCellModel(typeCell: SettingsTypeCell.GenderTypeCell, title: "Match me with", genderType: cellModel.genderType, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: IZHeightCell.heightGender, notificationType: nil)
        let age4 = IZSettingsCellModel(typeCell: SettingsTypeCell.AgeTypeCell, title: "Age", genderType: nil, maxDistance: nil, ageMin: cellModel.ageMin, ageMax: cellModel.ageMax, checkboxSelected: nil, heightCell: IZHeightCell.heightAge, notificationType: nil)
        
        let header5 = IZSettingsCellModel(typeCell: SettingsTypeCell.HeaderTypeCell , title: "Push Notifications", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: IZHeightCell.heightHeader, notificationType: nil)
        let check6 = IZSettingsCellModel(typeCell: SettingsTypeCell.CheckTypeCell, title: "New Matches", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: cellModel.newMatches, heightCell: 40.0, notificationType: NotificationType.newMatchesNotificationType)
        let check7 = IZSettingsCellModel(typeCell: SettingsTypeCell.CheckTypeCell, title: "Missed Matches Update", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: cellModel.missedMatchesUpdate, heightCell: 40.0, notificationType: NotificationType.missedMatchesNotificationType)
        let check8 = IZSettingsCellModel(typeCell: SettingsTypeCell.CheckTypeCell, title: "Interests Update", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: cellModel.interestsUpdate, heightCell: 40.0, notificationType: NotificationType.interestNotificationType)
        let check9 = IZSettingsCellModel(typeCell: SettingsTypeCell.CheckTypeCell, title: "Messages", genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: cellModel.messages, heightCell: 40.0, notificationType: NotificationType.messagesNotificationType)
        
        let buttons10 = IZSettingsCellModel(typeCell: SettingsTypeCell.ButtonsTypeCell, title: nil, genderType: nil, maxDistance: nil, ageMin: nil, ageMax: nil, checkboxSelected: nil, heightCell: 100.0, notificationType: nil)
        
        return [header1, maxDistance2, gender3 , age4 , header5, check6, check7, check8, check9, buttons10]
    }
    
    //*****************************************************************
    // MARK: - Converters
    //*****************************************************************
    
    class func settingsModetToCells(_ model : IZSettingsModel) -> IZSettingsCellModel {
        
        let cellModel = IZSettingsCellModel()
        
        cellModel.newMatches = model.notificationNewMatch
        cellModel.missedMatchesUpdate = model.notificationMissedMatch
        cellModel.interestsUpdate = model.notificationUpdatedInterest
        cellModel.messages = model.notificationNewMessage
        cellModel.maxDistance = model.matchRadius
        cellModel.ageMin = model.matchAgeMin
        cellModel.ageMax = model.matchAgeMax
        
        guard let gender = model.matchGender as String? else {
            return cellModel
        }
        cellModel.genderType = IZSettingsCellModel.convertGenderFromApiToUI(gender)
        
        return cellModel
    }
    
    class func convertGenderFromApiToUI(_ genderApi : String) -> String {
        
        switch genderApi {
            case GenderSettingType.MenGenderApiSettingType.rawValue :
                return GenderSettingType.MenGenderSettingType.rawValue
            
            case GenderSettingType.WomenGenderApiSettingType.rawValue :
                return GenderSettingType.WomenGenderSettingType.rawValue
            
            case GenderSettingType.MenWomenGenderApiSettingType.rawValue :
                return GenderSettingType.MenWomenGenderSettingType.rawValue
            
            default : break
        }
        return ""
    }
}


