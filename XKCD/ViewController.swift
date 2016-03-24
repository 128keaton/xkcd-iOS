//
//  ViewController.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/21/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import UIKit
import ImageScrollView
import FetchKCD
import ReachabilitySwift
import MBProgressHUD
import Gifu
class ViewController: UIViewController {
	@IBOutlet var imageView: ImageScrollView?
	var currentComic: UIImage?
	var currentComicNumber: Int?
	let comicalClass = FetchKCD()

	@IBOutlet var nextButton: UIBarButtonItem?
	@IBOutlet var previousButton: UIBarButtonItem?
	@IBOutlet var shareButton: UIBarButtonItem?

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view, typically from a nib.
		MBProgressHUD.showHUDAddedTo(self.view, animated: true)
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(true)
		MBProgressHUD.hideHUDForView(self.view, animated: true)
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
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func reachabilityChanged(note: NSNotification) {

		let reachability = note.object as! Reachability

		if reachability.isReachable() {
			self.setupComicView()
			shareButton?.enabled = true
			previousButton?.enabled = true
		} else {
			Notifier().createNotificationWithName("Error", view: self, message: "Could not connect to the internet")
			let staticView = AnimatableImageView(frame: self.imageView!.frame)
			staticView.animateWithImage(named: "Static.gif")
			dispatch_async(dispatch_get_main_queue(), {
				//
				self.shareButton?.enabled = false
				self.previousButton?.enabled = false
                self.nextButton?.enabled = false
				self.view.addSubview(staticView)
			})
		}
	}

	@IBAction func swipeDown() {

		let comicDictionary = comicalClass.getComicByNumber(currentComicNumber! - 1)
		currentComicNumber = comicDictionary["number"] as? Int
		let url = NSURL.init(string: comicDictionary["url"] as! String);
		let imageData = NSData(contentsOfURL: url!)
		if imageData != nil {
			imageView?.displayImage(UIImage(data: imageData!)!)
			self.currentComic = UIImage(data: imageData!)
			self.refreshView()
		}
	}
	@IBAction func swipeUp() {

		if (currentComicNumber != comicalClass.getLatestComicNumber()) {
			let comicDictionary = comicalClass.getComicByNumber(currentComicNumber! + 1)
			currentComicNumber = comicDictionary["number"] as? Int
			let url = NSURL.init(string: comicDictionary["url"] as! String);
			let imageData = NSData(contentsOfURL: url!)
			if imageData != nil {
				imageView?.displayImage(UIImage(data: imageData!)!)
				self.currentComic = UIImage(data: imageData!)
				self.refreshView()
			}
		}
	}
	func refreshView() {
		if (comicalClass.getLatestComicNumber() == currentComicNumber) {
			nextButton?.enabled = false
		} else {
			nextButton?.enabled = true
		}
	}
	@IBAction func twoFingerTap() {

		let comic = currentComic
		let activityViewController = UIActivityViewController(activityItems: [comic! as UIImage], applicationActivities: nil)
		presentViewController(activityViewController, animated: true, completion: { })
	}
	func setupComicView() {
		let comicDictionary = comicalClass.getLatestComic()
		let imageData = NSData(contentsOfURL: NSURL.init(string: comicDictionary["url"] as! String)!)
		if imageData != nil {
			imageView?.displayImage(UIImage(data: imageData!)!)
			self.currentComic = UIImage(data: imageData!)
			self.currentComicNumber = comicalClass.getLatestComicNumber()
			self.refreshView()
		}
		imageView?.contentMode = UIViewContentMode.Center
	}
}
