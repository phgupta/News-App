//
//  SourcesCollectionViewController.swift
//  News App
//
//  Created by Saksham Bhalla on 10/11/17.
//  Copyright © 2017 Pranav Gupta. All rights reserved.
//

import UIKit

class SourcesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var activeSource = 0
    
    var images = ["breitbart", "foxnews", "drudgereport", "dailycaller", "washingtontimes", "townhall", "thehill", "newyorkpost", "wnd", "zerohedge", "theblaze", "nationalreview", "cnsnews", "msnbc", "thenewyorker", "cnn", "huffingtonpost", "politico", "nytimes", "washingtonpost", "nbcnews", "dailykos", "vox", "thenation", "slate", "salon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SourcesCell", for: indexPath) as! SourcesCell
        
        cell.myImage.image = UIImage(named: images[indexPath.row])
         
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeSource = indexPath.row
        performSegue(withIdentifier: "toArticleTableViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toArticleTableViewController" {
            
            let articleDisplayViewController = segue.destination as! ArticleTableViewController
            
            articleDisplayViewController.activeSource = activeSource
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
