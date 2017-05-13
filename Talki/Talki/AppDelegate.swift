//
//  AppDelegate.swift
//  Talki
//
//  Created by Eugene on 29.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import CoreLocation
import Kingfisher
import Fabric
import Crashlytics
import UserNotifications
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


let missedMathPushNotification = "MissedMathPushNotification"
let missedMessagePushNotification = "MissedMessagePushNotification"
let missedMessageChatPushNotification = "MissedMessageChatPushNotification"
let updateSavedChatView = "UpdateSavedChatView"
let updateSavedMatchesView = "UpdateSavedMatchesView"
let openSocket = "OpenSocket"
let closeSocket = "CloseSocket"

enum IZPushType {
    case izPushOneMatchType
    case izPushNoMatchType
    case izPushMatchesType
    case izPushNessageType
    case izPushAcceptedMatchType
    case izPushNoType
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager! = nil
    fileprivate var interest = ""
    var timer : Timer?
    var timeForRepeatLocation   : TimeInterval = 120 // 9 min  540   120
    var latitudeCoordinate : Double?
    var longtitudeCoordinate : Double?
    var isNeedUpdatePush = false
    let minimumDistanceLocation = 5.0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
        
        if  #available(iOS 10, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                    print("Not granded")
                    self.registerForPushNotifications(application)
                }
            })
 
        } else {
            self.registerForPushNotifications(application)
        }
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            print(notification)
        }
        //UIApplication.sharedApplication().applicationIconBadgeNumber -= 1
        //self.initKingFisherManager()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Freezing screen at start 
        Thread.sleep(forTimeInterval: 2)
        self.launchSetupViewController()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        if self.timer != nil {
           self.timer?.invalidate()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //self.isNeedUpdatePush = true
        self.timer = Timer.scheduledTimer(timeInterval: timeForRepeatLocation, target: self, selector: #selector(AppDelegate.updateLocationFromInterval(_:)), userInfo: nil, repeats: true)
        self.setupProfileData({})
        IZRestAPIInterestsOperations.updateNewMissedPushesOperation { (responceObject) in }

        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: closeSocket), object: nil))
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //open
        if IZUserDefaults.getTokenToUserDefault() != nil {
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: openSocket), object: nil))
        }
 
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: updateSavedChatView), object: nil))
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: updateSavedMatchesView), object: nil))
        
        if self.timer != nil {
            self.timer?.invalidate()
        }
        
        if isNeedUpdatePush {
            if  #available(iOS 10, *) {
                UNUserNotificationCenter.current().delegate = self
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                    if (granted)
                    {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                })
            } else {
                self.registerForPushNotifications(application)
            }
            self.isNeedUpdatePush = false
        }
        
        IZRestAPIInterestsOperations.updateNewMissedPushesOperation { (responceObject) in        
        }
        
        self.setupProfileData({})
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return true
    }
    
    //*****************************************************************
    // MARK: - Setup
    //*****************************************************************
    
    fileprivate func launchSetupViewController() {
    
        let user = IZUserDefaults.getTokenToUserDefault()
        let router = IZRouter(navigationController: self.window?.rootViewController as! UINavigationController)
        let deviceToken = IZUserDefaults.getDevicePushTokenUserDefault()
        
        if user != nil &&  deviceToken != nil {
            if IZUserDefaults.isFirstProfileUserDefault() {
                self.setupLocationManager()
                self.locationManager.startUpdatingLocation()
                self.setupProfileData({
                    guard let name = IZUserModelSingletone.sharedInstance.user?.name,
                        let gender = IZUserModelSingletone.sharedInstance.user?.gender else  {
                        router.showProfileViewController(nil)
                        return
                    }
                    
                    if !name.isEmpty && !gender.isEmpty {
                        router.setupHomeRootViewController()
                        IZRestAPIInterestsOperations.updateNewMissedPushesOperation { _ in}
                    } else {
                        router.showProfileViewController(nil)
                    }
                })
            } else {
                if IZUserDefaults.getFBTokenToUserDefault() != nil {
                    self.updateFacebookUserOnStart()
                } else {
                    router.setupLoginRootViewController()
                }
            }
        } else {
            router.setupLoginRootViewController()
        }        
    }
    
    fileprivate func initKingFisherManager() {
        // Clear memory cache right away.
        KingfisherManager.shared.cache.clearMemoryCache()
        
        // Clear disk cache. This is an async operation.
        KingfisherManager.shared.cache.clearDiskCache()
        
        // Clean expired or size exceeded disk cache. This is an async operation.
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
    
    //*****************************************************************
    // MARK: - Push
    //*****************************************************************

    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var tokenString = ""
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }

        print("Device Token:", tokenString)
     
        let deviceToken = IZUserDefaults.getDevicePushTokenUserDefault()
        if deviceToken == nil {
            IZUserDefaults.recordDevicePushTokenInUserDefault(tokenString)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        var state : Bool = true
        
        let (typePush , message, matchId) = IZHelper.convertPushInfo(userInfo)
  
        if application.applicationState == UIApplicationState.active {
            print("Push in Active State")
            state = true
        } else {
            print("Push in Background State")
            state = false
        }
        
        self.typePush(typePush, message: message, matchId: matchId, state: state)
    }
    
    fileprivate func typePush(_ typePush : IZPushType, message : String, matchId : String?, state : Bool) {
        switch typePush {
        case IZPushType.izPushOneMatchType: self.oneMatchInArea(state, messageFrom: message, matchId: matchId!)
        case IZPushType.izPushNoMatchType: self.noMatchPush(state, text: message)
        case IZPushType.izPushMatchesType: self.missedMatchesPush(state, text: message)
        case IZPushType.izPushNessageType: self.missedMessagePush(state, text: message, recipientId: matchId!)
        case IZPushType.izPushAcceptedMatchType: self.acceptedMatch(state, messageFrom: message, matchId: matchId!)
        case IZPushType.izPushNoType: break
        }
    }
    
    fileprivate func oneMatchInArea(_ state : Bool, messageFrom : String, matchId : String) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        IZUserDefaults.recordMissedMatch()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: missedMathPushNotification), object: nil))
        // state - true - active mode
        if state {

            self.userFromPush(matchId, copmlited: { (interests) in
                
                let text = messageFrom + " also likes " + interests
                let alertView = AlertPushViewController.loadFromXib()
                
                alertView?.showNewMatch(text, action: {
                     IZRouter.lanchMatchView(matchId, type: IZPushType.izPushOneMatchType)
                })
            })
        } else {
            IZRouter.lanchMatchView(matchId, type: IZPushType.izPushOneMatchType )
        }
    }
    
    fileprivate func noMatchPush(_ state : Bool, text : String) {
        let router = IZRouter(navigationController: self.window?.rootViewController as! UINavigationController)
        
        if state {
            router.setupHomeRootViewController()
            let alert = IZAlertCustomWithOneButton.loadFromXib()
            alert?.showView(text)
        } else {
            router.setupHomeRootViewController()
        }
    }
    
    fileprivate func missedMatchesPush(_ state : Bool, text : String) {
        
        if state {            
            let alert = AlertPushViewController.loadFromXib()
            alert?.show(text,  action: {
                IZRouter.lanchHistoryMatchView()
            })
        } else {
            IZRouter.lanchHistoryMatchView()
        }
    }
    
    fileprivate func missedMessagePush(_ state : Bool, text : String, recipientId : String) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        IZUserDefaults.recordMissedMessage()
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: missedMessagePushNotification), object: nil))
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: missedMessageChatPushNotification), object: nil))
        if state {
            let alert = IZAlertMessagePush.loadFromXib()
            alert?.showNewMessage(text, action: {
                IZRouter.lanchChatViewFromPush(recipientId)
            })
        } else {
            IZRouter.lanchChatViewFromPush(recipientId)
        }
    }
    
    fileprivate func acceptedMatch(_ state : Bool, messageFrom : String, matchId : String) {
        // state - true - active mode
        if state {
            self.userFromPush(matchId, copmlited: { (interests) in
                
                let text = messageFrom /*+ " also likes to talk about " + interests*/
                let alertView = AlertPushViewController.loadFromXib()
                
                alertView?.showAcceptedMatch(text, action: {
                    IZRouter.lanchMatchView(matchId,type: IZPushType.izPushAcceptedMatchType)
                })
            })
        } else {
            IZRouter.lanchMatchView(matchId,type: IZPushType.izPushAcceptedMatchType)
        }
    }
    
}

