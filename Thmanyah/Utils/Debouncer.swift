//
//  Untitled.swift
//  Thmanyah
//
//  Created by Macbook on 20/08/2025.
//

import Foundation

public actor Debouncer {
    private let delayNanoseconds: UInt64
    private var currentTask: Task<Void, Never>?

    public init(milliseconds: Int) {
        self.delayNanoseconds = UInt64(milliseconds) * 1_000_000
    }

    public func submit(_ block: @escaping @Sendable () async -> Void) {
        currentTask?.cancel()
        currentTask = Task {
            try? await Task.sleep(nanoseconds: delayNanoseconds)
            if Task.isCancelled { return }
            await block()
        }
    }

    public func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
}
