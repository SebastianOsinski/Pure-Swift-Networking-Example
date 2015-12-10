//
//  Album.swift
//  Pure Swift Networking Example
//
//  Created by Sebastian Osiński on 10.12.2015.
//  Copyright © 2015 Sebastian Osiński. All rights reserved.
//

import Foundation

struct Album {
    let artistName: String
    let albumName: String
    let albumPrice: Float
    let trackCount: Int
    
    init(artistName: String, albumName: String, albumPrice: Float, trackCount: Int) {
        self.artistName = artistName
        self.albumName = albumName
        self.albumPrice = albumPrice
        self.trackCount = trackCount
    }
}