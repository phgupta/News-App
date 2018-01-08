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
    var sourcePos: Int = -1                 // Position of source clicked (0-11)
    var sourceTimestamp: String = ""        // Source Timestamp
    var sourceTimespent: String = ""        // Source Timespent
    weak var timer: Timer?
    var startTime: Double = 0.0
    var time: Double = 0.0
    var timerOn: Bool = false
    
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        biaser.uniqueID = String(describing: UserDefaults.standard.string(forKey: "UserID")!)
        
        // Initalizing database columns' initial values
        UserDefaults.standard.set(-1, forKey: "DatabaseEntryNum")
        UserDefaults.standard.set(0, forKey: "NumArticleClicked")
        
        // Sets score to 50 and shuffles the sources list.
        biaser.implementBiasing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // This handles the case when the user clicks on a source and then returns back to the SourceVC screen
        // timerOn is initially set to false. Once user clicks on a source, it's set to True and over here it checks whether
        // timerOn is true or not.
        // Add Source Timespent to database if source has been clicked
        if (timerOn) {
            
            // Stop the timer and make timerOn to false.
            timer?.invalidate()
            timerOn = false
            
            let entryNum = UserDefaults.standard.integer(forKey: "DatabaseEntryNum")
            let numArticleClicked = UserDefaults.standard.integer(forKey: "NumArticleClicked")
            
            // This complicated stuff is happening because we need to put "Source Timespent" under Articles also.
            // We can't enter this to database when we're entering the article info because at that point we don't know how much
            // time the user is spending in that SOURCE. Therefore, we need to wait until the user comes back to the source screen and then
            // put the "Source Timespent" columns in all the articles the user has clicked on under that particular source.
            // Adds Source Timespent to all appropriate rows.
            if (numArticleClicked > -1) {
                for i in 0...numArticleClicked {
                    self.ref?.child(biaser.uniqueID).child(String(entryNum - i)).child("Source Timespent").setValue(sourceTimespent)
                }
                
                UserDefaults.standard.set(0, forKey: "NumArticleClicked")
            }
        }
        
        // This is basically like the index. It gets incremented for every new source/article clicked.
        // Increment DatabaseEntryNum
        let entryNum = UserDefaults.standard.integer(forKey: "DatabaseEntryNum")
        UserDefaults.standard.set(entryNum + 1, forKey: "DatabaseEntryNum")
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
        
        // Start timer
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        sourcePos = indexPath.row
        sourceTimestamp = getCurrentDate()
        let entryNum = UserDefaults.standard.integer(forKey: "DatabaseEntryNum")
        
        // Change BiasingScore only for Version1
        if (UserDefaults.standard.integer(forKey: "VersionNum") == 1) {
            if (biaser.categorizer[biaser.activeSources[indexPath.row]] == "L") {
                biaser.lSourceClicked()
                UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
            } else {
                biaser.cSourceClicked()
                UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
            }
        }
        
        // Push source name, position, timestamp and timespent to database
        self.ref?.child(biaser.uniqueID).child(String(entryNum)).child("Source Name").setValue(biaser.activeSources[sourcePos])
        self.ref?.child(biaser.uniqueID).child(String(entryNum)).child("Source Position").setValue(sourcePos)
        self.ref?.child(biaser.uniqueID).child(String(entryNum)).child("Source Timestamp").setValue(sourceTimestamp)
        
        performSegue(withIdentifier: "toArticleTableViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toArticleTableViewController") {
            let articleDisplayViewController = segue.destination as! ArticleTableViewController
            
            // Pass variables through segue
            articleDisplayViewController.ref = ref                                      // Firebase reference
            articleDisplayViewController.sourceName = biaser.activeSources[sourcePos]   // Source Name
            articleDisplayViewController.sourcePos = sourcePos                          // Source Position
            articleDisplayViewController.sourceTimestamp = sourceTimestamp              // Source Timestamp
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Custom functions
    // CHECK: Below function is incorrect.
    func getCurrentDate() -> String {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.timeZone = NSTimeZone(abbreviation: "PST")! as TimeZone
        return formatter.string(from: date as Date)
    }
    
    // I really don't think you need to worry much about this function. It basically calculates the min, sec, and ms.
    // You'll have to read up on Timer.scheduledTimer(...) documentation to understand it thoroughly.
    // But what I understood is that you need to provide a custom function as argument which gets called every timeInterval (which is 0.01 in this case. Check the line of code where I call timer.scheduleTimer)
    // So every 0.01 seconds the minutes, seconds and milliseconds are calculated and stored in sourceTimespent variable.
    // Also, I'm setting the timerOn variable to true!! (Important because this variable is used in other screens too)
    @objc func updateCounter() {
        time = Date().timeIntervalSinceReferenceDate - startTime
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        let milliseconds = UInt8(time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        sourceTimespent = strMinutes + ":" + strSeconds + ":" + strMilliseconds
        timerOn = true
    }
}
