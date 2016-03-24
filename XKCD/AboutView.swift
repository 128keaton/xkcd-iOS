//
//  AboutView.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/24/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
class AboutView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeToExit = UISwipeGestureRecognizer.init(target: self, action: "dismissYoSelf")
        swipeToExit.direction = UISwipeGestureRecognizerDirection.Down
        swipeToExit.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeToExit)
    }
    
    @IBAction func dismissYoSelf(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func showIcon(){
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.icons8.com")!)
    }
}
