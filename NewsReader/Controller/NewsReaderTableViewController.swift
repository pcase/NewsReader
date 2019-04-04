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

import Kingfisher

class NewsReaderTableViewController: UITableViewController {

    var titles: [String] = []
    var newsDataList: [NewsData] = []
    var apiKey = "2624297672fe4e60b7d9316027ccec42"
    let API_URL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=2624297672fe4e60b7d9316027ccec42"
    typealias DownloadComplete = () -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
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
        
        // Create a correctly-sized subview, download and set the image, and add
        // the subview to the cell
//        let cellImage = UIImageView()
//        cellImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        cellImage.contentMode = UIView.ContentMode.scaleAspectFill
//        cellImage.clipsToBounds = true
//        
//        Alamofire.request(URL(string: news.image_url) ?? "").responseImage { response in
//
//            if let image = response.result.value {
//                cellImage.image = image
//            }
//        }
//        cell.addSubview(cellImage)
//
//        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier", for: indexPath) as! TableViewCell
    }

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        // Calculate the height of label cells automatically in each section
//        if indexPath.row == 0 || indexPath.row == 1 {
//            return UITableView.automaticDimension
//        }
//
//        // Calculate the height of image for indexPath
//        else if indexPath.row == 2, let image = newsDataList[indexPath.section].image {
//
//            let imageWidth = image.size.width
//            let imageHeight = image.size.height
//
//            guard imageWidth > 0 && imageHeight > 0 else { return UITableView.automaticDimension }
//
//            // Images always be the full width of the screen
//            let requiredWidth = tableView.frame.width
//            let widthRatio = requiredWidth / imageWidth
//            let requiredHeight = imageHeight * widthRatio
//
//            return requiredHeight
//        }
//        else {
//            return UITableView.automaticDimension
//        }
//    }
    
    // MARK: Network functions
    
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
