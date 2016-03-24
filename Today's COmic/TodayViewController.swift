//
//  TodayViewController.swift
//  Today's Comic
//
//  Created by Keaton Burleson on 3/24/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import UIKit
import NotificationCenter
import FetchKCD
import ImageScrollView
class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet var comicView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupComic()
        // Do any additional setup after loading the view from its nib.
    }
    
    func setupComic(){
        let comic = FetchKCD().getLatestComic()
        
        let url = NSURL.init(string: comic["url"] as! String);
        let imageData = NSData(contentsOfURL: url!)
        if imageData != nil {
            comicView?.image = UIImage(data: imageData!)!
        }
        
    }
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
      
        self.setupComic()
        
        completionHandler(NCUpdateResult.NewData)
    }
    
}
