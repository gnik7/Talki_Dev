//
//  IZHomeViewController.swift
//  Talki
//
//  Created by Nikita Gil on 30.06.16.
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


class IZHomeViewController : IZBaseHomeViewController {
    
    //IBOutlet
    @IBOutlet weak var interestTableView: UITableView!
    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //var
    var interestArray           : [IZInterestModel]?
    var selectedInterestArray   : [String]?
    var refreshControl          : UIRefreshControl?
    
    var offsetPagination = 0
    var isStartedUpdateList = false
    var isTableMovedUp = false
    var isSearching = false
    var tableViewHeight : CGFloat = 0
    var firstTimeInterestHelper: IZInterestHelper?
    var newAddInterest : String = ""
    var isDoneButtonPressed = false
    var isStateChanged = false
    
    //let
    let titleNavigationPanel = "Interests"
    let limitPagination = 15
    let heightCell : CGFloat = 40.0
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup tableView
        self.setupTable()
        
        // set refresh control
        self.createRefreshControl()
        
        self.searchBar.delegate = self
        
        //topPanel add settings
        self.topFunctionalView?.delegate = self
        self.topFunctionalView?.updateUI(titleNavigationPanel , titleRightButton: BackgroundRightButton.imageBackgroundRightButton, rightTitleText : nil  , titleLeftButton: nil)       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //bottom panel
        self.bottomNavigationView?.updateUI(TypeBottomNavigationPanel.HomeTypeBottomNavigationPanel)
      
        //set data to array
        self.offsetPagination = 0
        self.interestArray = [IZInterestModel]()
        self.selectedInterestArray = [String]()
        self.interestTableView.reloadData()
        self.interestList(nil)
        self.isTableMovedUp = false
        
        self.updateSearchBar()
        self.updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableViewHeight = self.interestTableView.frame.size.height
        
        if !IZUserDefaults.isInterestHelperUserDefault() {
           self.firstTimeHelperCreate()
        }
        //set ui turning
        self.updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.doneButtonAnimation()
    }
    
    /**
     Setup Table
     */
    
    fileprivate func setupTable() {
        //setup array
        self.interestArray = [IZInterestModel]()
        
        //asign table to delegate
        self.interestTableView.delegate = self
        self.interestTableView.dataSource = self
        
        //registrate cell in table
        let (className ,nibCell) = NSObject.classNibFromString(IZInterestTableViewCell.self)
        guard let nameCell = className as String?, let nibTableCell = nibCell as UINib? else {
            return
        }
        self.interestTableView.register(nibTableCell, forCellReuseIdentifier: nameCell)
    }
    
    /**
     Create refresh control
     */
    
    func createRefreshControl() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(updateInterestList), for: UIControlEvents.valueChanged)
        self.interestTableView?.addSubview(self.refreshControl!)
    }
    
    fileprivate func updateUI() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.doneButton.layer.cornerRadius = self.doneButton.frame.height / 2
            self.doneButton.clipsToBounds = true
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func updateSearchBar() {
        
        self.searchBar.layer.borderColor = UIColor(colorLiteralRed: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0).cgColor
        self.searchBar.layer.borderWidth = 1.0
    }
    
    func updateInterestList() {
        if !self.isStartedUpdateList {
            self.isStartedUpdateList = true
            self.interestList(nil)
        }
    }
    
    fileprivate func firstTimeHelperCreate() {
        self.firstTimeInterestHelper = IZInterestHelper.loadFromXib()
        self.firstTimeInterestHelper?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.firstTimeInterestHelper?.showView()
    }
    
    internal func doneAlert(_ completion:@escaping (() -> ())) {
        let alert = IZAlertCustomWithOneButton.loadFromXib()
        alert?.showViewWithCompletion(AlertText.SetDone.rawValue, action: {
            completion()
        })
    }
    
    //*****************************************************************
    // MARK: - Action
    //*****************************************************************
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        isDoneButtonPressed = true
        
        self.saveSelectedInterestsApiCall({
            self.doneAlert({})
        })
    }
}

extension IZHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    //*****************************************************************
    // MARK: - UITableViewDataSource
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.interestArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSObject.classFromString(IZInterestTableViewCell.self)! , for: indexPath) as! IZInterestTableViewCell
        
        if self.interestArray?.count > 0 {
            cell.setupData(self.interestArray![indexPath.row])
        }
        return cell
    }
    
    //*****************************************************************
    // MARK: - UITableViewDelegate
    //*****************************************************************
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        isStateChanged = true
        
        if let interest = self.interestArray?[indexPath.row],
            let state = interest.state,
            let idInterest = interest.id {
            
            if state == true {
                self.delInterestInSearch(idInterest)
            } else {
                self.selectedInterestArray?.append(idInterest)
            }
            
            interest.state = !state
            self.saveSelectedInterestsApiCall({})
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.row == (self.interestArray?.count)! - 1) && !self.isSearching {
            self.interestList(nil)
        }
    }
}

extension IZHomeViewController: TopFunctionalPanelDelegate {
    
    //*****************************************************************
    // MARK: - TopFunctionalPanelDelegate
    //*****************************************************************
    
    func rightButtonWasPressed() {
        self.router.showAddInterestViewController()
    }
    
    func leftButtonWasPressed() {}
}

extension IZHomeViewController: UISearchBarDelegate {
    
    //*****************************************************************
    // MARK: - UISearchBarDelegate
    //*****************************************************************
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = true
        self.isSearching = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        self.searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
        self.isSearching = false
        self.interestArray?.removeAll()
        self.offsetPagination = 0
        self.interestList(nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.characters.count == 0 {
            self.interestArray?.removeAll()
            self.offsetPagination = 0
            self.interestList(nil)
        } else {
            self.interestArray?.removeAll()
            self.offsetPagination = 0
            self.interestList(searchBar.text?.lowercased())
        }
    }
}

