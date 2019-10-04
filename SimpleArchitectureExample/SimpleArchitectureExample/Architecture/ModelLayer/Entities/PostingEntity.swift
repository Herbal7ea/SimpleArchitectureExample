//
//  Posting.swift
//  SimpleArchitectureExample
//
//  Created by herbal7ea on 10/2/19.
//  Copyright © 2019 Jon Bott. All rights reserved.
//

import Foundation
import CoreData

struct PostingEntity: Codable {
    var userId: Int
    var postingId: Int
    var title: String
    var body: String
    
    private enum CodingKeys: String, CodingKey {
        case userId,
             postingId = "id",
             title,
             body
    }
}

struct PostingsResultWrapper: Codable {
    var postings: [PostingEntity]
}

extension Posting {
    convenience init(entity: PostingEntity, context: NSManagedObjectContext) {
        self.init(context: context)
        userId = Int64(entity.userId)
        title = entity.title
        body = entity.body
        postingId = Int64(entity.postingId)
    }
}
