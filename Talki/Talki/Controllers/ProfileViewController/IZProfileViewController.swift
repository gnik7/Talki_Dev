//
//  IZProfileViewController.swift
//  Talki
//
//  Created by Nikita Gil on 01.07.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import MobileCoreServices
import TextFieldEffects
import Kingfisher
import AssetsLibrary
import CoreLocation
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


class IZProfileViewController : IZBaseHomeViewController {
 
    //IBOutlet
    @IBOutlet weak var profileImagesCollectionView  : UICollectionView!
    @IBOutlet weak var imagesView                   : UIView!
    @IBOutlet weak var buttonCameraView             : UIView!
    @IBOutlet weak var profileImageView             : UIImageView!
    @IBOutlet weak var nameTextField                : HoshiTextField!
    @IBOutlet weak var ageTextField                 : HoshiTextField!
    @IBOutlet weak var genderTextField              : HoshiTextField!
    @IBOutlet weak var profileActivityIndicator     : UIActivityIndicatorView!
    
    //var
    var userModel : IZUserModel?
    var firstTime  = true
    var bottomButtonTaped = false
    var isCollectionUpdate = false
    var isAvatarSet = false
    fileprivate var fotoButton = false
    var profileImagesArray      : [String]?
    var profileImagesKeyArray   : [String]?
    lazy var imagePicker :IZCameraController = self.initCameraController()
    var saveData = (name: "", gender: "", age: "")
    
    //let
    let titleNavigationPanel = "Profile"
    let rightButtonTitleTopPanel = "Save"
    let profileImageNameDefault = "profile_placeholder"
    let numberColumsInCollectionView = 2
    let numberCellsInCollectionView = 4
    let rangeNameMin = 2
    let rangeNameMax = 20
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.delegate = self
        self.ageTextField.delegate = self
        self.genderTextField.delegate = self
        
        //topPanel add settings
        self.topFunctionalView?.delegate = self
        self.topFunctionalView?.updateUI(titleNavigationPanel , titleRightButton: BackgroundRightButton.textBackgroundRightButton , rightTitleText : rightButtonTitleTopPanel, titleLeftButton: nil)
        
        //bottom panel
        self.bottomNavigationView?.updateUI(TypeBottomNavigationPanel.ProfileTypeBottomNavigationPanel)
        self.bottomNavigationView?.delegate = self
        
        //init collectionView
        self.setupCollectionView()
        
        if firstTime {
            // API Call
            self.profileDataUpdate()
        } else {
            self.setupProfileData()
            self.setupCollectionImages()
        }
        
        //keyboard apearence
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(super.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.roundViewImages()
        self.profileActivityIndicator.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //round image and view
        self.roundViewImages()
        //self.view.setNeedsDisplay()
    }
    
    fileprivate func initCameraController() -> IZCameraController {
        let imagePicker = IZCameraController()
        return imagePicker
    }
    
    fileprivate func setupCollectionView() {
        
        self.profileImagesArray = [String]()
        self.profileImagesKeyArray = [String]()
        
        self.profileImagesCollectionView.delegate = self
        self.profileImagesCollectionView.dataSource = self
        
        let (className ,nibCell) = NSObject.classNibFromString(IZProfileImagesCollectionCell.self)
        guard let nameCell = className as String?, let nibCollectionCell = nibCell as UINib? else {
            return
        }
        self.profileImagesCollectionView.register(nibCollectionCell, forCellWithReuseIdentifier: nameCell)
    }
    
    fileprivate func roundViewImages() {
        self.profileImageView.contentMode = UIViewContentMode.scaleAspectFill
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2
        self.profileImageView.clipsToBounds = true
        
        self.buttonCameraView.layer.cornerRadius = self.buttonCameraView.frame.width / 2
        self.buttonCameraView.clipsToBounds = true
    }
    
