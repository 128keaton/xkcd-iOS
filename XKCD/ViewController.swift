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
class ViewController: UIViewController {
	@IBOutlet var imageView: ImageScrollView?
	var currentComic: UIImage?
	var currentComicNumber: Int?
	let comicalClass = FetchKCD()
    
    @IBOutlet var navigationBar: UINavigationBar?
	@IBOutlet var nextButton: UIBarButtonItem?

	override func viewDidLoad() {
		super.viewDidLoad()
		let backOneComic = UITapGestureRecognizer.init(target: self, action: "swipeDown")

		backOneComic.numberOfTapsRequired = 3
		imageView?.addGestureRecognizer(backOneComic);

		let upOneComic = UITapGestureRecognizer.init(target: self, action: "swipeUp")

		upOneComic.numberOfTapsRequired = 4
		imageView?.addGestureRecognizer(upOneComic);

		let saveComic = UITapGestureRecognizer.init(target: self, action: "twoFingerTap")
		saveComic.numberOfTapsRequired = 2
		imageView?.addGestureRecognizer(saveComic)
        
        let jumpToLatest = UITapGestureRecognizer.init(target: self, action: "setupComicView")
        
        self.navigationBar?.addGestureRecognizer(jumpToLatest)

		self.setupComicView()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
	func refreshView() {
		if (comicalClass.getLatestComicNumber() == currentComicNumber) {
			nextButton?.enabled = false
		} else {
			nextButton?.enabled = true
		}
   
        navigationBar?.items![0].title = comicalClass.getComicTitle(currentComicNumber!)
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

