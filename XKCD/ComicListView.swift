//
//  ComicListView.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/21/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

class ComicListView: UITableViewController {
override func viewDidLoad() {
    super.viewDidLoad()
    

    // Do any additional setup after loading the view, typically from a nib.
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}
func getLatestComic() -> NSURL{
    let endpoint = NSURL(string: "http://xkcd.com/info.0.json")
    let defaults = NSUserDefaults.standardUserDefaults();
    let data = NSData(contentsOfURL: endpoint!)
    let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String : AnyObject],
    // Notice the extra question mark here!
    comicImg = jsonDict?!["img"] as! String;
    print(comicImg);
    defaults.setInteger(jsonDict?!["num"] as! Int, forKey: "maxNumber");
    defaults.setInteger(jsonDict?!["num"] as! Int, forKey: "currentNumber");
    defaults.synchronize();
    return NSURL.init(string: comicImg)!;
    
}


}