//
//  TableViewCell.swift
//  NewsReader
//
//  Created by Patty Case on 3/30/19.
//  Copyright © 2019 Azure Horse Creations. All rights reserved.
//

import UIKit

/// Custom UITableViewCell
class TableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var summary: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /**
     Overriding to customize the image view
     
     - Parameter:
     
     - Throws:
     
     - Returns:
     */
    override func layoutSubviews() {
        imageView?.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        imageView?.clipsToBounds = false
        imageView?.center = CGPoint(x: frame.size.width  / 2, y: frame.size.height / 2)
    }
}
