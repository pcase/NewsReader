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

class NewsReaderTableViewController: UITableViewController {
    
    var newsDataList: [NewsData] = []
    private let newsReaderModelController: NewsReaderModelController
        
    required init?(coder aDecoder: NSCoder) {
        self.newsReaderModelController = NewsReaderModelController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set cell content insets
        tableView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        // Enable self-sizing cells
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // Call newsReaderModelController to get the news headlines
        newsReaderModelController.downloadNews(apiUrl: Constants.Urls.CNN_API_URL) { (response) in
            if let responseArray = response as? [NewsData] {
                for news in responseArray {
                    self.newsDataList.append(news)
                }
            }
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

        newsReaderModelController.downloadNews(apiUrl: Constants.Urls.CNN_API_URL) { (response) in
            if let responseArray = response as? [NewsData] {
                for news in responseArray {
                    self.newsDataList.append(news)
                }
            }
        }
        
        newsReaderModelController.downloadImage(imageUrl: news.image_url) { (response) in
            if let image = response as? UIImage {
                cell.imageView?.image = image
            }
        }

        return cell
    }
}
