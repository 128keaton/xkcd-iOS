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
    @IBOutlet var comicView: ImageScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setComicViewImage(comic!)
        
    }
    func setComicViewImage(comic: UIImage){
        self.comicView?.displayImage(comic)
    }
}
