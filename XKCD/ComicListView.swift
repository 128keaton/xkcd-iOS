//
//  ComicListView.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/21/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
import ImageScrollView
import MBProgressHUD
import FetchKCD
import ReachabilitySwift


extension ComicListView: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class ComicListView: UITableViewController, UISearchControllerDelegate {
	var comicDictionary = NSMutableArray()
	var favoritesArray = NSMutableArray()
	var isJacksonGrounded = false
    var nameArray = [String]()
    var filteredNames = [String]()
    var referenceArray = NSMutableArray()
    let searchController = UISearchController(searchResultsController: nil)
    
	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.delegate = self
		if ((NSUserDefaults.standardUserDefaults().objectForKey("favorites")) != nil) {
			favoritesArray = NSUserDefaults.standardUserDefaults().objectForKey("favorites")?.mutableCopy() as! NSMutableArray
		}
        self.setupSearch()

        var reachability: Reachability?
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
		// Do any additional setup after loading the view, typically from a nib.
	}


    func setupSearch(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!searchController.active && searchController.searchBar.text == ""){
            return comicDictionary.count
        }else{
                return self.filteredNames.count
            }
        
	}
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
		let textDictionary = comicDictionary.objectAtIndex(indexPath.row)
        if(!searchController.active && searchController.searchBar.text == ""){
		cell.textLabel?.text = "\(textDictionary["number"] as! NSNumber). \(textDictionary["name"] as! String)"
        }else{
            
            cell.textLabel?.text = self.filteredNames[indexPath.row]
        }
		let addFavorites = UILongPressGestureRecognizer.init(target: self, action: "addToFavorites:")

		cell.addGestureRecognizer(addFavorites)

		if (favoritesArray.containsObject(self.comicDictionary.objectAtIndex(indexPath.row))) {
			cell.accessoryView = self.createAccessoryView()
		}

		return cell
	}
    
    
    
	func setupArray() {
        dispatch_async(dispatch_get_main_queue()) {
            MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        }
        
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			print("Latest comic: \(FetchKCD().getLatestComicNumber())")
            
			let temporaryArray = FetchKCD().fetchList(FetchKCD().getLatestComicNumber() + 1, end: FetchKCD().getLatestComicNumber() - 15)
			for apple in temporaryArray {
				self.comicDictionary.addObject(apple)
                let dictionaryOfComic = apple as! NSMutableDictionary
                
                self.nameArray.append(("\(dictionaryOfComic["number"] as! NSNumber). \(dictionaryOfComic["name"] as! String)") as String)
                

                //im smert
			}
           

			dispatch_async(dispatch_get_main_queue()) {
				self.tableView.reloadData()
				MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: true)
			}
		}
	}
	func createAccessoryView() -> UIImageView {

		let accessoryView = UIImageView.init(image: UIImage(named: "Star Filled-50.png", inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil))
		accessoryView.frame = CGRectMake(0, 0, 20, 20)
		return accessoryView
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(true)
       
		
	}

    
    
	func reachabilityChanged(note: NSNotification) {

		let reachability = note.object as! Reachability
        self.tableView.beginUpdates()
		if reachability.isReachable() {
			isJacksonGrounded = false
			MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.setupArray()
		} else {
			isJacksonGrounded = true
			
		}
        self.tableView.endUpdates()
	}
	override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if (isJacksonGrounded == true) {
			let label = UILabel.init(frame: CGRectMake(self.view.frame.origin.x, 200, self.view.frame.width, 100))
			label.text = "no internet :("
			label.textAlignment = NSTextAlignment.Center
			label.textColor = UIColor.grayColor()
			return label
		}
        return UIView.init()
	}

	func addToFavorites(sender: UILongPressGestureRecognizer) {
		let pressPoint = sender.locationInView(self.tableView)
		let indexPath = self.tableView.indexPathForRowAtPoint(pressPoint)

		let individualComicDictionary = self.comicDictionary.objectAtIndex((indexPath?.row)!) as! NSMutableDictionary
		if (sender.state == UIGestureRecognizerState.Ended) {
			if (!favoritesArray.containsObject(individualComicDictionary)) {
				favoritesArray.addObject(individualComicDictionary.mutableCopy())
				self.tableView.beginUpdates()
				let cell = self.tableView.cellForRowAtIndexPath(indexPath!)
				cell?.accessoryView = self.createAccessoryView()
				cell?.accessoryView?.frame = CGRectMake(0, 0, 0, 0)
				UIView.animateWithDuration(0.2, delay: 0.0,
					options: [], animations: {
						cell?.accessoryView?.frame = CGRectMake(0, 0, 20, 20)
					}, completion: nil)
				let temporaryDictionary = self.comicDictionary.objectAtIndex((indexPath?.row)!)
				let url = NSURL.init(string: temporaryDictionary["url"] as! String)

				let imageData = NSData(contentsOfURL: url!)
				if imageData != nil {
					let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
					if let image = UIImage(data: imageData!) {
						let fileURL = documentsURL.URLByAppendingPathComponent(temporaryDictionary["name"] as! String)
						if let pngImageData = UIImagePNGRepresentation(image) {
							pngImageData.writeToURL(fileURL, atomically: false)
						}
					}
				}

				self.tableView.endUpdates()
			} else {
				print("Removing favorite")
				favoritesArray.removeObject(individualComicDictionary.mutableCopy())
				self.tableView.beginUpdates()
				let cell = self.tableView.cellForRowAtIndexPath(indexPath!)
				UIView.animateWithDuration(1, animations: { () -> Void in
					let animation = CABasicAnimation(keyPath: "transform")
					var tr = CATransform3DIdentity
					tr = CATransform3DScale(tr, 0.01, 0.01, 1);
					animation.toValue = NSValue(CATransform3D: tr)
					cell?.accessoryView?.layer.addAnimation(animation, forKey: "transform")
				}) { (finished: Bool) -> Void in
					cell?.accessoryView = nil
				}

				removeOldFileIfExist(individualComicDictionary["name"] as! String)
				self.tableView.endUpdates()
			}
		}

		NSUserDefaults.standardUserDefaults().setObject(favoritesArray, forKey: "favorites")
		NSUserDefaults.standardUserDefaults().synchronize()
	}

	@IBAction func returnHome() {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	func removeOldFileIfExist(name: String) {
		let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
		if paths.count > 0 {
			let dirPath = paths[0]
			let fileName = name
			let filePath = NSString(format: "%@/%@", dirPath, fileName) as String
			if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
				do {
					try NSFileManager.defaultManager().removeItemAtPath(filePath)
					print("old image has been removed")
				} catch {
					print("an error during a removing")
				}
			}
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "toComic") {
            if(searchController.active == false){
			let comicViewer = segue.destinationViewController as! IndividualComicViewer
			let row = sender as! Int
			let temporaryDictionary = self.comicDictionary.objectAtIndex(row)
			let url = NSURL.init(string: temporaryDictionary["url"] as! String)

			let imageData = NSData(contentsOfURL: url!)
			if imageData != nil {
				let comic = UIImage.init(data: imageData!)
				comicViewer.comic = comic
				comicViewer.setComicViewImage(comic!)
				comicViewer.title = temporaryDictionary["name"] as? String
                
			}
            }else{
                let comicViewer = segue.destinationViewController as! IndividualComicViewer
                let row = sender as! Int
                let finder = filteredNames[row] 
                var temporaryDictionary = NSMutableDictionary()
                let finalCount = finder as String
                print("Screw you: \(finalCount)")
                
                let stringArray = finalCount.componentsSeparatedByCharactersInSet(
                    NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                let newString = stringArray.joinWithSeparator("")
                print("Screw you: \(newString)")
                
                let count = newString.characters.count as Int
                if(count > 4){
                var screwYou = newString as NSString
                screwYou = screwYou.substringWithRange(NSRange(location: 0, length: count - 4))
                print("Screw you: \(screwYou)")
                
                screwYou = screwYou as String
       
                
                let stringToInt = Int(screwYou as String)
                temporaryDictionary = FetchKCD().getComicByNumber(stringToInt!)
                }else{
                  temporaryDictionary = FetchKCD().getComicByNumber(Int(newString)!)
                }
                
                let url = NSURL.init(string: temporaryDictionary["url"] as! String)
                
                let imageData = NSData(contentsOfURL: url!)
                if imageData != nil {
                    let comic = UIImage.init(data: imageData!)
                    comicViewer.comic = comic
                    comicViewer.setComicViewImage(comic!)
                    comicViewer.title = temporaryDictionary["name"] as? String
            }
            }
		}
	}
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredNames = nameArray.filter { name in
            return name.lowercaseString.containsString(searchText.lowercaseString)
            
        }
        
        tableView.reloadData()
    }
    
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
		self.performSegueWithIdentifier("toComic", sender: indexPath.row)
	}
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		let lastRow = comicDictionary.count - 1
		if (indexPath.row == lastRow && searchController.searchBar.text == "" && searchController.active == false) {

			MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
			let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
			dispatch_async(dispatch_get_global_queue(priority, 0)) {
				let temporaryArray = FetchKCD().fetchList(FetchKCD().getLatestComicNumber() - self.comicDictionary.count, end: FetchKCD().getLatestComicNumber() - self.comicDictionary.count - 10)
				for apple in temporaryArray {
                    let dictionaryOfComic = apple as! NSMutableDictionary
					self.comicDictionary.addObject(apple)
                    self.nameArray.append(("\(dictionaryOfComic["number"] as! NSNumber). \(dictionaryOfComic["name"] as! String)") as String)
				}

				dispatch_async(dispatch_get_main_queue()) {
					self.tableView.reloadData()
					MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: true)
				}
			}
		}
	}
}