    fileprivate func setupProfileData() {
        
        if !firstTime {
            //self.userModel = IZCurrentUserData.takeUserLocal()
            self.userModel = IZUserModelSingletone.sharedInstance.user
        }
        
        IZLoaderManager.sharedInstance.showView()
        if let name = userModel?.name as String?, !name.isEmpty {
            self.nameTextField.text = name
        } else {
            self.nameTextField.text = ""
            DispatchQueue.main.async(execute: { () -> Void in
                IZLoaderManager.sharedInstance.hideView()
            })
        }
        
        if let age = userModel?.age as Int?, userModel?.age > 0  {
            self.ageTextField.text = String(age)
        } else {
            self.ageTextField.text = ""
        }
        
        if let gender = userModel?.gender as String? {
            if gender == "notset" {
                self.genderTextField.text = ""
            } else {
                self.genderTextField.text = gender.capitalized
            }            
        } else {
            self.genderTextField.text = ""
        }
        
        if let avatar = userModel?.urlAvatar?.full as String?  {
            if !avatar.isEmpty {
                IZLoaderManager.sharedInstance.showView()
                self.profileImageView.alpha = 0.0
                self.isAvatarSet = true
                let mCa = ImageCache(name: "my_cache")
                DispatchQueue.main.async(execute: { () -> Void in
                    self.profileActivityIndicator.isHidden = false
                    self.profileActivityIndicator.startAnimating()
                })
                self.profileImageView.kf.setImage(with: URL(string: avatar)!, placeholder: nil, options: [.targetCache(mCa)], progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) in
                    self.profileImageView.image = image
                    UIView.animate(withDuration: 0.9, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        self.profileImageView.alpha = 1.0
                    }, completion: nil)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.profileActivityIndicator.stopAnimating()
                        self.profileActivityIndicator.isHidden = true
                    })
                    
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let time = DispatchTime.init(uptimeNanoseconds: UInt64(delay))
                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                        IZLoaderManager.sharedInstance.hideView()
                    })
                })
            }
        } else {
            self.isAvatarSet = false
            IZLoaderManager.sharedInstance.hideView()
        }
        //UIImage(named:  "profile_placeholder")!
        //self.firstTime = false
    }
    
    func setupCollectionImages() {
        self.checkGotImageArray()
        if let imagesStringArray = userModel?.images as [IZUserImagesModel]? {
            
            self.profileImagesKeyArray?.removeAll()
            self.profileImagesArray?.removeAll()
            
            for item in imagesStringArray {
                self.profileImagesKeyArray?.append(item.key!)
                self.profileImagesArray?.append(item.preview!)
            }
            self.profileImagesCollectionView.reloadData()
            //self.view.setNeedsDisplay()
        }
        
        if self.isCollectionUpdate {
            self.isCollectionUpdate = false
            //return
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func addProfileImageButtonPressed(_ sender: UIButton) {
        if !fotoButton {
            fotoButton = true
        } else {
            return
        }
        self.imagePicker.typeButton = TypeButton.profileTypeButton
        self.takePhoto()
    }
    
    fileprivate func takePhoto() {
  
        let alert = IZAlertCustomTakeImage.loadFromXib()
        alert?.showView({ (typeAction) in
            if typeAction == ActionType.takePhotoActionType {
                self.actionMakePhoto()
            } else if typeAction == ActionType.galleryPhotoActionType {
                self.actionAddPhotoFromGallery()
            } else if typeAction == ActionType.cancelActionType {
                self.fotoButton = false
            }
        })
    }
}

extension IZProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //*****************************************************************
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    //*****************************************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.profileImagesArray!.count > 0 && self.profileImagesArray!.count < numberCellsInCollectionView {
            return self.profileImagesArray!.count + 1
        } else if self.profileImagesArray!.count == numberCellsInCollectionView {
            return numberCellsInCollectionView
        }
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : IZProfileImagesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSObject.classFromString(IZProfileImagesCollectionCell.self)!, for: indexPath) as! IZProfileImagesCollectionCell
       
        if self.profileImagesArray!.count > 0 && self.profileImagesArray!.count <= numberCellsInCollectionView {
            if indexPath.row < self.profileImagesArray!.count || indexPath.row == numberCellsInCollectionView  {
                cell.configurateUI(self.profileImagesArray![indexPath.row], currentIndex: indexPath.row)
                cell.delegate = self
            }
            if  indexPath.row == self.profileImagesArray!.count && indexPath.row != numberCellsInCollectionView {
                cell.configurateUI(nil, currentIndex: nil)
            }
        } else {
            cell.configurateUI(nil, currentIndex: nil)
        }
        
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = imagesView.frame.size.height / CGFloat(numberColumsInCollectionView)
//        return IZProfileImagesCollectionCell.sizeCollectionCell(numberColumns: numberColumsInCollectionView, heightCell: height)
        let width = UIScreen.main.bounds.size.width / 2.0
        return CGSize(width: width * 0.92, height: height * 0.92)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 2.5, bottom: 5.0, right: 2.5)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !fotoButton {
            fotoButton = true
        } else {
            return
        }
        
        if (self.profileImagesArray!.count <= numberCellsInCollectionView &&
            indexPath.row == self.profileImagesArray!.count)  {
            self.imagePicker.typeButton = TypeButton.additionalTypeButton
            self.imagePicker.pathImage = indexPath
            self.takePhoto()
        }        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.didHighlight()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.didUnhighlight()
    }
}

