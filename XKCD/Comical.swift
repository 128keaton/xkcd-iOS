//
//  Comical.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/21/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation

class Comical: NSObject {
	func fetchList(begin: Int, end: Int) -> NSMutableArray {
		var comicDictionary = NSMutableArray()
		var e = end
		for let i = begin; i > e; e++
		{
            // this is freaking inefficient
			let endpoint = NSURL(string: "http://xkcd.com/\(e)/info.0.json")
			let data = NSData(contentsOfURL: endpoint!)
			let jsonDictOfComic = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
			let whomboCombo: NSMutableDictionary = ["url": jsonDictOfComic!!["img"]!, "name": jsonDictOfComic!!["title"]!, "number": jsonDictOfComic!!["num"]!]
			comicDictionary.addObject(whomboCombo)
			print(jsonDictOfComic!!["title"])
		}
        comicDictionary =  NSMutableArray(array: comicDictionary.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray //hahaha cause screw the actual order that im fetching
		return comicDictionary
	}

	func getLatestComicNumber() -> Int {
		let endpoint = NSURL(string: "http://xkcd.com/info.0.json")
		let data = NSData(contentsOfURL: endpoint!)
		let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
		return jsonDict!!["num"] as! Int
	}
}