//
//  API.swift
//  Pure Swift Networking Example
//
//  Created by Sebastian Osiński on 10.12.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import Foundation

class API {
    
    let address = "https://itunes.apple.com/"
    let albumEndpoint = "search"
    
    
    func fetchAlbumsForAuthor(author: String, completion: ([Album]) -> Void) {
        var fetchedAlbums = [Album]()
        
        // passed author might contain spaces, so we have to replace them with "+",
        // because that's the way, iTunes API deals with multi-word parameter values
        let term = author.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let entity = "album"
        
        let query =  "?term=\(term)&entity=\(entity)"
        
        // Create URL from our address, endpoint and query.
        // This NSURL intializer is failable one - it can return nil
        // if supplied string does not represent valid URL,
        // so we need to safely unwrap it
        if let url = NSURL(string: address + albumEndpoint + query) {
            // Get shared NSURLSession singleton
            let session = NSURLSession.sharedSession()
            
            // Create new data task with our url.
            // Task is created with url and completionHandler which
            // has type (NSData?, NSURLResponse?, NSError?) -> Void).
            // In our example we don't bother handling errors so we pass
            // "_" to indicate that we are not going to use response and error
            // parameters of the closure. As the completionHandler is the last parameter
            // in the function, we can use trailing closure syntax to declare it.
            let task = session.dataTaskWithURL(url) { (data, _, _) -> Void in
                // Data is an optional, so we have to unwrap it safely.
                // From the data we can create JSONObject and safely cast it to a dictionary.
                // From our json dictionary we take results and safely cast them to array of dictionaries.
                if let jsonData = data,
                    json = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? [String: AnyObject],
                    results = json?["results"] as? [[String: AnyObject]] {
                        
                    for result in results {
                        // From every result we get all parameters needed for our album.
                        // Similarily as above we have to safely cast and unwrap all
                        // needed fields.
                        if let artistName = result["artistName"] as? String,
                            albumName = result["collectionName"] as? String,
                            albumPrice = result["collectionPrice"] as? Float,
                            trackCount = result["trackCount"] as? Int {
                                
                            fetchedAlbums.append(
                                Album(
                                    artistName: artistName,
                                    albumName: albumName,
                                    albumPrice: albumPrice,
                                    trackCount: trackCount
                                )
                            )
                        }
                    }
                }
                
                // Everything what happend in this closure until this point was executed on background thread.
                // We want to get back to our main thread, because we will use our completion to
                // deal with UI and those actions should be performed only on main thread.
                //
                // To do that we use GCD - Grand Central Dispatch, a framework which simplifies working with
                // concurrency as we don't need to manually create new threads and manage them.
                dispatch_async(dispatch_get_main_queue()) {
                    completion(fetchedAlbums)
                }
            }
            
            // Starts our task
            task.resume()
        }
    }
    
    
}