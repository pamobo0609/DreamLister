//
//  ItemCell.swift
//  DreamLister
//
//  Created by Jose Monge on 4/20/20.
//  Copyright © 2020 Jose Monge. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func bind(item: Item) {
        //self.thumb.image =
        self.title.text = item.title
        self.price.text = "$\(item.price)"
        self.details.text = item.details
    }
    
}
