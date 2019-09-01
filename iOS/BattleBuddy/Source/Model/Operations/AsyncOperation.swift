//
//  AsyncOperation.swift
//  BattleBuddy
//
//  Created by Mike on 8/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {

    public enum State: String {
        case ready, executing, finished
        var keyPath: String { return "is" + rawValue.capitalized }
    }

    //Notify KVO properties of the new/old state
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet{
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncOperation {
    override open var isReady: Bool { return super.isReady && state == .ready }
    override open var isExecuting: Bool { return state == .executing }
    override open var isFinished: Bool { return state == .finished }

    override open func start() {
        if isCancelled {
            state = .finished
            return
        }

        main()
        state = .executing
    }

    override open func cancel() {
        super.cancel()
        state = .finished
    }
}
