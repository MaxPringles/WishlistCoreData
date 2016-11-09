//
//  ItemType+CoreDataProperties.swift
//  Wishlist
//
//  Created by Vanessa on 13/10/16.
//  Copyright © 2016 Telstock. All rights reserved.
//

import Foundation
import CoreData

extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