extension AppDelegate {
    
    //*****************************************************************
    // MARK: - location and Start Setup
    //*****************************************************************
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.distanceFilter = minimumDistanceLocation  //kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters  //kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        if #available(iOS 9, *) {
            self.locationManager.allowsBackgroundLocationUpdates = true
        }
    }
    
    fileprivate func userFromPush(_ userId : String, copmlited:@escaping (String) -> () ) {
        if !IZReachability.isConnectedToNetwork() {
            IZAlert.showAlert(IZRouter.topCurrentViewController(), title: AlertText.TitleNoInternet.rawValue, message: AlertText.NoInternetMessage.rawValue, action: nil)
            return
        }
        IZRestAPIMatchOperations.userFromPushMatchOperation(userId, responce: { (responceObject, statusResponse) in
            if statusResponse == RestStatus.success {
                if let user = responceObject as IZPushMatchModel? {
                    let intetestsArray = user.items?.interests
                    var interest = ""
                    if intetestsArray?.count > 0 {

                        interest = (intetestsArray?.first?.interest)!
                        self.interest = interest
                        copmlited(interest)
                    }
                }
            }
        })
    }
    
    fileprivate func updateFacebookUserOnStart() {
        let router = IZRouter(navigationController: self.window?.rootViewController as! UINavigationController)
        
        IZRestAPILoginOperations.facebookOperation { (responceObject, restStatus) in
            guard let userObject = responceObject as IZUserModel? else {
                return
            }
            if restStatus == RestStatus.success {
                IZRestAPIPushOperations.addPushIdOperation({ (message, restStatus) in
                    guard let statusPush = restStatus as RestStatus? else {
                        return
                    }
                    if statusPush == RestStatus.success {
                        router.showFirstTimeProfileViewController(userObject)
                    }
                })
            }
        }
    }
    
    fileprivate func setupProfileData(_ completed:@escaping ()->()) {
        
        IZRestAPIProfileOperations.profileGetOperation { (responceObject, restStatus) in
            guard let status = restStatus as RestStatus? else {
                return
            }
            
            if status == RestStatus.success {
                guard let user = responceObject as IZUserModel? else {
                    return
                }
                IZUserModelSingletone.sharedInstance.user = user
                completed()
            }
        }
    }

}

