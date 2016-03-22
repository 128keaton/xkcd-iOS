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

class ComicListView: UITableViewController {
	var comicDictionary = NSMutableArray()
	var comical = Comical()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupArray()
		self.tableView.delegate = self

		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return comicDictionary.count
	}
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
		let textDictionary = comicDictionary.objectAtIndex(indexPath.row)
		cell.textLabel?.text = "\(textDictionary["number"] as! NSNumber). \(textDictionary["name"] as! String)"

		return cell
	}
	func setupArray() {
		MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			let temporaryArray = Comical().fetchList(Comical().getLatestComicNumber(), end: Comical().getLatestComicNumber() - 15)
			for apple in temporaryArray {
				self.comicDictionary.addObject(apple)
			}

			dispatch_async(dispatch_get_main_queue()) {
				self.tableView.reloadData()
				MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: true)
			}
		}
	}

    @IBAction func returnHome(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
		self.performSegueWithIdentifier("showComic", sender: indexPath.row)
	}
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		let lastRow = comicDictionary.count - 1
		if (indexPath.row == lastRow) {

			MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
			let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
			dispatch_async(dispatch_get_global_queue(priority, 0)) {
				let temporaryArray = Comical().fetchList(Comical().getLatestComicNumber() - self.comicDictionary.count, end: Comical().getLatestComicNumber() - self.comicDictionary.count - 10)
				for apple in temporaryArray {
					self.comicDictionary.addObject(apple)
				}

				dispatch_async(dispatch_get_main_queue()) {
					self.tableView.reloadData()
					MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: true)
				}
			}
		}
	}
}