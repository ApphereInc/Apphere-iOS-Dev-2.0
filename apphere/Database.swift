//
//  Database.swift
//  apphere
//
//  Created by Tony Mann on 3/12/18.
//  Copyright © 2018 Derek Sheldon. All rights reserved.
//

import Foundation
import Firebase

class Database {
    static var shared = Database()
    lazy var db = Firestore.firestore()
}
