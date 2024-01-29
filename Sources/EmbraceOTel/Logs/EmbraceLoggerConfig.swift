//
//  Copyright © 2023 Embrace Mobile, Inc. All rights reserved.
//

import Foundation

public protocol EmbraceLoggerConfig: Equatable {
    var maximumInactivityTimeInSeconds: Int { get }
    var maximumTimeBetweenLogsInSeconds: Int { get }
    var maximumMessageLength: Int { get }
    var maximumAttributes: Int { get }
    var logAmountLimit: Int { get }
}

extension EmbraceLoggerConfig {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.maximumInactivityTimeInSeconds == rhs.maximumInactivityTimeInSeconds &&
        lhs.maximumTimeBetweenLogsInSeconds == rhs.maximumTimeBetweenLogsInSeconds &&
        lhs.maximumMessageLength == rhs.maximumMessageLength &&
        lhs.maximumAttributes == rhs.maximumAttributes &&
        lhs.logAmountLimit == rhs.logAmountLimit
    }
}

struct DefaultEmbraceLoggerConfig: EmbraceLoggerConfig {
    let maximumInactivityTimeInSeconds: Int = 60
    let maximumTimeBetweenLogsInSeconds: Int = 20
    let maximumAttributes: Int = 10
    let maximumMessageLength: Int = 128
    let logAmountLimit: Int = 10
}
