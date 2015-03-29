#!/usr/bin/env xcrun swift

import Foundation

let start = NSDate();

func even<T:IntegerType>(i:T) -> Bool {
    return i % 2 == 0
}

func collatzSequence<I: IntegerType>(int: I) -> [I] {
    if int == 1 { return [1] }
    if even(int) {
        return [int] + collatzSequence(int / 2)
    }
    else {
        return [int] + collatzSequence(int * 3 + 1)
    }
}

func numLongChain() -> Int {
    return filter(map(Array(1...100), collatzSequence), { $0.count > 15 }).count
}


println(numLongChain())
println("\(NSDate().timeIntervalSinceDate(start)) s.")