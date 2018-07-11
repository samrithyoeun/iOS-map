//
//  ServerEnvironment.swift
//  Project
//
//  Created by Ricky_DO on 3/19/18.
//  Copyright © 2018 Pathmazing. All rights reserved.
//

import Foundation

struct ServerEnvironment {
    #if DEV_ENVIRONMENT
    static let localIp = "http://192.168.168.168:8080"
    static let host = "https://maps.googleapis.com/maps/api/directions/json?"
    #else
    static let localIp = "http://pathmazing.com"
    static let host = "https://maps.googleapis.com/maps/api/directions/json?"
    #endif
}
