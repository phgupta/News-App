//
//  SourcesCollectionViewController.swift
//  News App
//
//  Created by Saksham Bhalla on 10/11/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

// Global Variable
let biaser = BiasingMetaData()

class SourcesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // CHECK: Update sources list with "Sources List" excel sheet
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Global Variables
    var activeSource = 0
    

    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Implement biasing everytime SourcesVC is loaded.
        biaser.implementBiasing()
        
        print("biaser.activeSources: ", biaser.activeSources)
        print("biaser.biasingScore: ", biaser.biasingScore)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return biaser.activeSources.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SourcesCell", for: indexPath) as! SourcesCell
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        cell.myImage.image = UIImage(named: biaser.activeSources[indexPath.row])
        cell.myImage.contentMode = .scaleAspectFit
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeSource = indexPath.row
        
        if (biaser.categorizer[biaser.activeSources[indexPath.row]] == "L") {
            biaser.lSourceClicked()
            print("biaser.biasingScore: ", biaser.biasingScore)
        } else {
            biaser.cSourceClicked()
            print("biaser.biasingScore: ", biaser.biasingScore)
        }
        
        performSegue(withIdentifier: "toArticleTableViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toArticleTableViewController") {
            
            let articleDisplayViewController = segue.destination as! ArticleTableViewController
            articleDisplayViewController.activeSource = activeSource
            articleDisplayViewController.sourcename = biaser.activeSources[activeSource]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
