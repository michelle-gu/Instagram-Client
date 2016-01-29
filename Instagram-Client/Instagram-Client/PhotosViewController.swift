//
//  PhotosViewController.swift
//  Instagram-Client
//
//  Created by Michael Wang on 1/28/16.
//  Copyright © 2016 Ziyuan Wang. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var popularPhotos : [NSDictionary]?

    @IBOutlet weak var photosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photosTableView.rowHeight = 320
        loadPopularPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPopularPhotos() {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.popularPhotos = responseDictionary["data"] as? [NSDictionary]
                            self.photosTableView.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let popularPhotos = popularPhotos {
            return 1
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell

        
        let post = popularPhotos![indexPath.section]
        let photoURL = NSURL(string: ((post["images"] as! NSDictionary)["standard_resolution"] as! NSDictionary)["url"] as! String)
        
        cell.photoCellImage.setImageWithURL(photoURL!)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        print(section)
        let post = popularPhotos![section]
        let profileURL = NSURL(string: (post["user"] as! NSDictionary)["profile_picture"] as! String)
        profileView.setImageWithURL(profileURL!)
        
        headerView.addSubview(profileView)
        
        let nameLabel = UILabel(frame: CGRect(x: profileView.frame.origin.x + profileView.frame.size.width + 10, y: 0, width: headerView.frame.size.width - 10 - profileView.frame.size.width - profileView.frame.origin.x, height: 50))
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.text = (post["user"] as! NSDictionary)["username"] as? String
        
        headerView.addSubview(nameLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let popularPhotos = popularPhotos {
            return popularPhotos.count
        } else {
            return 0
        }
    }
}