extension IZProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //*****************************************************************
    // MARK: - UIImagePickerControllerDelegate
    //*****************************************************************
    
    func actionAddPhotoFromGallery() {
        IZLoaderManager.sharedInstance.showView()
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func actionMakePhoto() {
        IZLoaderManager.sharedInstance.showView()
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            if self.imagePicker.typeButton == TypeButton.profileTypeButton {
                self.profileImageView.contentMode = .scaleAspectFit
                self.profileImageView.image = pickedImage
                self.profileImageView.alpha = 0.0
                self.uploadFotoProfile(pickedImage)
            } else if self.imagePicker.typeButton == TypeButton.additionalTypeButton {
                if self.profileImagesArray?.count < numberCellsInCollectionView {
                    self.uploadImagesFromCollection(pickedImage)
                }
            }
        }
        
        dismiss(animated: true, completion: { (_) in
            
            if self.imagePicker.typeButton == TypeButton.profileTypeButton {
                UIView.animate(withDuration: 0.5, animations: { 
                    self.profileImageView.alpha = 1.0
                })
            } else if self.imagePicker.typeButton == TypeButton.additionalTypeButton {
                self.profileImagesCollectionView.reloadData()
            }
            self.fotoButton = false
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: { (_) in
            self.fotoButton = false
        })
    }
}

extension IZProfileViewController: UITextFieldDelegate {
    
    //*****************************************************************
    // MARK: - UITextFieldDelegate
    //*****************************************************************
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 0  : self.ageTextField.becomeFirstResponder()
        case 1  : self.genderTextField.becomeFirstResponder()
        case 2  : self.gestureTap()
        default : self.gestureTap()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(self.genderTextField) {
            
            IZAlert.showAlertChooseGender(self, title: AlertTitle.TitleCommon.rawValue, message: AlertText.ChooseGender.rawValue, doneGender: { (gender) in
                
                self.genderTextField.text = gender.capitalized
                self.gestureTap()
                }, cancel:{
                    self.gestureTap()
            })
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.characters.count > 0 {
            if string.containsEmoji() {
                return false
            }
            if !string.isValidNameOnly() && textField.isEqual(self.nameTextField) {
                self.view.endEditing(true)
                self.loadAlert(AlertText.ProfileNameWrongSet.rawValue, text2: "")
                return false
            }
        }
        return true
    }
}

extension IZProfileViewController: TopFunctionalPanelDelegate {
    
    //*****************************************************************
    // MARK: - TopFunctionalPanelDelegate
    //*****************************************************************
    
    func rightButtonWasPressed() {
 
        self.view.endEditing(true)
        self.ageTextField.resignFirstResponder()
        self.nameTextField.resignFirstResponder()
        
        let check = self.checkFields()
        
        if !check {
            return
        }
        
        let checkName = self.checkNameField()
        if !checkName {
            return
        }
        
        let checkAge = self.checkAgeField()
        if !checkAge {
            return
        }
        
        guard let name = self.nameTextField.text ,
            let age = self.ageTextField.text ,
            let gender = self.genderTextField.text else {
                return
        }

        if !self.isAvatarSet {
            self.loadAlert(AlertText.ProfileImageNotSet.rawValue, text2: "")
            return
        }
        
        guard let _ = Int(age) as Int? else {
            return
        }
        
        self.userModel?.name = name
        self.userModel?.gender = gender
        self.userModel?.age = Int(age)
        self.userModel?.birth_date = age
        IZUserModelSingletone.sharedInstance.user = self.userModel
        
        let isEnable: Bool = IZUserDefaults.isFirstProfileUserDefault()
        if !isEnable  {            
            self.loadAlertOk(AlertText.FirstTimeProfileSave.rawValue, text2: "")
            self.alertView?.delegate = self
            self.saveData = (name:name, gender: gender, age: age)
        } else {
            self.saveProfileData(name, gender: gender, age: age)
            IZUserModelSingletone.sharedInstance.user = self.userModel
        }
    }
    
