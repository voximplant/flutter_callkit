/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

import Foundation

struct BlockableNumber: Codable, Comparable {
    let number: Int64
    let modificationDate: Date
    let isRemoved: Bool

    // MARK: - Comparable
    static func < (lhs: BlockableNumber, rhs: BlockableNumber) -> Bool {
        return lhs.number < rhs.number
    }
}
