//
//  ExpandableNames.swift
//  Contacts
//
//  Created by Vu Thanh Tu Trang on 4/24/19.
//  Copyright © 2019 Vu Thanh Tu Trang. All rights reserved.
//

import Foundation
import Contacts

struct ExpandableNames{
    var isExpanded: Bool
    var names: [FavoritableContact]
}

struct FavoritableContact {
    let contact : CNContact
    var hasFavorited: Bool
    
}
