//
//  AppDelegate.swift
//  Grumpbee
//
//  Created by Thomas Yu on 11/1/14.
//  Copyright (c) 2014 thomaswhyyou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,
                   UIAlertViewDelegate,
                   DBSessionDelegate, DBNetworkRequestDelegate {

    var window: UIWindow?
    var relinkUserId: String?
    struct Classvar {
        static var outstandingRequests = 0
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Set up dropbox delegates
        let dropboxAppKey = "ngx8ear8uzvvr0t"
        let dropboxAppSecret = "cdtvrf0dvkw39of"
        let dropboxRoot: NSString = kDBRootDropbox
        let dropboxSession = DBSession(appKey: dropboxAppKey, appSecret: dropboxAppSecret, root: dropboxRoot)
        dropboxSession.delegate = self
        DBSession.setSharedSession(dropboxSession)
        DBRequest.setNetworkRequestDelegate(self)
        
        if DBSession.sharedSession().isLinked() {
            println("Yay, Dropbox is currently linked. :)")
        } else {
            println("Nope, Dropbox is not linked. :(")
        }
        
        // Set up window & its root view controller
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Dropbox
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        
        // OAuth hand back from Dropbox
        if DBSession.sharedSession().handleOpenURL(url) {
            if DBSession.sharedSession().isLinked() {
                println("App successfully linked with dropbox!")
            }
            return true
        }
        return false
    }
    
    // MARK: Dropbox : DBSessionDelegate methods
    func sessionDidReceiveAuthorizationFailure(session: DBSession!, userId: String!) {
        self.relinkUserId = userId
        let title = "Dropbox Session Ended"
        let message = "Do you want to re-link?"
        
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            println("UIAlertController can be instantiated")
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let relinkAction = UIAlertAction(title: "Relink", style: .Default) { (action) in
                DBSession.sharedSession().linkUserId(self.relinkUserId?, fromController: self.window?.rootViewController?)
                self.relinkUserId = nil
            }
            alertController.addAction(relinkAction)
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            println("UIAlertController can NOT be instantiated, using UIAlertView instead.")
            let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Relink")
            alertView.alertViewStyle = UIAlertViewStyle.Default
            alertView.show()
        }
    }
    
    // MARK: Dropbox : DBNetworkRequestDelegate methods
    func networkRequestStarted() {
        AppDelegate.Classvar.outstandingRequests++
        if (AppDelegate.Classvar.outstandingRequests == 1) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
    
    func networkRequestStopped() {
        AppDelegate.Classvar.outstandingRequests--
        if (AppDelegate.Classvar.outstandingRequests == 0) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - UIAlertViewDelegate methods
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            DBSession.sharedSession().linkUserId(self.relinkUserId?, fromController: self.window?.rootViewController?)
        }
        self.relinkUserId = nil
    }
}

