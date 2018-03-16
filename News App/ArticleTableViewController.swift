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
    var sourceEntryNum: Int = 0
    var articleEntryNum: Int = 0
    var articles: [ArticleObject]? = []     // Object holding Articles
    var ref: DatabaseReference!             // Firebase reference
    var sourceOnlyTimerOn = false
    var sourceName: String = ""             // Source Name
    var sourcePos: Int = -1                 // Position of source clicked (0-11)
    var sourceTimestamp: String = ""        //  Source Timestamp
    
    var articleName: String = ""            // Article Name
    var articlePos: Int = -1                // Position of article clicked (0-...)
    var articleTimestamp: String = ""       // Article Timestamp
    var articleTimespent: Int = 0        // Article Timespent
    var sourceTimespent: Int = 0        // Source Timespent
    
    weak var timer: Timer?
    var startTime: Double = 0.0
    var time: Double = 0.0
    var articleTimerOn: Bool = false
    var sourceTimerOn:Bool = false
    
    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startTime = Date().timeIntervalSinceReferenceDate
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCounterSourcetimespent), userInfo: nil, repeats: true)
        sourceTimerOn = true
        fetchArticles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Since we don't know what the "Source Timespent" is (since the user could potentially look at another article of the same source)
        // we don't need to worry about it and therefore the code is short here. We only need to add "Article Timespent" to database.
        // Add Source Timespent to Database
        if (self.articleTimerOn) {
            self.timer?.invalidate()
            self.articleTimerOn = false
            self.ref?.child(biaser.uniqueID).child(String(self.sourceEntryNum)).child("Article Timespent").setValue(self.articleTimespent)
        }
        
        // Start timer
        self.startTime = Date().timeIntervalSinceReferenceDate
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCounterSourcetimespent), userInfo: nil, repeats: true)
        sourceTimerOn = true
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
        
            self.sourceOnlyTimerOn = false
            self.articlePos = indexPath.row
            self.articleTimestamp = self.getCurrentDate()
            // Increment number of article's clicked within a source
            let temp = UserDefaults.standard.integer(forKey: "NumArticleClicked")
            UserDefaults.standard.set(temp + 1, forKey: "NumArticleClicked")
            
            // Change BiasingScore only for Version1
            if (UserDefaults.standard.integer(forKey: "VersionNum") == 1) {
                if (biaser.categorizer[biaser.activeSources[self.sourcePos]] == "L") {
                    biaser.lArticleClicked()
                    UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
                } else {
                    biaser.cArticleClicked()
                    UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
                }
            }
        
            if (UserDefaults.standard.integer(forKey: "VersionNum") == 3) {
                if (biaser.categorizer[biaser.activeSources[self.sourcePos]] == "L") {
                    biaser.lArticleClicked()
                    UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
                } else {
                    biaser.cArticleClicked()
                    UserDefaults.standard.set(biaser.biasingScore, forKey: "BiasingScore")
                }
            }
            
            // Push source/article name, position, timestamp and timespent to database
            self.ref?.child(biaser.uniqueID).child(String(self.sourceEntryNum)).child("Source Name").setValue(biaser.activeSources[self.sourcePos])
            self.ref?.child(biaser.uniqueID).child(String(self.sourceEntryNum)).child("Source Position").setValue(self.sourcePos)
            self.ref?.child(biaser.uniqueID).child(String(self.sourceEntryNum)).child("Source Timestamp").setValue(self.sourceTimestamp)
            self.ref?.child(biaser.uniqueID).child(String(self.sourceEntryNum)).child("Article Headline").setValue(self.articles?[self.articlePos].title)
            self.ref?.child(biaser.uniqueID).child(String(self.sourceEntryNum)).child("Article Position").setValue(self.articlePos)
            self.ref?.child(biaser.uniqueID).child(String(self.sourceEntryNum)).child("Article Timestamp").setValue(self.articleTimestamp)
            self.ref?.child(biaser.uniqueID).child(String(self.sourceEntryNum)).child("User Bias").setValue(biaser.biasingScore)
            if (self.sourceTimerOn) {
                self.timer?.invalidate()
                self.sourceTimerOn = false
                print (self.sourceEntryNum)
                self.ref?.child(biaser.uniqueID).child(String(self.sourceEntryNum)).child("Source Timespent").setValue(self.sourceTimespent)
            }
            self.startTime = Date().timeIntervalSinceReferenceDate
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            articleTimerOn = true
            self.performSegue(withIdentifier: "toStoryDisplayViewController", sender: nil)
     
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toStoryDisplayViewController") {
            let storyDisplayViewController = segue.destination as! StoryDisplayViewController
            storyDisplayViewController.articlePos = articlePos
            storyDisplayViewController.articles = articles
        }
        
        else if (segue.identifier == "backToSourceViewController") {
            let sourcesCollectionViewController = segue.destination as! SourcesCollectionViewController
            sourcesCollectionViewController.sourceOnlytimerOn = sourceOnlyTimerOn
        }
    }
    
    
    
    // Custom functions
    func fetchArticles() {
        
        articles = [ArticleObject]()
        
        var urlRequest = URLRequest(url: URL(string: "https://api.newsapi.aylien.com/api/v1/stories?categories.taxonomy=iptc-subjectcode&categories.confident=true&categories.id%5B%5D=11000000&media.images.count.min=1&media.videos.count.max=0&source.name%5B%5D=" + sourceName.replacingOccurrences(of: " ", with: "%20") + "&cluster=false&cluster.algorithm=lingo&sort_by=recency&sort_direction=desc&cursor=*&per_page=25")!)
        

        let headerFields = ["X-AYLIEN-NewsAPI-Application-ID" : "65d8679d", "X-AYLIEN-NewsAPI-Application-Key" : "5e2739af5aa4d8d25e3b16ad75092fe8"] as Dictionary<String, String>
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
                                if url.count > 0 {
                                    article.imageUrl = url
                                }
                            } else {
                                print("Error")
                            }
                        } else {
                            print("Error")
                        }
                        
                        if (article.wordcount! > 100 && (self.articles?.count)! < 6) {
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
        time = time*1000
        articleTimespent = Int(time)
        articleTimerOn = true
    }
    
    @objc func updateCounterSourcetimespent() {
        time = Date().timeIntervalSinceReferenceDate - startTime
        time = time*1000
        sourceTimespent = Int(time)
        articleTimerOn = true
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