    func leftButtonWasPressed() {}
}

extension IZProfileViewController: IZProfileImagesCollectionCellDelegate {
    
    //*****************************************************************
    // MARK: - IZProfileImagesCollectionCellDelegate
    //*****************************************************************
    
    func trashtButtonWasPressed(_ index :Int) {
        let key : String = (self.profileImagesKeyArray?[index])!
        self.deleteImagesFromCollection(key)
    }
}

extension IZProfileViewController: IZAlertCustomDelegate {
    
    //*****************************************************************
    // MARK: - IZAlertCustomDelegate
    //*****************************************************************
    
    func okButtonWasPressed() {
        
        let check = self.checkFields()
        if !check {
            return
        }
        self.saveProfile(self.saveData.name, gender: self.saveData.gender, age: self.saveData.age)
    }
}

extension IZProfileViewController {
    
    //*****************************************************************
    // MARK: - Check Profile Data
    //*****************************************************************
    
    fileprivate func checkFields() -> Bool {
    
        if self.checkForEmptyTextField(self.nameTextField) &&
            self.checkForEmptyTextField(self.ageTextField) &&
            self.checkForEmptyTextField(self.genderTextField) {            
            return true
        } else {
            self.loadAlert(AlertText.FillTextFieldProfile.rawValue, text2: "")
            return false
        }
    }
    
    fileprivate func checkAgeField() -> Bool {
        if let age = Int(self.ageTextField.text!) as Int? {
            if age > 15 && age < 100 {
                return true
            } else {
                false
            }
        }
        return false
    }
    
    fileprivate func checkNameField() -> Bool {
        if nameTextField.text?.characters.count < rangeNameMin || nameTextField.text?.characters.count > rangeNameMax {
            let nameAlert = IZAlertCustomWithOneButton.loadFromXib()
            nameAlert?.showView(AlertText.ProfileNameWrongCount.rawValue)
            return false
        } else {
            return true
        }
    }
    
   func checkGotImageArray() {
        if let imagesStringArray = self.userModel?.images as [IZUserImagesModel]? {
            if imagesStringArray.count > self.numberCellsInCollectionView {
                while(true) {
                    if self.userModel?.images?.count > self.numberCellsInCollectionView {
                        self.userModel?.images?.removeLast()
                    } else {
                        break
                    }
                }
            }
        }
    }
    
    func saveProfile(_ name: String, gender: String, age: String) {
        self.saveProfileData(name, gender: gender, age: age)
        
        if !IZUserDefaults.isFirstProfileUserDefault() {
            (UIApplication.shared.delegate as? AppDelegate)?.setupLocationManager()
            if let location = (UIApplication.shared.delegate as? AppDelegate)?.locationManager {
                if CLLocationManager.locationServicesEnabled() {
                    location.startUpdatingLocation()
                }
            }
        }
    }
    
    //*****************************************************************
    // MARK: - Api Calls
    //*****************************************************************
    
    fileprivate func profileDataUpdate() {
        
        if !IZReachability.isConnectedToNetwork() {
            IZLoaderManager.sharedInstance.hideView()
            self.loadAlert(AlertText.TitleNoInternet.rawValue, text2: "")
            return
        }
        
        IZRestAPIProfileOperations.profileGetOperation { (responceObject, restStatus) in
            guard let status = restStatus as RestStatus? else {
                return
            }
            
            if status == RestStatus.success {
                guard let user = responceObject as IZUserModel? else {
                    return
                }
              
                self.userModel = user
//                let tmpUser = IZUserModel(name :user.name!, gender:user.gender!, birth_date :String(user.age!) , avatar: (user.urlAvatar?.full)!)
//                IZCurrentUserData.updateUserLocal(tmpUser)
                self.setupProfileData()
                self.setupCollectionImages()
            } else {
                DispatchQueue.main.async(execute: { () -> Void in
                    IZLoaderManager.sharedInstance.hideView()
                })
            }
        }
    }
    
