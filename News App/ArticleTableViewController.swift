//
//  ArticleTableViewController.swift
//  News App
//
//  Created by Pranav Gupta on 9/16/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class ArticleTableViewController: UITableViewController {
    
    // Outlets
    @IBOutlet var articleTableView: UITableView!

    
    // Variables
    var articles: [ArticleObject]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetches Articles from AylienAPI
        fetchArticles()
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
        return self.articles?.count ?? 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Structures
    struct Story : JSONJoy {
        let id: Int
        let title: String
        let body: String
        
        init(_ decoder: JSONDecoder) throws {
            id = try decoder["id"].get()
            title = try decoder["title"].get()
            body = try decoder["body"].get()
//            summary = try decoder["summary"].get()
        }
    }
    
    struct Response : JSONJoy {
        let stories: [Story]
        
        init(_ decoder: JSONDecoder) throws {
            stories = try decoder["stories"].get()
        }
    }

    // Custom functions
    func fetchArticles() {
        
        do {
            let opt = try HTTP.New("https://api.newsapi.aylien.com/api/v1/stories", method: .GET, parameters: ["categories.confident": "true", "source.name" : "The New York Times", "cluster" : "false", "cluster.algorithm" : "lingo", "sort_by" : "published_at", "sort_direction" : "desc", "cursor" : "*", "per_page" : "2"], headers: ["X-AYLIEN-NewsAPI-Application-ID" : "37b22eeb", "X-AYLIEN-NewsAPI-Application-Key" : "8a33b02853b51bbac1a9500856f0c21b"], requestSerializer: JSONParameterSerializer())
            
            opt.start { response in
                do {
                    //let responseData = String(data: response.data, encoding: String.Encoding.utf8)
                    var response = try Response(JSONDecoder(response.data))
                    print(response.stories[0].title)
                } catch let error {
                    print(error)
                }
            }
            
        } catch let error {
            print("got an error creating the request: \(error)")
        }
        }

}
//        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            
//            if (error != nil) {
//                print (error!)
//            }
//            
//            print ("RESPONSE: ")
//            print (response ?? "NO RESPONSE :((")
        
            // Initializing articles array
            //self.articles = [ArticleObject]()
            
            /*
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                
                
                if let articlesFromJSON = json["articles"] as? [[String: AnyObject]] {
                    
                    for articleFromJSON in articlesFromJSON {
                        
                        // Creating an instance of ArticleObject
                        let article = ArticleObject()
                        
                        if let title = articleFromJSON["title"] as? String, let author = articleFromJSON["author"] as? String, let url = articleFromJSON["url"] as? String, let imageToURL = articleFromJSON["urlToImage"] as? String {
                            article.author = author
                            article.headline = title
                            article.url = url
                            article.imageUrl = imageToURL
                            article.liberalConservative = "Liberal"
                        }
                        
                        self.articles?.append(article)
                    }
                }
                
            } catch let error {
                print (error)
            }
             */
//        }
//        
////        task.resume()
////    }
////
////}
//

/*
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
 
 cell.titleLabel.text = self.biasedArticles?[indexPath.item].headline
 cell.authorLabel.text = self.biasedArticles?[indexPath.item].author
 cell.imgView.downloadImage(from: (self.biasedArticles?[indexPath.item].imageUrl!)!)
 
 if (self.biasedArticles?[indexPath.item].liberalConservative == "Liberal") {
 cell.backgroundColor = UIColor.blue
 }
 
 else {
 cell.backgroundColor = UIColor.red
 }
 
 return cell
 }
 
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
 if let destination = segue.destination as? WebViewViewController {
 let selectedRow = tableView.indexPathForSelectedRow!.row
 destination.url = biasedArticles?[selectedRow].url
 }
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
 implementBiasing(index: indexPath.row)
 tableView.deselectRow(at: indexPath, animated: true)
 }
 
 func fetchArticles() {
 
 let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
 
 if (error != nil) {
 print (error!)
 }
 
 // Initializing articles array
 self.articles = [ArticleObject]()
 
 do {
 let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
 
 if let articlesFromJSON = json["articles"] as? [[String: AnyObject]] {
 
 for articleFromJSON in articlesFromJSON {
 
 // Creating an instance of ArticleObject
 let article = ArticleObject()
 
 if let title = articleFromJSON["title"] as? String, let author = articleFromJSON["author"] as? String, let url = articleFromJSON["url"] as? String, let imageToURL = articleFromJSON["urlToImage"] as? String {
 article.author = author
 article.headline = title
 article.url = url
 article.imageUrl = imageToURL
 article.liberalConservative = "Liberal"
 }
 
 self.articles?.append(article)
 }
 }
 
 DispatchQueue.main.async {
 self.htmlParsing()
 }
 
 } catch let error {
 print (error)
 }
 }
 task.resume()
 }
 
 
 func htmlParsing() {
 
 let url = URL(string: "http://conservativetribune.com/category/political-news/")
 let task = URLSession.shared.dataTask(with: url!) { data, response, error in
 
 if (error != nil) {
 print (error!)
 }
 
 else {
 
 // Initializing articles array
 //self.articles = [ArticleObject]()
 
 let htmlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
 
 do {
 
 /* Headline */
 let html: String = htmlContent! as String
 let doc: Document = try! SwiftSoup.parse(html)
 let articles: Elements = try! doc.select("div.archive-latest").select("article")
 
 for element: Element in articles.array() {
 
 // Creating an instance of ArticleObject
 let article = ArticleObject()
 
 article.author = try! element.select("span.entry-author").text()
 article.headline = try! element.select("h3").text()
 article.url = try! element.select("a").get(1).attr("href")
 article.imageUrl = try! element.select("p.entry-image").select("a").select("img").attr("src")
 article.liberalConservative = "Conservative"
 
 // Populating the articles object
 self.articles?.append(article)
 }
 
 DispatchQueue.main.async {
 self.liberalArticlesCount = 5
 self.populateBiasedArticles(count: self.liberalArticlesCount)
 self.tableView.reloadData()
 }
 
 } catch Exception.Error(_, let message) {
 print(message)
 }
 }
 }
 
 task.resume()
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

 
 */


