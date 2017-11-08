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

    
    // Global Variables
    var articles: [ArticleObject]? = []
    var activeRow = 0
    var activeSource = 0
    var sourcename = ""
    
    
    // Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        activeRow = indexPath.row
        performSegue(withIdentifier: "toStoryDisplayViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toStoryDisplayViewController") {
        
            let storyDisplayViewController = segue.destination as! StoryDisplayViewController
            
            storyDisplayViewController.activeRow = activeRow
            storyDisplayViewController.articles = articles
        }
    }
    
    
    // Custom functions
    func fetchArticles() {
        print("Source is - ", sourcename)
        articles = [ArticleObject]()
        var urlRequest = URLRequest(url: URL(string: "https://api.newsapi.aylien.com/api/v1/stories?categories.taxonomy=iptc-subjectcode&categories.confident=true&categories.id%5B%5D=11000000&media.images.count.min=1&media.videos.count.max=0&source.name%5B%5D=" + sourcename.replacingOccurrences(of: " ", with: "%20") + "&cluster=false&cluster.algorithm=lingo&sort_by=recency&sort_direction=desc&cursor=*&per_page=5")!)

        let headerFields = ["X-AYLIEN-NewsAPI-Application-ID" : " abc52218", "X-AYLIEN-NewsAPI-Application-Key" : " 0a3f0e6a0ff13608b56a5a841698c24a"] as Dictionary<String, String>
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
                        if article.wordcount! > 100 && (self.articles?.count)! < 5 {
                            self.articles?.append(article)
                        }
                        else {print("dank memes")}
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
