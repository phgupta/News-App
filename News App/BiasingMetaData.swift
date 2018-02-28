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
    var versionType: Int = 0;
    var uniqueID: String = "";
    var categorizer = ["Breitbart": "C", "Fox News": "C", "Drudge Report": "C", "Daily Caller": "C", "Washington Times": "C", "Townhall": "C", "The Hill": "C", "New York Post": "C", "Zero Hedge": "C", "The Blaze": "C", "National Review": "C", "CNS News": "C",
                       "MSNBC": "L", "New Yorker": "L", "CNN": "L", "Huffington Post": "L", "Politico": "L", "The New York Times": "L", "Washington Post": "L", "NBC News": "L", "Daily Kos": "L", "Vox": "L", "The Nation": "L", "Slate": "L"]
    var liberalSources = ["MSNBC", "New Yorker", "CNN", "Huffington Post", "Politico", "The New York Times",
                          "Washington Post", "NBC News", "Daily Kos", "Vox", "The Nation", "Slate"]
    var conservativeSources = ["Breitbart", "Fox News", "Drudge Report", "Daily Caller", "Washington Times", "Townhall",
                               "The Hill", "New York Post", "Zero Hedge", "The Blaze", "National Review", "CNS News"]
    var activeSources = [String]()
    
    // Keeps a score of how liberal the user is
    var biasingScore = 50
    
    // Added
    var liberalScore = 6
    var conservativeScore = -6
    
    func noBiasing() {
        activeSources.removeAll()
        liberalSources.shuffle()
        conservativeSources.shuffle()
        
        for i in 0...11 {
            let rand = Int(arc4random_uniform(101))
            
            if (rand < 50) {
                activeSources.append(conservativeSources[i])
            } else {
                activeSources.append(liberalSources[i])
            }
        }
    }
    
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
        
        if (liberalScore != 0) {
            biasingScore += liberalScore
            liberalScore -= 1
        }
    }
    
    func lArticleClicked() {
        biasingScore += 1
    }
    
    func cSourceClicked() {
        
        if (conservativeScore != 0) {
            biasingScore += conservativeScore
            conservativeScore += 1
        }
    }
    
    func cArticleClicked() {
        biasingScore -= 1
    }
    
    func setBiasingScore(score: Int) {
        biasingScore = score
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
