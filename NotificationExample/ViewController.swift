//
//  ViewController.swift
//  NotificationExample
//
//  Created by Ahmet Burak Öztürk on 11.06.2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    var notificationPermissionControl:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().delegate = self
        
        //Permission Operation
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {
            (granted, error) in
            
            self.notificationPermissionControl = granted
            
            if granted {
                print("permission response succesfull")
            } else {
                print("permission response denied!")
            }
            }
        )
        
    }
    
    @IBAction func sendNotificationButtonClicked(_ sender: Any) {
        if notificationPermissionControl{
            
            //Notification Actions
            let yesAction = UNNotificationAction(identifier: "yesOption", title: "Yes", options: .foreground)
            let noAction = UNNotificationAction(identifier: "noOption", title: "No", options: .foreground)
            let deleteAction = UNNotificationAction(identifier: "deleteOption", title: "Delete", options: .destructive)
            
            let actionCategory = UNNotificationCategory(identifier: "actionCategory", actions: [yesAction,noAction,deleteAction], intentIdentifiers: [],options: [])
            UNUserNotificationCenter.current().setNotificationCategories([actionCategory])
            
            //Notification Content
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Daily Question"
            notificationContent.subtitle = "Subtitle"
            notificationContent.body = "Did you learn anything about ios development today?"
            notificationContent.badge = 1
            notificationContent.sound = UNNotificationSound.default
            notificationContent.categoryIdentifier = "actionCategory"
            
            //Notification Trigger
            let notifTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //Notification Request
            let notifReq = UNNotificationRequest(identifier: "dailyQuestion", content: notificationContent, trigger: notifTrigger)
            
            UNUserNotificationCenter.current().add(notifReq, withCompletionHandler: nil)
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {
                (granted, error) in
                
                self.notificationPermissionControl = granted
                
                if granted {
                    print("permission response succesfull")
                } else {
                    print("permission response denied!")
                }
                }
            )
        }
    }
    
}

// This extension for notification will workable in foreground
extension ViewController:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "yesOption" {
            print("Well done. You're going perfect. Keep going and believe yourself.")
        }else if response.actionIdentifier == "noOption" {
            print("Oopps! If you want to be a good programmer you have to learn. Just believe yourself, you can do this.")
        }else if response.actionIdentifier == "deleteOption" {
            print("User deleted notification.")
        }
        
    }
}

