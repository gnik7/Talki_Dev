//
//  IZRouter.swift
//  Talki
//
//  Created by Nikita Gil on 30.06.16.
//  Copyright © 2016 Inteza. All rights reserved.
//

import UIKit

class IZRouter: NSObject {
    
    fileprivate var navigationController : UINavigationController?
    fileprivate let animator = Animator()
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************

    init(navigationController :UINavigationController)  {
        
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func popViewController(_ animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func visibleViewController() -> UIViewController {
        return (self.navigationController?.visibleViewController)!
    }
    
    func popToRootViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    class func topViewController() -> UIViewController {
        
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
    
    class func topCurrentViewController() -> UIViewController {
        
        let window = UIApplication.shared.keyWindow
        
        return (window?.rootViewController?.presentedViewController)!
    }
    
    class func navigationControllerWithID(_ identifier :String, storyboardName :String) -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return mainViewController
    }
    
    class func switchToRootViewController() -> Bool {
        guard let window = UIApplication.shared.keyWindow,
            let root = window.rootViewController as? UINavigationController  else {
                return false
        }
    
        if root.isKind(of: IZHomeViewController.self) {
            return true
        } else if (root.isKind(of: IZMatchViewController.self) || root.isKind(of: IZMatchBaseViewController.self)) {
            return false
        }
        return false
    }
    
    func switchRootViewController(_ rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                let navigation = UINavigationController(rootViewController: rootViewController)
                window.rootViewController = navigation
                UIView.setAnimationsEnabled(oldState)
                }, completion: { (finished: Bool) -> () in
                    if (completion != nil) {
                        completion!()
                    }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
    
    //*****************************************************************
    // MARK: - Setup / Home
    //*****************************************************************
    
    func setupLoginRootViewController() {
        
        let mainViewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZLoginViewController, storybordName: StoryboardsConstant.kLogin)
        self.navigationController = UINavigationController(rootViewController: mainViewController)
        self.navigationController?.delegate = self
        UIApplication.shared.delegate?.window??.rootViewController = self.navigationController
    }
    
    func setupHomeRootViewController() {
        
        let mainViewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZHomeViewController, storybordName: StoryboardsConstant.kMain)
        self.navigationController = UINavigationController(rootViewController: mainViewController)
        self.navigationController?.delegate = self
        UIApplication.shared.delegate?.window??.rootViewController = self.navigationController
    }
    
    class func setupFirstTimeHomeRootViewController() {
        
        let mainViewController = self.viewControllerWithClass(IZRouterConstant.kIZHomeViewController, storybordName: StoryboardsConstant.kMain)
        let navigationController = UINavigationController(rootViewController: mainViewController)
        UIApplication.shared.delegate?.window??.rootViewController = navigationController
    }
    
    //*****************************************************************
    // MARK: - Private
    //*****************************************************************

    fileprivate class func viewControllerWithClass(_ className: String, storybordName :String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storybordName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(className))
        return viewController
    }    
    
    //*****************************************************************
    // MARK: - Login
    //*****************************************************************
    
    func showRegistrationViewController() {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZRegistrationViewController, storybordName: StoryboardsConstant.kLogin) as! IZRegistrationViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showForgotPasswordViewController() {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZForggotPasswordViewController, storybordName: StoryboardsConstant.kLogin) as! IZForggotPasswordViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    //*****************************************************************
    // MARK: - Profile
    //*****************************************************************
    
