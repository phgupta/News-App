//
//  ArticleTableViewController.swift
//  News App
//
//  Created by Pranav Gupta on 9/16/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

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
        print("PRINT ARTICLE COUNT: ", self.articles?.count ?? "Table article count is 0")
        return self.articles?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleTableViewCell
        cell.titleLabel.text = self.articles?[indexPath.item].title
        cell.authorLabel.text = self.articles?[indexPath.item].author
        //cell.img.downloadImage(from: (self.articles?[indexPath.item].imageUrl!)!)

        return cell
    }

    
    
    // Custom functions
    func fetchArticles() {
        
        // Articles array
        self.articles = [ArticleObject]()
        
        //let parameters = ["categories.confident": "true", "source.name" : "The New York Times", "cluster" : "false", "cluster.algorithm" : "lingo", "sort_by" : "published_at", "sort_direction" : "desc", "cursor" : "*", "per_page" : "2"] as Dictionary<String, String>
        
        var urlRequest = URLRequest(url: URL(string: "https://api.newsapi.aylien.com/api/v1/stories?language%5B%5D=en&categories.confident=true&media.images.format%5B%5D=JPEG&source.name%5B%5D=The%20New%20York%20Times&cluster=false&cluster.algorithm=lingo&sort_by=published_at&sort_direction=desc&cursor=*&per_page=10")!)
        
        let headerFields = ["X-AYLIEN-NewsAPI-Application-ID" : "15c136e0", "X-AYLIEN-NewsAPI-Application-Key" : "15c7da7bb8d73f21f0af9bf5ef6d2539"] as Dictionary<String, String>
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
                        article.imageUrl = articleFromJSON["media"]?["url"] as? String
                        article.body = articleFromJSON["body"] as? String
                        
                        self.articles?.append(article)
                        print("ARTICLES APPEND: ", self.articles?.count ?? "Append articles count is 0")
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
