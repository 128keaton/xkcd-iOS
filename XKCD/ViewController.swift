//
//  ViewController.swift
//  XKCD
//
//  Created by Keaton Burleson on 3/21/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import UIKit
import ImageScrollView
class ViewController: UIViewController {
    @IBOutlet var imageView: ImageScrollView?
    var currentComic: UIImage?
    let comicalClass = Comical()
    
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
  

       // NSUserDefaults.standardUserDefaults().setObject(banana, forKey: "comicDatabate")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        self.setupComicView()
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
     @IBAction func swipeDown(){

        let defaults = NSUserDefaults.standardUserDefaults();
        let comicCount = defaults.integerForKey("currentNumber") - 1
        let endpoint = NSURL(string: "http://xkcd.com/\(comicCount)/info.0.json")
        print(endpoint)
        let data = NSData(contentsOfURL: endpoint!)
        let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String : AnyObject],
        // Notice the extra question mark here!
        comicImg = jsonDict?!["img"] as! String;
        print(comicImg);
        defaults.setInteger(jsonDict?!["num"] as! Int, forKey: "currentNumber");
        defaults.synchronize();
        let url = NSURL.init(string: comicImg);
        let imageData = NSData(contentsOfURL:url!)
        if imageData != nil {
            imageView?.displayImage(UIImage(data:imageData!)!)
            self.currentComic = UIImage(data:imageData!)
        }

        
    }
     @IBAction func swipeUp(){
        let defaults = NSUserDefaults.standardUserDefaults();
        
        var comicCount = defaults.integerForKey("currentNumber")
        if(comicCount < defaults.integerForKey("maxNumber")){
            
         comicCount = defaults.integerForKey("currentNumber") + 1
        let endpoint = NSURL(string: "http://xkcd.com/\(comicCount)/info.0.json")
        print(endpoint)
        let data = NSData(contentsOfURL: endpoint!)
        let jsonDict = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String : AnyObject],
        // Notice the extra question mark here!
        comicImg = jsonDict?!["img"] as! String;
        print(comicImg);
        defaults.setInteger(jsonDict?!["num"] as! Int, forKey: "currentNumber");
        defaults.synchronize();
        let url = NSURL.init(string: comicImg);
        let imageData = NSData(contentsOfURL:url!)
        if imageData != nil {
            imageView?.displayImage(UIImage(data:imageData!)!)
            self.currentComic = UIImage(data:imageData!)
        }
            
        }else{
            let alert = UIAlertController.init(title: "Error", message: "No more comics", preferredStyle: UIAlertControllerStyle.Alert);
            let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
               alert.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil);
        }

        
    }
     @IBAction func twoFingerTap(){

        let comic = currentComic
        let activityViewController = UIActivityViewController(activityItems: [comic! as UIImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
        

        
    }
    func setupComicView(){
        let data = NSData(contentsOfURL: self.getLatestComic());
        if data != nil {
            imageView?.displayImage(UIImage(data:data!)!)
            self.currentComic = UIImage(data:data!)
        }
        imageView?.contentMode = UIViewContentMode.Center
    }
    
    
   
    
}




