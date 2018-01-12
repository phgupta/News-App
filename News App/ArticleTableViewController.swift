//
//  ArticleTableViewController.swift
//  News App
//
//  Created by Pranav Gupta on 9/16/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit
import Firebase

class ArticleTableViewController: UITableViewController {
    
    // Outlets
    @IBOutlet var articleTableView: UITableView!

    
    // Variables
    var articles: [ArticleObject]? = []     // Object holding Articles
    var ref: DatabaseReference!             // Firebase reference
    
    var sourceName: String = ""             // Source Name
    var sourcePos: Int = -1                 // Position of source clicked (0-11)
    var sourceTimestamp: String = ""        //  Source Timestamp
    
    var articleName: String = ""            // Article Name
    var articlePos: Int = -1                // Position of article clicked (0-...)
    var articleTimestamp: String = ""       // Article Timestamp
    var articleTimespent:String = ""        // Article Timespent
    
    weak var timer: Timer?
    var startTime: Double = 0.0
    var time: Double = 0.0
    var timerOn: Bool = false
    
    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Since we don't know what the "Source Timespent" is (since the user could potentially look at another article of the same source)
        // we don't need to worry about it and therefore the code is short here. We only need to add "Article Timespent" to database.
        // Add Source Timespent to Database
        if (timerOn) {
            timer?.invalidate()
            timerOn = false
            let entryNum = UserDefaults.standard.integer(forKey: "DatabaseEntryNum")
            self.ref?.child(biaser.uniqueID).child(String(entryNum)).child("Article Timespent").setValue(articleTimespent)
            timerOn = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        cell.titleLabel.text = articles?[indexPath.item].title
        cell.authorLabel.text = articles?[indexPath.item].author
        cell.img.downloadImage(from: (articles?[indexPath.item].imageUrl!)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Start timer
        startTime = Date().timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        articlePos = indexPath.row
        articleTimestamp = getCurrentDate()
        
        // Increment database entry number
        let entryNum = UserDefaults.standard.integer(forKey: "DatabaseEntryNum")
        UserDefaults.standard.set(entryNum + 1, forKey: "DatabaseEntryNum")
        
        // Increment number of article's clicked within a source
        let temp = UserDefaults.standard.integer(forKey: "NumArticleClicked")
        UserDefaults.standard.set(temp + 1, forKey: "NumArticleClicked")
        
        // Change BiasingScore only for Version1
        if (UserDefaults.standard.integer(forKey: "VersionNum") == 1) {
            if (biaser.categorizer[biaser.activeSources[sourcePos]] == "L") {
                biaser.lArticleClicked()
                UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
            } else {
                biaser.cArticleClicked()
                UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
            }
        }
        
        // Push source/article name, position, timestamp and timespent to database
        self.ref?.child(biaser.uniqueID).child(String(entryNum+1)).child("Source Name").setValue(biaser.activeSources[sourcePos])
        self.ref?.child(biaser.uniqueID).child(String(entryNum+1)).child("Source Position").setValue(sourcePos)
        self.ref?.child(biaser.uniqueID).child(String(entryNum+1)).child("Source Timestamp").setValue(sourceTimestamp)
        self.ref?.child(biaser.uniqueID).child(String(entryNum+1)).child("Article Name").setValue(articles?[articlePos].title)
        self.ref?.child(biaser.uniqueID).child(String(entryNum+1)).child("Article Position").setValue(articlePos)
        self.ref?.child(biaser.uniqueID).child(String(entryNum+1)).child("Article Timestamp").setValue(articleTimestamp)
        
        performSegue(withIdentifier: "toStoryDisplayViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toStoryDisplayViewController") {
            let storyDisplayViewController = segue.destination as! StoryDisplayViewController
            storyDisplayViewController.articlePos = articlePos
            storyDisplayViewController.articles = articles
        }
    }
    
    
    // Custom functions
    func fetchArticles() {
        
        articles = [ArticleObject]()
        
        var urlRequest = URLRequest(url: URL(string: "https://api.newsapi.aylien.com/api/v1/stories?categories.taxonomy=iptc-subjectcode&categories.confident=true&categories.id%5B%5D=11000000&media.images.count.min=1&media.videos.count.max=0&source.name%5B%5D=" + sourceName.replacingOccurrences(of: " ", with: "%20") + "&cluster=false&cluster.algorithm=lingo&sort_by=recency&sort_direction=desc&cursor=*&per_page=15")!)

        let headerFields = ["X-AYLIEN-NewsAPI-Application-ID" : " 8d5af121", "X-AYLIEN-NewsAPI-Application-Key" : "  afb268a5ee95bcbba0bfe29aadbc9726"] as Dictionary<String, String>
        urlRequest.allHTTPHeaderFields = headerFields

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

            if (error != nil) {
                print(error!)
            }

            do {

                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                if let articlesFromJSON = json["stories"] as? [[String: AnyObject]] {

                    for articleFromJSON in articlesFromJSON {

                        // Creating an instance of ArticleObject
                        let article = ArticleObject()

                        // Change below to if let article.author = xyz..., article.title = xyz...
                        article.author = articleFromJSON["author"]?["name"] as? String
                        article.title = articleFromJSON["title"] as? String
                        article.body = articleFromJSON["body"] as? String
                        article.wordcount = articleFromJSON["words_count"] as? Int
                        article.published_at = articleFromJSON["published_at"] as? String
                        let item = articleFromJSON["media"] as? NSArray
                        let firstElement = item?.object(at: 0)
                        
                        if let dict = (firstElement as? [String:Any]) {

                            if let url = dict["url"] as? String {
                                article.imageUrl = url
                            } else {
                                print("Error")
                            }
                        } else {
                            print("Error")
                        }
                        
                        if (article.wordcount! > 100 && (self.articles?.count)! < 5) {
                            self.articles?.append(article)
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            } catch let error {
                print (error)
            }
        }

        task.resume()
    }
    
    // CHECK: Below function is incorrect & copied from SourcesVC.
    func getCurrentDate() -> String {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.timeZone = NSTimeZone(abbreviation: "PST")! as TimeZone
        return formatter.string(from: date as Date)
    }
    
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
        
        articleTimespent = strMinutes + ":" + strSeconds + ":" + strMilliseconds
        timerOn = true
    }
}


// Protocol
extension UIImageView {
    
    func downloadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if (error != nil) {
                print (error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
        task.resume()
    }
}
