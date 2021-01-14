/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

import Foundation

struct IdentifiableNumber: Codable, Comparable {
    let number: Int64
    let label: String
    let modificationDate: Date
    let isRemoved: Bool

    // MARK: - Comparable
    static func < (lhs: IdentifiableNumber, rhs: IdentifiableNumber) -> Bool {
        return lhs.number < rhs.number
    }
}
