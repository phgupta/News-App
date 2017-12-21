//
//  SourcesCollectionViewController.swift
//  News App
//
//  Created by Saksham Bhalla on 10/11/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit
import Firebase

// Global Variables
let biaser = BiasingMetaData()

class SourcesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Variables
    var ref: DatabaseReference!             // Firebase reference
    var entryNum: Int = -1                  // Database entry number
    var sourcePos: Int = -1                 // Position of source clicked (0-11)
    var sourceTimestamp: String = ""        // CHECK: Change Source Timestamp's default value
    var sourceTimespent: String = "00:02"   // CHECK: Change Source Timespent's default value
    
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        biaser.uniqueID = String(describing: UserDefaults.standard.string(forKey: "UserID")!)
        
        // Sets score to 50 and shuffles the sources list.
        biaser.implementBiasing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // CHECK: If version1,2,3() don't have a lot of code, remove them then.
        let versionNum = UserDefaults.standard.integer(forKey: "VersionNum")
        switch versionNum {
        case 1:
            version1()
        case 2:
            version2()
        case 3:
            version3()
        default:
            print("Error: Version Number not stored in UserDefaults.")
            break
        }
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
        
        sourcePos = indexPath.row
        sourceTimestamp = getCurrentDate()
        
        if (biaser.categorizer[biaser.activeSources[indexPath.row]] == "L") {
            biaser.lSourceClicked()
            UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
            print("Biasing Score: ", biaser.biasingScore)
        } else {
            biaser.cSourceClicked()
            UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
            print("Biasing Score: ", biaser.biasingScore)
        }
        
        // Push source name, position, timestamp and timespent to database
        self.ref?.child(biaser.uniqueID).child(String(entryNum)).child("Source Name").setValue(biaser.activeSources[sourcePos])
        self.ref?.child(biaser.uniqueID).child(String(entryNum)).child("Source Position").setValue(sourcePos)
        self.ref?.child(biaser.uniqueID).child(String(entryNum)).child("Source Timestamp").setValue(sourceTimestamp)
        self.ref?.child(biaser.uniqueID).child(String(entryNum)).child("Source Timespent").setValue(sourceTimespent)
        
        performSegue(withIdentifier: "toArticleTableViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toArticleTableViewController") {
            let articleDisplayViewController = segue.destination as! ArticleTableViewController
            
            // Pass variables through segue
            articleDisplayViewController.ref = ref                                      // Firebase reference
            articleDisplayViewController.entryNum = entryNum                            // User Entry Number
            articleDisplayViewController.sourceName = biaser.activeSources[sourcePos]   // Source Name
            articleDisplayViewController.sourcePos = sourcePos                          // Source Position
            articleDisplayViewController.sourceTimestamp = sourceTimestamp              // Source Timestamp
            articleDisplayViewController.sourceTimespent = sourceTimespent              // Source Timspent
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Custom functions
    func version1() {
        print("SourcesVC func version1()")
        entryNum += 1
    }
    
    func version2() {
        print("SourcesVC func version2()")
        entryNum += 1
    }
    
    func version3() {
        print("SourcesVC func version3()")
        entryNum += 1
    }
    
    // CHECK: Below function is incorrect.
    func getCurrentDate() -> String {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.timeZone = NSTimeZone(abbreviation: "PST")! as TimeZone
        return formatter.string(from: date as Date)
    }
}
