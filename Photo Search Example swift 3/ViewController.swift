//
//  ViewController.swift
//  Photo Search Example swift 3
//
//  Created by Victor Lo on 9/14/16.
//  Copyright © 2016 Victor Lo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlickrByHashtag(searchString: "cats")
        }
    
        func searchFlickrByHashtag (searchString: String) {
            
        let manager = AFHTTPSessionManager()
        
        let searchParameters: Dictionary<String, Any> = ["method": "flickr.photos.search",
                                                         "api_key": "0f0416975ea40fe802524b1cda791a8f",
                                                         "format": "json",
                                                         "nojsoncallback": 1,
                                                         "text": searchString,
                                                         "extras": "url_m",
                                                         "per_page": 5] //This is a Dictionary variable, contains [String, Any]
        
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success:
            {
                (operation: URLSessionDataTask, responseObject: Any?) in
           //changes #3, here: [String, String] means Dictionary<String, String>
                        //A dictionary is a variable type that has an ID and value
                        //First value is ID, second value is valuee
                        //So, String:Any will be... ID (key) is string, value is Any
                        //so variableName is a Dictionary<String, Any>
                        //by doing variableName["ID"] it returns the value (Any)
                        //we don't know if Any is another DIctionary, for that, we need to check the json
                        //so once we know that, we can cast it as a dictionary again
                        //so variablename = is [String, Any] (String to call "photos"), (Any because we don't want to cast 
                        //it as DIctionary of Dictionary of Dictionary or something like that
                        //next step is photos
                        //photos is the dictionary that cointains each of the photo which is another dictionary
                        //because the format is like this:
                        //photos{ photo{stuff}, photo{stuff}, photo{stuff}, etc}
                        //I think that [[String:Any]] is a Dictionary of Dictionary
                
                        
                        /*
                         Optional({
                         photos =     { //photos contains... Key, Value, for example, page is Key, 1 is value. Meaning Dictionary<String, Any> or [String,Any]
                
                         page = 1;
                         pages = 63021;
                         perpage = 5;
                         photo =         ( //Here, photo, has more Key, Value, so photo is AN ARRAY of Dictionary<String, Any>
                         //why it is an array? because it's separated with commas here and it contains various photos
                         //so, knowing that it's String, Any, we can call the string to get the Value
                         //this means, if we call "farm" the value will be 9
                         //if we want the url, we call "url_m" and we get https://....
                         //when do we use Dictionary? 
                         //When we want a value to be identified by something in an unordered way, for example
                         //say in helbreath we have various items which contain an ID
                         "devastator":511
                         "abbyring":606
                         etc
                         //so the first value is String, this is the Key to find the value
                         //the second value is aan Int, this is the value the key will return when we call Items["devastator"]
                         //we can also have something lik this...
                         items 
                         {
                            item
                            {
                                name: "devastator"
                                id: 501
                                damage: 3d8+1
                            },
                            {
                                name:"stormbringer"
                                etc
                            }
                         {
                         
                         so... 
                         items is the KEY for the dictionary
                         so we have this...
                         let items = variable["items"] as? [String: Any] //Why String? because we identify it as "items"
                         //why Any? because we will convert that Any into the object that is in the next cast
                         let ietmArray = items["item"] as? [[String: Any]] //This means... array of Dictionary
                         //Why array? because we have various items separated by comma
                         //why Dictionary? because we have Key:Value, which is name:"devastator", id:501, and more
                         do you understand any of it?// i Understand, maybe, 60% of it. you explained it well
                         tell me, what is this? 
                         
                         item
                         {
                         name: "devastator"
                         id: 501
                         damage: 3d8+1
                         },
                         {
                         name: "devastator"
                         id: 501
                         damage: 3d8+1
                         },
                         first we must ask, is it an array?
                         the thing is, this is json, in json, you can have objects separated by comma,
                         what json does is to write the objects into a file, and you must parse them into your language (swift, c++, java)  in the format you desire.
                        we know that we must PARSE IT as an array because it has various items separated by comma
                 
                         now, each of this objects has what? ID and Any type yes
                         so is it a dictionary? an array? an array of dictionary? hmm tricky. Its a array of dict yes
                         because 
                         1- various items
                         2- has key:value 
                         so to declare a dictionary we must do
                         as [String:Any]
                         to declare an array we must do
                         as [type]
                         result: [[String:Any]] (array of Dictionary)
                 
                  */
                
    if let responseObject = responseObject as? Any {
                    
            print("Response: \(responseObject)")
                 
    if let variableName = responseObject as? [String: Any] {

    if let photos = (variableName["photos"] as? [String: Any]) {
    if let photoArray = photos["photo"] as? [[String: Any]] {
        
            let imageWidth = self.view.frame.width
                                
            self.scrollView.contentSize = CGSize(width: imageWidth, height: imageWidth * CGFloat(photoArray.count))
            for (i, photoDictionary) in photoArray.enumerated() {
        
    if let imageURLString = photoDictionary["url_m"] as? String {
                
            let imageView = UIImageView(frame: CGRect(x: 0, y: imageWidth * CGFloat(i), width: imageWidth, height:imageWidth))
                                        
    if let url = URL(string: imageURLString) {
                                            
            imageView.setImageWith(url)
            self.scrollView.addSubview(imageView)
                                         
        }
        }
        }
        }
        }
        }
        }
                
        
        },
    failure: {
            
            (operation: URLSessionDataTask?, error: Error) in
            print("Error: " + error.localizedDescription)
            })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
         subview.removeFromSuperview()
    }
        
    searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            
         searchFlickrByHashtag(searchString: searchText)
            
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

}
