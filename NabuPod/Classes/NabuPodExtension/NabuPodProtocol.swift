//
//  NabuPodExtension.swift
//  NabuTwo
//
//  Created by Ali Jawad on 06/03/2017.
//  Copyright © 2017 TEO. All rights reserved.
//

import Foundation
protocol PropertyListReadable {
    func propertyListRepresentation() -> NSDictionary
    init?(propertyListRepresentation:NSDictionary?)
}


