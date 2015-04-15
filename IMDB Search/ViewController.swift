//
//  ViewController.swift
//  IMDB Search
//
//  Created by Lance Fallon on 4/14/15.
//  Copyright (c) 2015 Lance Fallon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releasedLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var plotLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: UIButton){
        self.searchIMDB("Step Brothers")
    }

    func searchIMDB(forContent: String){
        
        var safeUrl = forContent.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        println(safeUrl!)
        var urlPath = NSURL(string: "http://www.omdbapi.com/?t=\(safeUrl!)")
        
        var session : NSURLSession = NSURLSession.sharedSession()
        
        var task = session.dataTaskWithURL(urlPath!){
            data, response, error -> Void in
            
            var jsonError : NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as! Dictionary<String, String>
            
            dispatch_async(dispatch_get_main_queue()){
                self.titleLabel.text = jsonResult["Title"]
                self.releasedLabel.text = jsonResult["Released"]
                self.ratingLabel.text = jsonResult["Rated"]
                self.plotLabel.text = jsonResult["Plot"]
                
                if let foundPosterUrl = jsonResult["Poster"] {
                    self.formatImageFromPath(foundPosterUrl)
                }
            }
            
        }
        
        task.resume()
    }
    
    func formatImageFromPath(path: String){
        var posterUrl = NSURL(string: path)
        var posterImageData = NSData(contentsOfURL: posterUrl!)
        self.postImageView.image = UIImage(data: posterImageData!)
    }
}

