//
//  SourcesCollectionViewController.swift
//  News App
//
//  Created by Saksham Bhalla on 10/11/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit
import Firebase
import CoreData

// Global Variables
let biaser = BiasingMetaData()
var uniqueID: String = ""
var sourceNum: Int = 0
var articleNum: Int = 0


class SourcesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Global Variables
    var activeSource = 0
    var ref: DatabaseReference!
    

    // Default functions
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        
        ref = Database.database().reference()
        
        // Implement biasing everytime SourcesVC is loaded.
        biaser.implementBiasing()
        
        // Create uniqueID only once
        if (uniqueID.isEmpty) {
            let reference = ref?.childByAutoId()
            uniqueID = (reference?.key)!
            newUser.setValue(uniqueID, forKey: "Username")
            newUser.setValue(biaser.biasingScore, forKey: "biasingscore")
            do {
                
                try context.save()
                print("Saved")
                
            } catch {
                print("Error!")
            }
    }
}
    override func viewDidAppear(_ animated: Bool) {
        // Implement biasing everytime SourcesVC is loaded.
        biaser.implementBiasing()
        sourceNum += 1
        articleNum = 0
        self.collectionView!.reloadData()
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
            print("biaser.biasingScore: ", biaser.biasingScore)
        } else {
            biaser.cSourceClicked()
            print("biaser.biasingScore: ", biaser.biasingScore)
        }
        
        // Push source name, timestamp and position to database
        self.ref?.child(uniqueID).child("Source" + String(sourceNum)).child("Timestamp").setValue(pstTime)
        self.ref?.child(uniqueID).child("Source" + String(sourceNum)).child("Name").setValue(biaser.activeSources[activeSource])
        self.ref?.child(uniqueID).child("Source" + String(sourceNum)).child("Position").setValue(activeSource)
        
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
