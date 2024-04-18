//
//  Copyright © 2023 Embrace Mobile, Inc. All rights reserved.
//

import Foundation
import EmbraceCommon
import EmbraceOTel
import EmbraceStorage

class StorageEmbraceLogExporter: EmbraceLogRecordExporter {
    @ThreadSafe
    private(set) var state: State
    private let logBatcher: LogBatcher
    private let validation: LogDataValidation

    enum State {
        case active
        case inactive
    }

    init(logBatcher: LogBatcher, state: State = .active, validators: [LogDataValidator] = .default) {
        self.state = state
        self.logBatcher = logBatcher
        self.validation = LogDataValidation(validators: validators)
    }

    func export(logRecords: [ReadableLogRecord]) -> ExportResult {
        guard state == .active else {
            return .failure
        }

        for var log in logRecords where validation.execute(log: &log) {

            // do not export raw crash logs
            guard log.attributes["emb.type"] != .string(LogType.rawCrash.rawValue) else {
                continue
            }

            self.logBatcher.addLogRecord(logRecord: buildLogRecord(from: log))
        }

        return .success
    }

    func shutdown() {
        state = .inactive
    }

    /// Everything is always persisted on disk, so calling this method has no effect at all.
    /// - Returns: `ExportResult.success`
    func forceFlush() -> ExportResult {
        .success
    }
}

private extension StorageEmbraceLogExporter {
    func buildLogRecord(from originalLog: ReadableLogRecord) -> LogRecord {
        let embAttributes = originalLog.attributes.reduce(into: [String: PersistableValue]()) {
            $0[$1.key] = PersistableValue(attributeValue: $1.value)
        }
        return .init(identifier: LogIdentifier(),
                     processIdentifier: ProcessIdentifier.current,
                     severity: originalLog.severity?.toLogSeverity() ?? .info,
                     body: originalLog.body ?? "",
                     attributes: embAttributes,
                     timestamp: originalLog.timestamp)
    }
}

private extension PersistableValue {
    init?(attributeValue: AttributeValue) {
        switch attributeValue {
        case let .string(value):
            self.init(value)
        case let .bool(value):
            self.init(value)
        case let .int(value):
            self.init(value)
        case let .double(value):
            self.init(value)
        case let .stringArray(value):
            self.init(value)
        case let .boolArray(value):
            self.init(value)
        case let .intArray(value):
            self.init(value)
        case let .doubleArray(value):
            self.init(value)
        }
    }
}
