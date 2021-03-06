//
//  AlbumsTableViewController.swift
//  Pure Swift Networking Example
//
//  Created by Sebastian Osiński on 10.12.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {
    
    let api = API()
    var albums = [Album]()
    var author = "Taylor Swift"

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    func refresh() {
        api.fetchAlbumsForAuthor(author) { [unowned self] (albums) -> Void in
            self.albums = albums
            // here our UI gets updated
            // this closure is executed on main thread
            // (we used GCD in API.swift to achieve that)
            self.title = self.author
            self.tableView.reloadData()
        }
    }

    @IBAction func searchAuthor() {
        let ac = UIAlertController(title: "Search albums", message: "Whose albums do you want to search for?", preferredStyle: .Alert)
        
        ac.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Taylor Swift"
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .Default) { [unowned self] (_) -> Void in
            if let author = ac.textFields?[0].text where author != "" {
                self.author = author
                self.refresh()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        ac.addAction(searchAction)
        ac.addAction(cancelAction)
        presentViewController(ac, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Album Cell", forIndexPath: indexPath)
        let album = albums[indexPath.row]
        
        cell.textLabel?.text = album.albumName
        cell.detailTextLabel?.text = "\(album.albumPrice)"
        
        return cell
    }

}
