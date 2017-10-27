//
//  SourcesCollectionViewController.swift
//  News App
//
//  Created by Saksham Bhalla on 10/11/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

class SourcesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // List of Sources
    // Conservative: breitbart, foxnews, drudgereport, dailycaller, washingtontimes, townhall, thehill, nypost, zerohedge, theblaze, nationalreview
    // Liberal: msnbc, newyorker, cnn, huffingtonpost, politico, nytimes, washingtonpost, nbcnews, dailykos, vox, thenation
    
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // Global Variables
    var activeSource = 0
    
    // Dictionary categorizing each source as liberal/conservative
    var categorizer = ["breitbart": "C", "foxnews": "C", "drudgereport": "C", "dailycaller": "C", "washingtontimes": "C", "townhall": "C", "thehill": "C", "newyorkpost": "C", "wnd": "C", "zerohedge": "C", "theblaze": "C", "nationalreview": "C",
       "msnbc": "L", "thenewyorker": "L", "cnn": "L", "huffingtonpost": "L", "politico": "L", "nytimes": "L", "cnsnews": "L", "washingtonpost": "L", "nbcnews": "L", "dailykos": "L", "vox": "L", "thenation": "L"]
    
    // List of sources & Liberal, Conservative count on screen.
    var images = ["breitbart", "foxnews", "drudgereport", "dailycaller", "washingtontimes", "townhall",
                  "msnbc", "thenewyorker", "cnn", "huffingtonpost", "politico", "nytimes"]
    var cCount = 6
    var lCount = 6
    
    // List of Liberal, Conservatives images in background.
    var conservativeImages = ["thehill", "newyorkpost", "wnd", "zerohedge", "theblaze", "nationalreview"]
    var liberalImages = ["cnsnews", "washingtonpost", "nbcnews", "dailykos", "vox", "thenation"]
    
    
    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        print ("Unshuffled Images: ", images)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SourcesCell", for: indexPath) as! SourcesCell
        cell.myImage.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeSource = indexPath.row
        biasing(index: indexPath.row)
        performSegue(withIdentifier: "toArticleTableViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toArticleTableViewController") {
            
            let articleDisplayViewController = segue.destination as! ArticleTableViewController
            articleDisplayViewController.activeSource = activeSource
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Custom functions
    func biasing(index: Int) {

//        images.shuffle()
//        print ("Shuffled Images: ", images)
        
        // Liberal Source Chosen
        if (categorizer[images[index]] == "L") {
            
            if (lCount < 12) {
                for (i, image) in images.enumerated() {
                    
                    if (categorizer[image] == "C") {
                        
                        // Remove conservative source & add to conservativeImages
                        conservativeImages.append(image)
                        
                        // Add liberal source from liberalImages
                        images[i] = liberalImages[0]
                        
                        lCount += 1
                        cCount -= 1
                        
                        break
                    }
                }
            }
        }

        // Conservative Source Chosen
        else {
            
            if (cCount < 12) {
                for (i, image) in images.enumerated() {
                    if (categorizer[image] == "L") {
                        
                        // Remove liberal source & add to liberalImages
                        liberalImages.append(image)
                        
                        // Add conservative source from conservativeImages
                        images[i] = conservativeImages[0]
                        
                        lCount -= 1
                        cCount += 1
                        
                        break
                    }
                }
            }
        }
        
        print ("Biased Images: ", images)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
