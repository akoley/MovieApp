//
//  RecentSearch.swift
//  Assignment
//
//  Created by Amrita Koley on 9/19/18.
//  Copyright © 2018 Amrita Koley. All rights reserved.
//

import Foundation
import CoreData

class RecentSearch: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    convenience init() {
        self.init(context: CoreDataHandler.getSharedInstance().tempManagedObjectContext)
    }
    
    init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: Constants.CoreData.Models.RecentSearchEntity,
            in: context)
        super.init(entity: entity!, insertInto: context)
    }
    
    private override init(entity: NSEntityDescription,
                              insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
}
