//
//  FavoritesList.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/23/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
class FavoritesList: UITableViewController {

	var favorites: NSMutableArray = NSUserDefaults.standardUserDefaults().objectForKey("favorites")?.mutableCopy() as! NSMutableArray
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupArray()
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
		return label
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
