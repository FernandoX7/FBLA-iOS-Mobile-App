//
//  ActivityList.swift
//  BHS
//
//  Created by Fernando Ramirez 
//  Copyright (c) 2015 oXpheen. All rights reserved.
//

import Foundation
import CoreData

class ActivityList:NSManagedObject {
    
    @NSManaged var name:String!
    @NSManaged var date:String!
    @NSManaged var location:String!
    @NSManaged var image:NSData!
    @NSManaged var isCompleted:NSNumber!
    @NSManaged var contact:String!
    @NSManaged var time:String!
    
}