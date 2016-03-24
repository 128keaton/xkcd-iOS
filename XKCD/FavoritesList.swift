//
//  FavoritesList.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/23/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
import iAd
class FavoritesList: UITableViewController, ADBannerViewDelegate{

    @IBOutlet var iADContainer: ADBannerView?
    
    
	var favorites: NSMutableArray = NSUserDefaults.standardUserDefaults().objectForKey("favorites")?.mutableCopy() as! NSMutableArray
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupArray()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return favorites.count
	}
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")

		cell.textLabel?.text = "\(favorites.objectAtIndex(indexPath.row)["number"] as! NSNumber). \(favorites.objectAtIndex(indexPath.row)["name"] as! String)"

		return cell
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

		self.performSegueWithIdentifier("toComic", sender: indexPath.row)
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let label = UILabel.init(frame: CGRectMake(self.view.frame.origin.x, 200, self.view.frame.width, 100))
		label.text = "long hold to add to favorites"
		label.textAlignment = NSTextAlignment.Center
		label.textColor = UIColor.grayColor()
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        label.center = self.view.center
        //iADContainer?.frame = CGRectMake(0, 0, 50, screenBounds.width)
         iADContainer?.center = CGPoint(x: screenBounds.width/2, y: screenBounds.height-40-(iADContainer?.frame.height)!)
         iADContainer?.delegate = self
         iADContainer?.hidden = false
       // iADContainer?.alpha = 0.0
        let view = UIView.init(frame: CGRectMake(self.view.frame.origin.x, 0, self.view.frame.width, 166))
       
        view.addSubview(label)

		return view
	}
    func rotated()
    {
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            iADContainer?.center = CGPoint(x: screenBounds.width/2, y: screenBounds.height+20-(iADContainer?.frame.height)!)
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            iADContainer?.center = CGPoint(x: screenBounds.width/2, y: screenBounds.height-40-(iADContainer?.frame.height)!)
        }
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            favorites.removeObjectAtIndex(indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Middle)

            
            tableView.endUpdates()
            NSUserDefaults.standardUserDefaults().setObject(favorites, forKey: "favorites")
            NSUserDefaults.standardUserDefaults().synchronize()
           // iADContainer?.alpha = 1.0
            //if you are hacky and you know it, reset the center.
            let screenBounds: CGRect = UIScreen.mainScreen().bounds
            iADContainer?.center = CGPoint(x: screenBounds.width/2, y: screenBounds.height-40-(iADContainer?.frame.height)!)
        }
    }
    
    

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "toComic") {
			let comicViewer = segue.destinationViewController as! IndividualComicViewer
			let row = sender as! Int
			let temporaryDictionary = self.favorites.objectAtIndex(row)

			let comic = UIImage.init(contentsOfFile: fileInDocumentsDirectory("\(temporaryDictionary["name"] as! String).png"))
			comicViewer.comic = comic
			comicViewer.setComicViewImage(comic!)
			comicViewer.title = temporaryDictionary["name"] as? String
		}
	}

	func getDocumentsURL() -> NSURL {
		let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
		return documentsURL
	}

	func fileInDocumentsDirectory(filename: String) -> String {

		let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
		return fileURL.path!
	}

	func setupArray() {
		favorites = NSUserDefaults.standardUserDefaults().objectForKey("favorites")?.mutableCopy() as! NSMutableArray
		for apple in favorites {
			print(apple)
		}
		self.tableView.reloadData()
	}
}
