//
//  NewsReaderModelController.swift
//  NewsReader
//
//  Created by Patty Case on 3/31/20.
//  Copyright © 2020 Azure Horse Creations. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class NewsReaderModelController {
    
    typealias DownloadComplete = ([AnyObject]) -> ()
    typealias ImageDownloadComplete = (AnyObject) -> ()
    var newsDataList: [NewsData] = []
    
    init() {
    }
    
    /**
     Uses Alamofire to make a network call to the CNN news API
     
     - Parameter completed: completion handler
     
     - Throws:
     
     - Returns: array of NewsData items
     */
    func downloadNews(apiUrl: String, completed: @escaping DownloadComplete) {
        Alamofire.request(apiUrl).responseJSON{ (response) in
            let result = response.result
            let json = JSON(result.value ?? "")
        
            for index in 0..<json["articles"].count {
                let newsData = NewsData()
                newsData.title = json["articles"][index]["title"].stringValue
                newsData.summary = json["articles"][index]["description"].stringValue
                newsData.publish_date = json["articles"][index]["publishedAt"].stringValue
                newsData.image_url = json["articles"][index]["urlToImage"].stringValue
                self.newsDataList.append(newsData)
            }
            completed(self.newsDataList)
        }
    }
    
    /**
     Uses Alamofire to fetch an image
     
     - Parameter completed: completion handler
     
     - Throws:
     
     - Returns: UIImage
     */
    func downloadImage(imageUrl: String, completed: @escaping ImageDownloadComplete) {
        Alamofire.request(URL(string: imageUrl) ?? "").responseImage { response in
            if let image = response.result.value {
                completed(image)
            }
        }
    }
}