    fileprivate func saveProfileData(_ name : String, gender : String, age : String) {
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.TitleNoInternet.rawValue, text2: "")
            return
        }
        
        IZRestAPIProfileOperations.saveProfileOperation(name, gender: gender, age: age,
            responce: { (restStatus) in
            
                guard let status = restStatus as RestStatus? else {
                    return
                }
                
                if status == RestStatus.success {
                    if !IZUserDefaults.isFirstProfileUserDefault() {
                        IZUserDefaults.updateFirstProfileUserDefault()
                        self.userModel?.age = Int(age)
                        self.userModel?.gender = gender
                        self.userModel?.name = name
                    }
                    if !self.bottomButtonTaped {
                        let placeHolder = IZPlaceHolderChecked.loadFromXib()
                        placeHolder?.showView()
                        let placeHolderDelay = (placeHolder?.totalTime)!
                        let delay = placeHolderDelay * Double(NSEC_PER_SEC)
                        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time, execute: {
                            IZRouter.setupFirstTimeHomeRootViewController()
                        })
                    }
                    
                    
//                    let tmpUser = IZUserModel(name:name, gender:gender, birth_date :age , avatar: (self.userModel?.urlAvatar?.full)!)
//                    IZCurrentUserData.updateUserLocal(tmpUser)
                    
//                    if !IZUserDefaults.isFirstProfileUserDefault() {
//                        IZUserDefaults.updateFirstProfileUserDefault()
//                    } else {
//                        //self.router.popToRootViewController()
//                    }
                }
        })
    }
    
    fileprivate func uploadFotoProfile(_ image : UIImage) {
        
        // file must be less 10 MB
        if !IZHelper.checkFileSizeImage(image) {
            self.loadAlert(AlertText.Bigger10MB.rawValue, text2: "")
            return
        }
        
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIProfileOperations.uploadProfileImageOperation(image, responce:  { (url, restStatus) in
            if url != nil {
                IZCurrentUserData.updateAvatarUser(url!)
                self.isAvatarSet = true
                self.userModel?.urlAvatar?.full = url
            }
        })
    }
    
    fileprivate func uploadImagesFromCollection(_ image : UIImage) {
        
        // file must be less 10 MB
        if !IZHelper.checkFileSizeImage(image) {
            self.loadAlert(AlertText.Bigger10MB.rawValue, text2: "")
            return
        }
        
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        IZRestAPIProfileOperations.uploadImagesOperation(image, responce: { (responceObject, restStatus) in
            
            guard let status = restStatus as RestStatus? else {
                return
            }
            if status == RestStatus.success {
                guard let user = responceObject as IZUserModel? else {
                    return
                }
                self.userModel = user
                self.isCollectionUpdate = true
                self.setupCollectionImages()
            }
        })
    }
    
    fileprivate func deleteImagesFromCollection(_ key : String) {
       
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        let keyArray : [String] = [key]
        
        IZRestAPIProfileOperations.deleteImagesOperation(keyArray, responce: { (responceObject, restStatus) in
            
            guard let status = restStatus as RestStatus? else {
                return
            }
            if status == RestStatus.success {
                guard let user = responceObject as IZUserModel? else {
                    return
                }
                self.userModel = user
                self.isCollectionUpdate = true
                self.setupCollectionImages()
            }
        })
    }  
}

extension IZProfileViewController  {
    
    //*****************************************************************
    // MARK: - IZBottomNavigationPanelDelegate
    //*****************************************************************
    
    override func homeButtonWasPressed() {
        let check = self.checkFields()
        if !check || !self.isAvatarSet{
            return
        }
    
        bottomButtonTaped = true
        self.rightButtonWasPressed()
        super.homeButtonWasPressed()
    }
    
    override func profileButtonWasPressed() {
        let check = self.checkFields()
        if !check || !self.isAvatarSet {
            return
        }
        
        bottomButtonTaped = true
        self.rightButtonWasPressed()
        let visibleVC = self.router.visibleViewController()
        if visibleVC.isKind(of: IZProfileViewController.self) {
            return
        }
        super.profileButtonWasPressed()
    }
    
    override func matchHistoryButtonWasPressed() {
        let check = self.checkFields()
        if !check || !self.isAvatarSet {
            return
        }
        
        bottomButtonTaped = true
        self.rightButtonWasPressed()
        super.matchHistoryButtonWasPressed()
    }
    
    override func chatButtonWasPressed() {
        let check = self.checkFields()
        if !check || !self.isAvatarSet {
            return
        }
        
        bottomButtonTaped = true
        self.rightButtonWasPressed()
        super.chatButtonWasPressed()
    }
    
    override func settingButtonWasPressed() {
        let check = self.checkFields()
        if !check || !self.isAvatarSet {
            return
        }
        bottomButtonTaped = true
        self.rightButtonWasPressed()
        super.settingButtonWasPressed()
    }
}
