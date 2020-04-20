//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Jose Monge on 4/20/20.
//  Copyright © 2020 Jose Monge. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate() as Date
    }
    
}