    func showFirstTimeProfileViewController(_ userModel :IZUserModel?) {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZProfileViewController, storybordName: StoryboardsConstant.kMain) as! IZProfileViewController
        viewController.userModel = userModel
        viewController.firstTime = true
        //self.navigationController?.presentViewController(viewController, animated: false, completion: {})
        self.navigationController?.delegate = self
        self.switchRootViewController(viewController, animated: true, completion: nil)
    }
    
    func showProfileViewController(_ userModel :IZUserModel?) {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZProfileViewController, storybordName: StoryboardsConstant.kMain) as! IZProfileViewController
        viewController.userModel = userModel
        viewController.firstTime = false
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showAddInterestViewController() {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZAddInterestViewController, storybordName: StoryboardsConstant.kAdditional) as! IZAddInterestViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //*****************************************************************
    // MARK: - Settings
    //*****************************************************************
    
    func showSettingsViewController() {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZSettingsViewController, storybordName: StoryboardsConstant.kSettings) as! IZSettingsViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showGenderSettingsViewController(_ selectedGender :String?, parentViewController : IZSettingsViewController) {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZGenderSettingsViewController, storybordName: StoryboardsConstant.kSettings) as! IZGenderSettingsViewController
        viewController.selectedGender = selectedGender
        viewController.parentVC = parentViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //*****************************************************************
    // MARK: - Match
    //*****************************************************************
    
    func showMatchHistoryViewController() {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZMatchHistoryViewController, storybordName: StoryboardsConstant.kMain) as! IZMatchHistoryViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showMatchViewController(_ item : IZPushMatchItemModel?, firstInterest: String) {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZMatchViewController, storybordName: StoryboardsConstant.kMatch) as! IZMatchViewController
        viewController.currentMatch = item
        viewController.matchId = item?.id
        viewController.firstInterest = firstInterest
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func showMatchProfileViewController(_ item : IZPushMatchItemModel?, firstInterest: String) {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZMatchProfileViewController, storybordName: StoryboardsConstant.kMatch) as! IZMatchProfileViewController
        viewController.currentUserProfile = item
        viewController.firstInterest = firstInterest
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setupMatchFromPushViewController(_ matchId : String) {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZMatchViewController, storybordName: StoryboardsConstant.kMatch) as! IZMatchViewController
        viewController.matchId = matchId
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController?.delegate = self
        UIApplication.shared.delegate?.window??.rootViewController = self.navigationController
    }
    
    func setupStartChatFromPushViewController(_ matchId : String, firstInterest: String?) {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZMatchStartChatViewController, storybordName: StoryboardsConstant.kMatch) as! IZMatchStartChatViewController
        viewController.matchId = matchId
        viewController.firstInterest = firstInterest
        self.navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController?.delegate = self
        UIApplication.shared.delegate?.window??.rootViewController = self.navigationController
    }
    
    func showMatchStartChatViewController(_ itemChat: IZChatMessageItemModel?, itemPush: IZPushMatchItemModel?, firstInterest: String?) {
        
        let viewController = IZRouter.viewControllerWithClass(String(describing: IZMatchStartChatViewController.self), storybordName: StoryboardsConstant.kMatch) as! IZMatchStartChatViewController
        viewController.currentMatch = itemPush
        viewController.matchId = itemPush?.id
        viewController.itemChat = itemChat
        viewController.firstInterest = firstInterest
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    class func lanchMatchView(_ userId : String, type:IZPushType) {
        guard let window = UIApplication.shared.keyWindow,
              let root = window.rootViewController as? UINavigationController  else {
            return
        }
        let user = IZUserDefaults.getTokenToUserDefault()
        let router = IZRouter(navigationController: root)
        
        if user != nil {
            if type == IZPushType.izPushOneMatchType {
               router.setupMatchFromPushViewController(userId)
            } else if type == IZPushType.izPushAcceptedMatchType {
                router.setupStartChatFromPushViewController(userId, firstInterest: nil)
            }
        }
    }
    
    class func lanchHistoryMatchView() {
        guard let window = UIApplication.shared.keyWindow,
              let root = window.rootViewController as? UINavigationController  else {
                return
        }
        let user = IZUserDefaults.getTokenToUserDefault()
        let router = IZRouter(navigationController: root)
        
        if user != nil {
            router.showMatchHistoryViewController()
        }
    }
    
    //*****************************************************************
    // MARK: - Chat
    //*****************************************************************
    
    func showSavedChatsViewController() {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZSavedChatsViewController, storybordName: StoryboardsConstant.kChat) as! IZSavedChatsViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showChatViewController(_ item : IZChatMessageItemModel?) {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZChatViewController, storybordName: StoryboardsConstant.kChat) as! IZChatViewController
        viewController.currentChat = item
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showChatLocationViewController(_ item : IZSingleChatMessageItemModel?, name: String?) {
        
        let viewController = IZRouter.viewControllerWithClass(IZRouterConstant.kIZChatLocationViewController, storybordName: StoryboardsConstant.kChat) as! IZChatLocationViewController
        viewController.chatItem = item
        viewController.name = name
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    class func lanchChatViewFromPush(_ recipientId : String) {
        let window = UIApplication.shared.keyWindow
        let user = IZUserDefaults.getTokenToUserDefault()
        let router = IZRouter(navigationController: window?.rootViewController as! UINavigationController)
        
        if user != nil {
            
            IZRouter.updateSenderById(IZUserDefaults.getUserIdUserDefault()!, complited: { (user) in
                let sender = IZMatchUserModel.convertMatchUserToChatSender((user as IZMatchUserModel?)!)
                IZRouter.updateRecipientById(recipientId, complited: { (user) in
                    
                    let recipient = IZMatchUserModel.convertMatchUserToChatRecipient((user as IZMatchUserModel?)!)
                    let chat = IZChatMessageItemModel.convertPushSenderAndRecipientToChatMessageItem(recipient, sender: sender)
                    router.showChatViewController(chat)
                })
            })
        }
    }
    
    class func updateRecipientById(_ userId : String, complited:@escaping (_ user : IZMatchUserModel?) -> () ) {
        
        IZRestAPIMatchOperations.matchedUserByIdOperation(userId , responce:  { (responceObject, restStatus) in
            
            if restStatus == RestStatus.success {
                if let user = responceObject as IZMatchUserModel? {
                     complited(user)
                }
            }
        })
    }
    
    class func updateSenderById(_ userId : String, complited:@escaping (_ user : IZMatchUserModel?) -> () ) {
        
        IZRestAPIMatchOperations.matchedUserByIdOperation(userId , responce:  { (responceObject, restStatus) in
            if restStatus == RestStatus.success {
                if let user = responceObject as IZMatchUserModel? {
                    complited(user)
                }
            }
        })
    }
}

extension IZRouter: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation:
        UINavigationControllerOperation,
                                        from fromVC: UIViewController,
                                                           to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == UINavigationControllerOperation.push {
           return self.animator
        }
        if operation == UINavigationControllerOperation.pop {
            return self.animator
        }
        return nil
    }
}

class Animator: NSObject {
    
}

extension Animator: UIViewControllerAnimatedTransitioning {
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {        
        return 1.0
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let _ = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.to)
        
        containerView.addSubview(toVC!.view)
        toVC!.view.alpha = 0.0
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toVC!.view.alpha = 1.0
            }, completion: { finished in
                let cancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!cancelled)
        })
    }
}


