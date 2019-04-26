//
//  NewsReaderTableViewController.swift
//  NewsReader
//
//  Created by Patty Case on 3/30/19.
//  Copyright © 2019 Azure Horse Creations. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import AlamofireImage

class NewsReaderTableViewController: UITableViewController {
    
    var newsDataList: [NewsData] = []
    var apiKey = "2624297672fe4e60b7d9316027ccec42"
    let API_URL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=2624297672fe4e60b7d9316027ccec42"
    typealias DownloadComplete = () -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set cell content insets
        tableView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        // Enable self-sizing cells
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Call downloadNews() to get the news headlines
        downloadNews {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
            updateUI()
    }
    
    /**
     Reloads the table view data
     
     - Parameter:
     - Throws:
     - Returns:
     */
    func updateUI() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsDataList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath) as! TableViewCell

        let news = newsDataList[indexPath.row]
        cell.title.text = news.title
        cell.summary.text = news.summary

        Alamofire.request(URL(string: news.image_url) ?? "").responseImage { response in

            if let image = response.result.value {
                cell.imageView?.image = image
            }
        }        
        return cell
    }
    
    // MARK: Network functions
    
    /**
     Uses Alamofire to make a network call to the CNN news API
     
     - Parameter completed: completion handler
     
     - Throws:
     
     - Returns:
     */
    func downloadNews(completed: @escaping DownloadComplete) {
        SVProgressHUD.show()
        Alamofire.request(API_URL).responseJSON{ (response) in
            let result = response.result
            let json = JSON(result.value ?? "")
        
            SVProgressHUD.dismiss()
            for index in 0..<json["articles"].count {
                let newsData = NewsData()
                newsData.title = json["articles"][index]["title"].stringValue
                newsData.summary = json["articles"][index]["description"].stringValue
                newsData.publish_date = json["articles"][index]["publishedAt"].stringValue
                newsData.image_url = json["articles"][index]["urlToImage"].stringValue
                self.newsDataList.append(newsData)
            }
            completed()
        }
    }
}
