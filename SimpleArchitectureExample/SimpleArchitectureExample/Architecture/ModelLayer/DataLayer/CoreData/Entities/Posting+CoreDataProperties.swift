//
//  Posting+CoreDataProperties.swift
//  
//
//  Created by herbal7ea on 10/2/19.
//
//

import Foundation
import CoreData


extension Posting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Posting> {
        return NSFetchRequest<Posting>(entityName: "Posting")
    }

    @NSManaged public var userId: Int64
    @NSManaged public var postingId: Int64
    @NSManaged public var title: String
    @NSManaged public var body: String

}
