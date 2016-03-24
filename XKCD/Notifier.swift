//
//  Notifier.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/23/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

class Notifier: NSObject {
    
    func createNotificationWithName(name: String, view: UIViewController, message: String){
        let alertController = UIAlertController.init(title: name, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
        let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        
        
        view.presentViewController(alertController, animated: true) {
           
        }
        
    
    }
}