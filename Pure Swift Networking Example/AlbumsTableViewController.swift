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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        api.fetchAlbumsForAuthor("Taylor Swift") { [unowned self] (albums) -> Void in
            self.albums = albums
            // here our UI gets updated
            // this closure is executed on main thread
            // (we used GCD in API.swift to achieve that)
            self.tableView.reloadData()
        }
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
