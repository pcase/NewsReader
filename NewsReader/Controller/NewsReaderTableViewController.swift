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
    
    var _name = ""
    var _author = ""
    var _title = ""
    var _short = ""
    var _image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        
        downloadNews {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
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
        cell.title.text = news.title + " - " + news.publish_date
        cell.summary.text = news.summary
        
        let cellImage = UIImageView()
        cellImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        cellImage.contentMode = UIView.ContentMode.scaleAspectFill
        cellImage.clipsToBounds = true
        Alamofire.request(URL(string: news.image_url) ?? "").responseImage { response in

            if let image = response.result.value {
                cellImage.image = image
            }
        }
        cell.addSubview(cellImage)

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //calculate the height of label cells automatically in each section
        if indexPath.row == 0 || indexPath.row == 1 { return UITableView.automaticDimension }
            
            // calculating the height of image for indexPath
        else if indexPath.row == 2, let image = newsDataList[indexPath.section].image {
            
            print("heightForRowAt indexPath : \(indexPath)")
            //image
            
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            guard imageWidth > 0 && imageHeight > 0 else { return UITableView.automaticDimension }
            
            //images always be the full width of the screen
            let requiredWidth = tableView.frame.width
            
            let widthRatio = requiredWidth / imageWidth
            
            let requiredHeight = imageHeight * widthRatio
            
            print("returned height \(requiredHeight) at indexPath: \(indexPath)")
            return requiredHeight
            
            
        }
        else { return UITableView.automaticDimension }
    }
    
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
    
    func getNews() {
 
    }
        
    
//        let networkLayer: NetworkLayer = NetworkLayer()
//
//        let successHandler: ((News)) -> Void = { (news) in
//            SVProgressHUD.dismiss()
//            for (_,value) in news.result {
//                self.newsList.append(value)
//            }
//        }
//
//        let errorHandler: (String) -> Void = { (error) in
//            SVProgressHUD.dismiss()
//            print(error)
//        }
//
//        let headers : [String: String] = ["Content-Type":"application/json; charset=UTF-8"]
//
//        let parameters : [String: Any] = ["country":"us",
//                                          "apiKey" : apiKey
//                        ]
//
//        let url = "https://newsapi.org/v2/top-headlines?"
//        networkLayer.request(httpMethod: Constants.GET, urlString: url, headers: [:], parameters: parameters, successHandler: successHandler, errorHandler: errorHandler)
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Private functions
}
