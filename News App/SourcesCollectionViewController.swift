//
//  SourcesCollectionViewController.swift
//  News App
//
//  Created by Saksham Bhalla on 10/11/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit
import Firebase
//import CoreData

// Global Variables
let biaser = BiasingMetaData()
//var biaser.uniqueID: String = ""
var num: Int = 0
var sourceNum: Int = 0
var articleNum: Int = 0
let uniqueID = UserDefaults.standard.object(forKey: "UID")
let scoreBiased = UserDefaults.standard.object(forKey: "SCORE")

class SourcesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Global Variables
    var activeSource = 0
    var ref: DatabaseReference!
    var name: String = ""
    var first: Bool = true

    // Default functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        ref = Database.database().reference()
//
//        // Implement biasing everytime SourcesVC is loaded.
          biaser.implementBiasing()
//
//       // let lastViewedDate = UserDefaults.standard.object(forKey: "DATE")
//
//        if let uid = uniqueID as? String {
//            print("VIEWDIDLOAD USER DEFAULT VALUE AlREADY SET. VALUE IS: ", uid)
//            let reference = ref?.childByAutoId()
//            biaser.uniqueID = (reference?.key)!
//        }
//
//        if let bScore = scoreBiased as? Int {
//
//            print("VIEWDIDLOAD BIASING SCORE FOR THIS USER IS: ", bScore)
//        }
//
////        if let dateLastOpened = lastViewedDate as? Date {
////            print("THIS USER OPENED THE APP ON: ", dateLastOpened)
////        }
//        else {
//            let reference = ref?.childByAutoId()
//            biaser.uniqueID = (reference?.key)!
//            UserDefaults.standard.set(biaser.uniqueID, forKey: "UID")
//            // UserDefaults.standard.set(Date(), forKey: "DATE")
//            print("VIEWDIDLOAD SETTING TO USER DEFAULT. VALUE IS: ", biaser.uniqueID)
//        }

}
    override func viewDidAppear(_ animated: Bool) {
        
        // Implement biasing everytime SourcesVC is loaded.
       // biaser.implementBiasing()
        sourceNum += 1
        articleNum = 0
        num += 1
        ref = Database.database().reference()
        
        // Implement biasing everytime SourcesVC is loaded.
       // biaser.implementBiasing()
        
        // let lastViewedDate = UserDefaults.standard.object(forKey: "DATE")
        
        if let uid = uniqueID as? String {
            print("VIEWDIDAPPEAR USER DEFAULT VALUE AlREADY SET. VALUE IS: ", uid)
            let reference = ref?.childByAutoId()
            biaser.uniqueID = (reference?.key)!
        }
        
        if let bScore = scoreBiased as? Int {
            print("VIEWDIDAPPEAR BIASING SCORE FOR THIS USER IS: ", biaser.biasingScore)
        }
            
            //        if let dateLastOpened = lastViewedDate as? Date {
            //            print("THIS USER OPENED THE APP ON: ", dateLastOpened)
            //        }
        else {
            let reference = ref?.childByAutoId()
            biaser.uniqueID = (reference?.key)!
            UserDefaults.standard.set(biaser.uniqueID, forKey: "UID")
            // UserDefaults.standard.set(Date(), forKey: "DATE")
            print("VIEWDIDAPPEAR SETTING TO USER DEFAULT. VALUE IS: ", biaser.uniqueID)
        }
        //self.collectionView!.reloadData()
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
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.timeZone = NSTimeZone(abbreviation: "PST")! as TimeZone
        let pstTime = formatter.string(from: date as Date)
        
        if (biaser.categorizer[biaser.activeSources[indexPath.row]] == "L") {
            biaser.lSourceClicked()
            UserDefaults.standard.set(biaser.biasingScore, forKey: "SCORE")
            print("biaser.biasingScore: ", biaser.biasingScore)
        } else {
            biaser.cSourceClicked()
            UserDefaults.standard.set(biaser.biasingScore, forKey: "SCORE")
            print("biaser.biasingScore: ", biaser.biasingScore)
        }
        
        // Push source name, timestamp and position to database
        self.ref?.child(biaser.uniqueID).child(String(num)).child("Source Name").setValue(biaser.activeSources[activeSource])
        self.ref?.child(biaser.uniqueID).child(String(num)).child("Source Position").setValue(activeSource)
        self.ref?.child(biaser.uniqueID).child(String(num)).child("Source Timestamp").setValue(pstTime)
        
        self.ref?.child(biaser.uniqueID).child(String(num)).child("Article Name").setValue("")
        self.ref?.child(biaser.uniqueID).child(String(num)).child("Time spent").setValue("00:00:02")
        
        performSegue(withIdentifier: "toArticleTableViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toArticleTableViewController") {
            
            let articleDisplayViewController = segue.destination as! ArticleTableViewController
            
            // Pass variables through segue
            articleDisplayViewController.activeSource = activeSource
            articleDisplayViewController.sourceNum = sourceNum
            articleDisplayViewController.articleNum = articleNum
            articleDisplayViewController.ref = ref
            articleDisplayViewController.sourcename = biaser.activeSources[activeSource]

            // ADD: Source timestamp
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