extension IZHomeViewController {
    
    //*****************************************************************
    // MARK: - Interests Arrays
    //*****************************************************************
    
    fileprivate func selectedInterests() -> [String] {
        var selectedArray = [String]()
        
        for item in self.interestArray! {
            if (item.state == true) {
                selectedArray.append(item.id!)
            }
        }
        return selectedArray
    }
    
    fileprivate func delInterestInSearch(_ interest: String) {
        var num = 0
        for (index, item) in self.selectedInterestArray!.enumerated() {
            if (item == interest) {
                num = index
                break
            }
        }
        self.selectedInterestArray?.remove(at: num)
    }
    
    fileprivate func allInterestsAfterDelete() -> [String] {
        var allArray = [String]()
        
        for item in self.interestArray! {
            allArray.append(item.id!)
        }
        return allArray
    }
    
    //*****************************************************************
    // MARK: - Api Call
    //*****************************************************************
    
    fileprivate func interestList(_ keyWord: String?) {
        
        if !IZReachability.isConnectedToNetwork() {
            //self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            self.isStartedUpdateList = false
            self.refreshControl!.endRefreshing()
            return
        }
        
        IZRestAPIInterestsOperations.interestsListCall(keyWord,offset: self.offsetPagination, limit: self.limitPagination,
            completed: { (responceObject, statusResponse) in
            
                self.isStartedUpdateList = false
                self.refreshControl!.endRefreshing()
                guard let status = statusResponse as RestStatus? else {
                    return
                }
                if status == RestStatus.success {
                    if let respObjectsArray = responceObject as IZInterestsItemsModel? {
                        if respObjectsArray.items?.count > 0 {
                            self.interestArray = self.interestArray! + respObjectsArray.items!
                            self.offsetPagination += (respObjectsArray.items?.count)! + 1 
                            self.interestTableView.reloadData()
                            if keyWord == nil {
                                self.selectedInterestArray = self.selectedInterests()
                            }
                        } else {
                            if keyWord != nil {
                                self.loadAlert(AlertText.SearchInterestNothing.rawValue, text2: "")
                            }
                        }
                    }
                }
        })
    }
    
    fileprivate func saveSelectedInterestsApiCall(_ completion: @escaping (()->())) {
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        IZRestAPIInterestsOperations.saveSelectedInterestCall(self.selectedInterestArray!,
            completed: { (statusResponse) in
            
                if statusResponse == RestStatus.success {
                    if self.searchBar.text?.characters.count > 0 {
                        self.searchBar.showsCancelButton = false
                        self.searchBar.resignFirstResponder()
                        self.searchBar.text = ""
                        self.isSearching = false
                        self.interestArray?.removeAll()
                        self.offsetPagination = 0
                        self.interestList(nil)
                    } else {
                        let sortedArray = IZHelper.sortCheckerArrayInterests(self.interestArray!)
                        self.interestArray?.removeAll()
                        self.interestArray = sortedArray
                        self.interestTableView.reloadData()
                    }
                    self.isDoneButtonPressed = false
                    completion()
                }
        })
    }
    
    fileprivate func deleteInterestApiCall(_ completed:()->()) {
        if !IZReachability.isConnectedToNetwork() {
            self.loadAlert(AlertText.NoInternetMessage.rawValue, text2: "")
            return
        }
        
        //TODO: need aprove
//        let allInterests = self.allInterestsAfterDelete()
//        
//        IZRestAPIInterestsOperations.saveSelectedInterestCall(allInterests, completed: { (statusResponse) in
//            if statusResponse == RestStatus.Success {
//                completed()
//            }
//        })
    }
    
}

extension IZHomeViewController  {
    
    //*****************************************************************
    // MARK: - IZBottomNavigationPanelDelegate
    //*****************************************************************
    
    override func homeButtonWasPressed() {
      
        if !isDoneButtonPressed && isStateChanged && !IZUserDefaults.isCheckmarkedInterest(){
            self.doneAlert({
                super.homeButtonWasPressed()
                IZUserDefaults.updateCheckmarkedInterest()
            })
        } else {
            super.homeButtonWasPressed()
        }
    }
    
    override func profileButtonWasPressed() {
        
        if !isDoneButtonPressed && isStateChanged && !IZUserDefaults.isCheckmarkedInterest() {
            self.doneAlert({
                IZUserDefaults.updateCheckmarkedInterest()
                super.profileButtonWasPressed()
            })
        } else {
            super.profileButtonWasPressed()
        }
    }
    
    override func matchHistoryButtonWasPressed() {
        if !isDoneButtonPressed && isStateChanged && !IZUserDefaults.isCheckmarkedInterest(){
            self.doneAlert({
                IZUserDefaults.updateCheckmarkedInterest()
                super.matchHistoryButtonWasPressed()
            })
        } else {
            super.matchHistoryButtonWasPressed()
        }
    }
    
    override func chatButtonWasPressed() {
        if !isDoneButtonPressed && isStateChanged && !IZUserDefaults.isCheckmarkedInterest() {
            self.doneAlert({
                IZUserDefaults.updateCheckmarkedInterest()
                super.chatButtonWasPressed()
            })
        } else {
            super.chatButtonWasPressed()
        }
    }
    
    override func settingButtonWasPressed() {
        if !isDoneButtonPressed && isStateChanged && !IZUserDefaults.isCheckmarkedInterest() {
            self.doneAlert({
                IZUserDefaults.updateCheckmarkedInterest()
                super.settingButtonWasPressed()
            })
        } else {
            super.settingButtonWasPressed()
        }
    }
}




