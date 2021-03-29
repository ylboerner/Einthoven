//
//  HKAnchorProvider.swift
//  Einthoven
//
//  Created by Yannick Börner on 29.03.21.
//

import Foundation
import HealthKit

class HKAnchorProvider {
    static func GetAnchor(forType: HKSampleType) -> HKQueryAnchor {
        var anchor = HKQueryAnchor.init(fromValue: 0)
        let anchorKey = getNSUserDefaultsAnchorKey(forType: forType)

        if UserDefaults.standard.object(forKey: anchorKey ) != nil {
            let data = UserDefaults.standard.object(forKey: anchorKey) as! Data
            anchor = NSKeyedUnarchiver.unarchiveObject(with: data) as! HKQueryAnchor
            print("Found existing anchor")
        } else {
            print("No existing anchor found, returning new anchor with value 0")
        }
        return anchor;
    }
    
    static func SaveAnchor(forType: HKSampleType, anchor: HKQueryAnchor) {
        let anchorKey = getNSUserDefaultsAnchorKey(forType: forType)

        let data : Data = NSKeyedArchiver.archivedData(withRootObject: anchor as Any)
        UserDefaults.standard.set(data, forKey: anchorKey)
        print("Saved new anchor")
    }
    
    static func getNSUserDefaultsAnchorKey(forType: HKSampleType) -> String {
        let anchorKey = forType.identifier + "Anchor"
        return anchorKey
    }
}

