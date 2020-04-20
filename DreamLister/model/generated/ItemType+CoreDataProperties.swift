//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Jose Monge on 4/20/20.
//  Copyright © 2020 Jose Monge. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
