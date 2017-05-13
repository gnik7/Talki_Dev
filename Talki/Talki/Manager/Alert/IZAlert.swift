//
//  IZAlert.swift
//  Talki
//
//  Created by Nikita Gil on 01.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

enum AlertTitle : String {
    
    case TitleCommon = "Talki"
    case Error = "Error"
}

enum AlertText : String {
    
    case TitleNoInternet = "No Internet Connection"
    case NoInternetMessage = "No Internet Connection. Please connect your devivice with internet"
    case SuccessAutorization1 = "Your registration was successful"
    case FillTextField = "It seems like you didn't fill in your email and/or password. Make sure all fields are filled in"
    case FillTextFieldSignUp = "It seems like you didn't fill in your email and/or password. Please fill this out"
    case FillTextFieldForgotPassword = "It seems like you didn't enter a valid email address. Please try again"
    case WrongFillTextFieldForgotPassword = "It seems like you didn't fill in a valid email address. Please try again"
    case FillTextFieldProfile = "It seems like you didn't fill out all of your profile info. Please provide this info"
    
    case SuccessSend1 = "Password has been sent"
    case SuccessSend2 = "Please check your email"
    
    case NoCameraMessage = "Sorry,no camera detected on your device"
    case TakePhoto = "To take photo go to Gallery or Make photo"
    case SetDone = "You are all set and done!\nPress the iPhone Home Button to leave the app and Talki will look for matches"
    case ChooseGender = "Select your gender"
    case Bigger10MB = "Foto is bigger than 10 MB"
    
    case AddInterestCharactersRange = "Your interest must be between 2 and 50 characters"
    case SearchInterestNothing = "We didn’t find this interest in our database. To add it, press the red plus-sign "
    case LeaveAddInterestWithOutSave = "You need to save first to continue"
    case SuccessfullAddInterest = "interest has been added"
    
    case NotEqualPasswords = "It seems like you have entered two different passwords. Please try again"
    case NotEmail = "It seems that you have entered an invalid email address. Please try again"
    case WrongCountCharactersPasswords = "A password must contain more than 4 characters and no more than 20 characters"
    
    case FirstTimeProfile = "You first have to save your new data before leaving this view"
    case FirstTimeProfileSave = "Are you sure you have entered all the needed info?"
    
    case NeedWaitTillLoadSender = "Sorry, you need something wait a few second"
    
    case ProfileImageNotSet = "Please upload a profile picture"
    case ProfileNameWrongSet = "This seems like a non-existing name. Please provide a real name"
    case ProfileNameWrongCount = "Your name must at least contain 2 characters and not more than 20 characters"
    case ProfileSaved = "Saved"
    
    
    case LogoutAccount = "Are you sure you want to log out?"
    case RemoveAccount = "Are you sure you want to delete your account?"
    
    case AddPush = "You need to allow push notifications before authorization. You can disallow this later"
   
    case AddLocationChat = "Are you sure you want to send your location?"
    
    case twoMessageChat = "Talki stimulates offline talking, so you can only send 4 messages per match!"
    
    case matchDecline = "You declined this match.\n Review this match later in your match history if you like"
    case matchAccept = "You accepted this match.\n Great! let's wait for your match to accept"
    
    case UserBlocked = "You have been blocked by your opponent "

}

struct IZAlert {
    
    //*****************************************************************
    // MARK: - Simple
    //*****************************************************************
    
    static func showAlert(_ controller :UIViewController, title :String, message:String?, action: (() -> ())?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.cancel,
            handler: { act in
                if let action = action {
                    action()
                }
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertTwoButton(_ controller :UIViewController?, title :String, message:String?, doneOk: (() -> ())?,cancel: (() -> ())?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let done = doneOk {
                done()
            }
        }
        alertController.addAction(OkAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            if let cancel = cancel {
                cancel()
            }
        }
        alertController.addAction(cancelAction)
        
        if controller != nil {
            controller!.present(alertController, animated: true) {}
        }
    }
    
    //*****************************************************************
    // MARK: - Error Alert
    //*****************************************************************
    
    static func showAlertError(_ controller :UIViewController?, message:String?, done: (() -> ())?){
        
        let alertController = UIAlertController(title: AlertTitle.TitleCommon.rawValue, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let done = done {
                done()
            }
        }
        alertController.addAction(OKAction)
        
        if controller != nil {
            controller!.present(alertController, animated: true) { }
        }
    }
    //*****************************************************************
    // MARK: - Photo
    //*****************************************************************
    
    static func showAlertChoosePhoto(_ controller :UIViewController?, title :String, message:String?, doneLybrary: (() -> ())?, donePhoto: (() -> ())?,cancel: (() -> ())?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            if let done = doneLybrary {
                done()
            }
        }
        alertController.addAction(takeAction)
        
        let makeAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if let done = donePhoto {
                done()
            }
        }
        alertController.addAction(makeAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            if let cancel = cancel {
                cancel()
            }
        }
        alertController.addAction(cancelAction)
        
        if controller != nil {
            controller!.present(alertController, animated: true) {}
        }
    }
    
    //*****************************************************************
    // MARK: - Gender
    //*****************************************************************
    
    static func showAlertChooseGender(_ controller :UIViewController?, title :String, message:String?, doneGender: ((_ gender : String) -> ())? ,cancel: (() -> ())?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let femaleAction = UIAlertAction(title: "Female", style: .default) { (action) in
            if let done = doneGender {
                done("Female")
            }
        }
        alertController.addAction(femaleAction)
        
        let maleAction = UIAlertAction(title: "Male", style: .default) { (action) in
            if let done = doneGender {
                done("Male")
            }
        }
        alertController.addAction(maleAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            if let cancel = cancel {
                cancel()
            }
        }
        alertController.addAction(cancelAction)
        
        if controller != nil {
            controller!.present(alertController, animated: true) {}
        }
    }
}

