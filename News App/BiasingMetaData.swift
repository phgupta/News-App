//
//  BiasingMetaData.swift
//  News App
//
//  Created by Pranav Gupta on 11/5/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

class BiasingMetaData: NSObject {

    // Data members
    var categorizer = ["breitbart": "C", "foxnews": "C", "drudgereport": "C", "dailycaller": "C", "washingtontimes": "C", "townhall": "C", "thehill": "C", "newyorkpost": "C", "wnd": "C", "zerohedge": "C", "theblaze": "C", "nationalreview": "C",
        "msnbc": "L", "thenewyorker": "L", "cnn": "L", "huffingtonpost": "L", "politico": "L", "nytimes": "L", "cnsnews": "L", "washingtonpost": "L", "nbcnews": "L", "dailykos": "L", "vox": "L", "thenation": "L"]
    
    var liberalSources = ["msnbc", "thenewyorker", "cnn", "huffingtonpost", "politico", "nytimes",
                          "cnsnews", "washingtonpost", "nbcnews", "dailykos", "vox", "thenation"]
    var conservativeSources = ["breitbart", "foxnews", "drudgereport", "dailycaller", "washingtontimes", "townhall",
                               "thehill", "newyorkpost", "wnd", "zerohedge", "theblaze", "nationalreview"]
    var activeSources = [String]()
    
    // Keeps a score of how liberal the user is
    var biasingScore = 50
    
    
    // Member Functions
    func implementBiasing() {
        
        activeSources.removeAll()
        liberalSources.shuffle()
        conservativeSources.shuffle()
        
        for i in 0...11 {
            let rand = Int(arc4random_uniform(101))
            
            if (rand < biasingScore) {
                activeSources.append(conservativeSources[i])
            } else {
                activeSources.append(liberalSources[i])
            }
        }
    }
    
    func lSourceClicked() {
        biasingScore += 5
    }
    
    func lArticleClicked() {
        biasingScore += 1
    }
    
    func cSourceClicked() {
        biasingScore -= 5
    }
    
    func cArticleClicked() {
        biasingScore -= 1
    }
    
}


// Shuffling arrays
extension Array {
    // Randomizes the order of an array's elements.
    mutating func shuffle() {
        for _ in 0..<10 {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
