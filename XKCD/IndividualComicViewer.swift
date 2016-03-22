//
//  IndividualComicViewer.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/22/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
import ImageScrollView
class IndividualComicViewer: UIViewController {
    
    var comic: UIImage?
    var comicTitle: NSString?
    @IBOutlet var comicView: ImageScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setComicViewImage(comic!)
        
    }
    func setComicViewImage(comic: UIImage){
        self.comicView?.displayImage(comic)
        self.navigationController?.navigationController?.navigationItem.title = comicTitle as? String
        
    }
    @IBAction func saveShareComic(){
        let activityViewController = UIActivityViewController(activityItems: [comic! as UIImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
}
