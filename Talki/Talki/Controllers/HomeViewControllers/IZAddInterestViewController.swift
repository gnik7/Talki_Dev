//
//  IZAddInterestViewController.swift
//  Talki
//
//  Created by Nikita Gil on 05.07.16.
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


class IZAddInterestViewController : IZBaseHomeViewController {

    //IBOutlet
    @IBOutlet weak var addInterestButton    : UIButton!
    @IBOutlet weak var addInterestTextField : UITextField!
    @IBOutlet weak var heightViewConstraint : NSLayoutConstraint!    
   
    //var
    
    //let
    let titleNavigationPanel = "Add Interest"
    let charset = CharacterSet(charactersIn: ".,+-/*&?:;()#№@!123456789")
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //topPanel add settings
        self.topFunctionalView?.delegate = self
        self.topFunctionalView?.updateUI(titleNavigationPanel , titleRightButton:nil , rightTitleText: nil , titleLeftButton: BackgroundLeftButton.backBackgroundLeftButton)
        
        //bottom panel
        self.bottomNavigationView?.updateUI(TypeBottomNavigationPanel.HomeTypeBottomNavigationPanel)
        
        // set ui
        self.updateUI()
        
        //set delegate textfield
        self.addInterestTextField.delegate = self
        
        //keyboard apearence
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        self.updateUI()
        self.addInterestButton.setNeedsDisplay()
        self.addInterestButton.layoutIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func updateUI() {
        self.addInterestButton.layer.cornerRadius = self.addInterestButton.frame.height / 2
        self.addInterestButton.clipsToBounds = true
        
        UITextField.appearance().tintColor = UIColor(red: 0.0, green: 178/255.0, blue: 191/255.0, alpha: 1.0)
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func addInterestButtonPressed(_ sender: UIButton) {
        
        self.checkField()
    }
    
    fileprivate func checkField() {
        if (self.addInterestTextField.text?.characters.isEmpty)! &&
            (self.addInterestTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)).characters.count == 0 {
            return
        }
        
        if self.addInterestTextField.text?.characters.count < 2 || self.addInterestTextField.text?.characters.count > 50 {
            self.view.endEditing(true)
            addInterestTextField.resignFirstResponder()
            self.loadAlert(AlertText.AddInterestCharactersRange.rawValue, text2: "")
            return
        }
        
        if self.addInterestTextField.text?.lowercased().rangeOfCharacter(from: charset) != nil {
            self.view.endEditing(true)
            addInterestTextField.resignFirstResponder()
            self.loadAlert("wrong charecters", text2: "")
            return
        }
        
        self.addInterestApiCall(self.addInterestTextField.text!)
    }
}

extension IZAddInterestViewController: TopFunctionalPanelDelegate {
    
    //*****************************************************************
    // MARK: - TopFunctionalPanelDelegate
    //*****************************************************************
    
    func rightButtonWasPressed() {
        print("rightButtonWasPressed")
    }
    
    func leftButtonWasPressed(){
        self.router.popToRootViewController()
//        if !(self.addInterestTextField.text?.characters.isEmpty)! &&
//            (self.addInterestTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())).characters.count > 0 {
//            self.gestureTap()
//            self.loadAlert(AlertText.LeaveAddInterestWithOutSave.rawValue, text2: "")
//            self.alertView?.delegate = self
//        } else {
//            self.router.popToRootViewController()
//        }
    }
}

extension IZAddInterestViewController: UITextFieldDelegate {
    
    //*****************************************************************
    // MARK: - UITextFieldDelegate
    //*****************************************************************
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.checkField()
        
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
  
        if string.characters.count > 0 {
            if string.containsEmoji() {
                return false
            }
            
            if string.characters.count == 1 {
                if !string.isValidInterest() {
                    return false
                } else {
                    return true
                }
            } else {
               
                return true
            }
        }
        return true
    }
}

extension IZAddInterestViewController {
    
    //*****************************************************************
    // MARK: - Api Call
    //*****************************************************************
    
    fileprivate func addInterestApiCall(_ title : String) {
        self.view.endEditing(true)
        if !IZReachability.isConnectedToNetwork() {            
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIInterestsOperations.addInterestCall(title, completed: { (statusResponse) in
            self.view.endEditing(true)
            if statusResponse == RestStatus.success {
                self.router.popToRootViewController()
                let alert = IZAlertCustom.loadFromXib()
                alert?.delegate = self
                let text = self.addInterestTextField.text! + " " + AlertText.SuccessfullAddInterest.rawValue
                alert?.updateData(text, text2: "")
                alert?.showView()
            }            
        })
    }
}

extension IZAddInterestViewController : IZAlertCustomDelegate {
    
    //*****************************************************************
    // MARK: - IZAlertCustomDelegate
    //*****************************************************************
    
    func okButtonWasPressed() {
        self.router.popViewController(true)
    }
}



