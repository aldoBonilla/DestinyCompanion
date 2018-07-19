//
//  ManifestEnums.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

enum EntityTypeManifest: String {
    
    case item = "DestinyInventoryItemDefinition/"
    case equipmentSlot = "DestinyEquipmentSlotDefinition/"
    case bucket = "DestinyInventoryBucketDefinition/"
    case perk = "DestinySandboxPerkDefinition/"
    case stat = "DestinyStatDefinition/"
    case statGroup = "DestinyStatGroupDefinition/"
}
