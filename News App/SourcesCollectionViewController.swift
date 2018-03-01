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
    var ref: DatabaseReference!// Firebase reference
    var sourcePos: Int = -1                 // Position of source clicked (0-11)
    var sourceTimestamp: String = ""        // Source Timestamp
    var sourceTimespent: Int = 0        // Source Timespent
    var timeSpentonMessage1: Int = 0
    var timeSpentonMessage2: Int = 0
    var timeSpentonMessage3: Int = 0
    var newDay: Bool = false
    var numDays: Int = 0
    weak var timer: Timer?
    var startTime: Double = 0.0
    var time: Double = 0.0
    var timerOn: Bool = false
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Default functions
    override func viewDidLoad() {

        ref = Database.database().reference()
        biaser.versionType = UserDefaults.standard.integer(forKey: "VersionNum")
        biaser.uniqueID = UserDefaults.standard.string(forKey: "UserID")!
        print(biaser.uniqueID)
        // Initalizing database columns' initial values
        UserDefaults.standard.set(-1, forKey: "DatabaseEntryNum")
        UserDefaults.standard.set(0, forKey: "NumArticleClicked")
        
        var dateToday = UserDefaults.standard.string(forKey: "currentDate")
        let currentDate = getCurrentDate()
        if (dateToday == nil) {
            dateToday = getCurrentDate()
            UserDefaults.standard.set(dateToday, forKey: "currentDate")
            newDay = true
        }
        
        else if (dateToday != currentDate) {
            newDay = true
            UserDefaults.standard.set(dateToday, forKey: "currentDate")
        }
        
        else {
            newDay = false
        }
        
        if (biaser.versionType == 1) { // Biasing without message
            if (newDay){
                biaser.implementBiasing()
                UserDefaults.standard.set(biaser.activeSources, forKey: "ActiveSources")
            }
            else{
                biaser.activeSources = UserDefaults.standard.array(forKey: "ActiveSources") as! [String]
            }
        }
        
        else if (biaser.versionType == 2) { // No bias
            if (newDay){
                biaser.noBiasing()
                UserDefaults.standard.set(biaser.activeSources, forKey: "ActiveSources")
            }
            else {
                biaser.activeSources = UserDefaults.standard.array(forKey: "ActiveSources") as! [String]
            }
            
        }
        
        else if (biaser.versionType == 3) { // Bias with message
            if (newDay){
                biaser.implementBiasing()
                let daynumber = UserDefaults.standard.integer(forKey: "DayNumber")
                numDays = daynumber + 1
                UserDefaults.standard.set(numDays, forKey: "DayNumber")
                UserDefaults.standard.set(biaser.activeSources, forKey: "ActiveSources")
                print (numDays)
                if (numDays == 1) {
                    
                    startTime = Date().timeIntervalSinceReferenceDate
                    
                    timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounterforMessage1), userInfo: nil, repeats: true)
                    showMessage1(title: "Intervention!", message: "Most news aggregator algorithms, like the kind used in this app, track your behavior. They then use this information to guide you toward news articles that reflect your own ideological preferences. \n Why is this a problem?")
                }
            }
            else{
                biaser.activeSources = UserDefaults.standard.array(forKey: "ActiveSources") as! [String]
            }
            
        }
        super.viewDidLoad()
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
        return String(formatter.string(from: date as Date).prefix(10))
    }
    
    func getDate() -> String {
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
        
//        // Calculate minutes
//        let minutes = UInt8(time / 60.0)
//        time -= (TimeInterval(minutes) * 60)
//
//        // Calculate seconds
//        let seconds = UInt8(time)
//        time -= TimeInterval(seconds)
//
//        // Calculate milliseconds
//        let milliseconds = UInt8(time * 100)
//
//        // Format time vars with leading zero
//        let strMinutes = String(format: "%02d", minutes)
//        let strSeconds = String(format: "%02d", seconds)
//        let strMilliseconds = String(format: "%02d", milliseconds)
        
        sourceTimespent = Int(time)
        time = time*1000
        timerOn = true
    }
    
    @objc func updateCounterforMessage1() {
        time = Date().timeIntervalSinceReferenceDate - startTime
        time = time*1000
        timeSpentonMessage1 = Int(time)
    }
    @objc func updateCounterforMessage2() {
        time = Date().timeIntervalSinceReferenceDate - startTime
        time = time*1000
        timeSpentonMessage2 = Int(time)
    }
    
    @objc func updateCounterforMessage3() {
        time = Date().timeIntervalSinceReferenceDate - startTime
        time = time*1000
        timeSpentonMessage3 = Int(time)
    }
    
    func createAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessage1(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Next", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            self.timer?.invalidate()
            self.ref?.child(biaser.uniqueID).child("Intervention").child("TimeSpent on Message 1").setValue(self.timeSpentonMessage1)
            
            self.startTime = Date().timeIntervalSinceReferenceDate
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCounterforMessage2), userInfo: nil, repeats: true)
            
            self.showMessage2(title: "Intervention!", message: "Tailored offers prevent you from being exposed to other ideas and viewpoints which you might disagree with. Researchers say that this forces you into an echo chamber packed only with news articles you agree with and thus eliminating news articles you might disagree with. As a result, you are at the risk of eventually becoming a victim to your own biases. \n What can you do?")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessage2(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.timer?.invalidate()
            self.ref?.child(biaser.uniqueID).child("Intervention").child("TimeSpent on Message 2").setValue(self.timeSpentonMessage2)
            
            self.startTime = Date().timeIntervalSinceReferenceDate
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCounterforMessage1), userInfo: nil, repeats: true)
            
            self.showMessage1(title: "Intervention!", message: "Most news aggregator algorithms, like the kind used in this app, track your behavior. They then use this information to guide you toward news articles that reflect your own ideological preferences. Why is this a problem?")
        }))
        
        alert.addAction(UIAlertAction(title: "Next", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            self.timer?.invalidate()
            self.ref?.child(biaser.uniqueID).child("Intervention").child("TimeSpent on Message 2").setValue(self.timeSpentonMessage2)
            
            self.startTime = Date().timeIntervalSinceReferenceDate
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCounterforMessage3), userInfo: nil, repeats: true)
            self.showMessage3(title: "Intervention!", message: "At this point you have a choice: \n Please press “Reset” to break the echo chamber effect and receive news from an equal number of pro-Democratic and pro-Republican sources. \n OR \n Please press “Continue” to continue with the suggestions tailored to your prior choices.")
        }))
        

        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMessage3(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Back", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            self.timer?.invalidate()
            self.ref?.child(biaser.uniqueID).child("Intervention").child("TimeSpent on Message 3").setValue(self.timeSpentonMessage3)
            
            self.startTime = Date().timeIntervalSinceReferenceDate
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCounterforMessage2), userInfo: nil, repeats: true)
            self.showMessage2(title: "Intervention!", message: "Tailored offers prevent you from being exposed to other ideas and viewpoints which you might disagree with. Researchers say that this forces you into an echo chamber packed only with news articles you agree with and thus eliminating news articles you might disagree with. As a result, you are at the risk of eventually becoming a victim to your own biases. What can you do?")
        }))
        
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            print("Continue")
            self.ref?.child(biaser.uniqueID).child("Intervention").child("Choice").setValue("Continue")
            let date = self.getDate()
            self.ref?.child(biaser.uniqueID).child("Intervention").child("Date").setValue(date)
            self.timer?.invalidate()
            self.ref?.child(biaser.uniqueID).child("Intervention").child("TimeSpent on Message 3").setValue(self.timeSpentonMessage3)
        }))
        
        alert.addAction(UIAlertAction(title: "Reset", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            self.ref?.child(biaser.uniqueID).child("Intervention").child("Choice").setValue("Reset")
            let date = self.getDate()
            self.ref?.child(biaser.uniqueID).child("Intervention").child("Date").setValue(date)
            self.timer?.invalidate()
            self.ref?.child(biaser.uniqueID).child("Intervention").child("TimeSpent on Message 3").setValue(self.timeSpentonMessage3)
            biaser.versionType = 2
            UserDefaults.standard.set(biaser.versionType, forKey: "VersionNum")
        }))
        

        

        
        self.present(alert, animated: true, completion: nil)
    }
    
}