extension AppDelegate: CLLocationManagerDelegate {
    
    //*****************************************************************
    // MARK: - CLLocationManagerDelegate
    //*****************************************************************
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(#function)
        
        guard let latitude = locations.first?.coordinate.latitude,
            let longitude = locations.first?.coordinate.longitude else {
                return
        }
        self.latitudeCoordinate = latitude
        self.longtitudeCoordinate = longitude
        IZUserDefaults.updateLatitude(latitude)
        IZUserDefaults.updateLongtitude(longitude)
        
        let dict : Dictionary<String, CLLocationDegrees> = ["latitude" :  latitude, "longitude" :  longitude]
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UpdateCurrentUserLocation"), object: dict))

        
        let user = IZUserDefaults.getTokenToUserDefault()
        if user == nil {
            return
        }
        
        IZRestAPILocationOperations.currentPositionCall(latitude, longtitude: longitude, completed: { (statusResponse) in
            
        })
    }
    
    func updateLocationFromInterval(_ timerCurrent: Timer){
        
        print(#function)

        let lat = IZUserDefaults.getLatitude()
        let longt = IZUserDefaults.getLongtitude()
        
        print(longt)
        print(lat)
        
        IZRestAPILocationOperations.currentPositionCall(lat , longtitude: longt, completed: { (statusResponse) in
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("restricted")
            break
        case .denied:
            self.locationManagerCheck(manager, getAuthorization: status)
            break
        case .notDetermined:
            print("notDetermined")
            break
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            break
        }
    }
    
    func locationManagerCheck(_ _locationManager: CLLocationManager, getAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            let alert = IZAlertView.loadFromXib()
            alert?.showView("Talki doesn't have access to location. You can enable access in Privacy Settings", action: {
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
                
            })
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //*****************************************************************
    // MARK: - UNUserNotificationCenterDelegate
    //*****************************************************************
    
       // The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
    
//    @available(iOS 10.0, *)
//    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
//    
//
//    }
//    
//    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
//  
//    @available(iOS 10.0, *)
//    func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
//        
//    }
}


