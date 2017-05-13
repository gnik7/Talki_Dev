//
//  IZChatBaseViewController.swift
//  Talki
//
//  Created by Nikita Gil on 13.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import MobileCoreServices

/**
 - IZChatBaseViewController is base for ->  IZChatViewController
 */

class IZChatBaseViewController: UIViewController {
    
    @IBOutlet weak var chatTableView    : UITableView!
    
    //var
    lazy var router :IZRouter = IZRouter(navigationController: self.navigationController!)
    lazy var tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IZBaseHomeViewController.gestureTap))
    
    lazy var imagePicker : IZCameraController = self.initCameraController()
    
    var completion : ((_ image : UIImage) -> ())?
    
    var yPositionView : CGFloat = 0.0
    var fullKeyboard: Bool = false
    var isArrayIsNotEmpty = false
    var alertView     : IZAlertCustom?
    var isPhotoControllerEnabled = false
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITextField.appearance().tintColor = UIColor(red: 0.0, green: 178/255.0, blue: 191/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.yPositionView = self.view.frame.size.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    final func gestureTap() {
        self.view.endEditing(true)
    }
    
    fileprivate func initCameraController() -> IZCameraController {
        self.isPhotoControllerEnabled = true
        let imagePicker = IZCameraController()
        return imagePicker
    }
    
    //*****************************************************************
    // MARK: - Load Alert
    //*****************************************************************
    
    func loadAlert(_ text1: String, text2: String) {
        gestureTap()
        IZAlertCustomManager.sharedInstance.showView(text1, text2: text2)
//        self.alertView = IZAlertCustom.loadFromXib()
//        self.alertView?.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
//        self.alertView?.updateData(text1, text2: text2)
//        self.alertView?.showView()
    }
    
    //*****************************************************************
    // MARK: - Notification
    //*****************************************************************
    
    func keyboardWasShown(_ aNotification:Notification) {
        
        var info = aNotification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if  self.view.frame.size.height == self.yPositionView {
            if keyboardFrame.size.height != 0 {
                UIView.animate(withDuration: 0.4, animations: {
                    
                    self.view.frame.size.height = self.view.frame.size.height - (keyboardFrame.size.height)
                    self.countLastCells()
                    }, completion: { (finished) in                        
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.view.frame.origin.y = -70
                    })
                })
            }
            self.view.addGestureRecognizer(tapGesture)
        }
    }
    
    func keyboardWillBeHidden(_ aNotification:Notification) {
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame.size.height = self.yPositionView
        })

        self.view.removeGestureRecognizer(tapGesture)
    }
    
    //*****************************************************************
    // MARK: - Check textView
    //*****************************************************************
    
    func checkForEmptyTextField(_ textField :UITextView) -> Bool {
        
        if textField.text!.characters.isEmpty || (textField.text!.trimmingCharacters(in: CharacterSet.whitespaces)).characters.count == 0  {
            return false
        }
        return true
    }
    
    //*****************************************************************
    // MARK: - Count Last Cell
    //*****************************************************************
    
    func countLastCells()  {
        if !self.isArrayIsNotEmpty {
            return
        }
        let sectionLastNumber = self.chatTableView.numberOfSections - 1
        let lastRowInSection = self.chatTableView.numberOfRows(inSection: sectionLastNumber) - 1
        let index = IndexPath(row: lastRowInSection, section: sectionLastNumber)
        
        let delay = 0.6 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.chatTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
            self.chatTableView.scrollToRow(at: index, at: UITableViewScrollPosition.bottom, animated: true)
        })

    }
}

extension IZChatBaseViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //*****************************************************************
    // MARK: - UIImagePickerControllerDelegate
    //*****************************************************************
    
    func actionAddPhotoFromGallery(_ completed:@escaping (_ image: UIImage) -> ()) {
        if self.imagePicker.isButtonActive {
            DispatchQueue.main.async {
                IZLoaderManager.sharedInstance.hideView()
            }
            return
        }
        self.imagePicker.isButtonActive = true
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.completion = completed
            
            self.present(imagePicker, animated: true, completion: {
            })
        }
    }
    
    func actionMakePhoto(_ completed:@escaping (_ image: UIImage) -> ()) {
        if self.imagePicker.isButtonActive {
            DispatchQueue.main.async {
                IZLoaderManager.sharedInstance.hideView()
            }
            return
        }
        self.imagePicker.isButtonActive = true
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.completion = completed
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imagePicker.isButtonActive = false
        print(info.debugDescription)
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            if let action = completion {
                action(image)
            }
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let action = completion {
                action(image)
            }
        } else {
            
        }
        
        dismiss(animated: true, completion: { (_) in
            self.imagePicker.isButtonActive = false
            self.isPhotoControllerEnabled = true
            if self.completion != nil {
            }            
        })
    }
}





