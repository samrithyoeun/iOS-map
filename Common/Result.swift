//
//  Result.swift
//  Project
//
//  Created by Ricky_DO on 3/19/18.
//  Copyright © 2018 Pathmazing. All rights reserved.
//

import Foundation
import MapKit

enum Result<T> {
    
    case success(T)
    case failure(String)
}
