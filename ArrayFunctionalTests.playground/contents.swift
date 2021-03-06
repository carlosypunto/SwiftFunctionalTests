//: Playground - noun: a place where people can play

// Haskell array functions

func head<T>(array: [T]) -> T! {
    if array.count == 0 { return nil } // we return null instead of an error
    return array.first
}

func tail<T>(array: [T]) -> [T]! {
    if array.count == 0 { return nil } // we return null instead of an error
    if array.count == 1 { return [] }
    return Array(dropFirst(array))
}

func last<T>(array:[T]) -> T! {
    if array.count == 0 { return nil } // we return null instead of an error
    return array.last!
}

// renowned init, you can not use init
func beginning<T>(array:[T]) -> [T]! {
    if array.count == 0 { return nil } // we return null instead of an error
    if array.count == 1 { return [] }
    return Array(dropLast(array))
}

// OOP
extension Array {
    
    var head: T! {
        if self.count == 0 { return nil } // we return null instead of an error
        return self.first
    }
    
    var tail: [T]! {
        if self.count == 0 { return nil } // we return null instead of an error
        return Array(dropFirst(self))
    }
    
    // renowned init, you can not use init
    var beginning: [T]! {
        if self.count == 0 { return nil } // we return null instead of an error
        return Array(dropLast(self))
    }
    
    // decompose
    // http://www.objc.io/snippets/1.html
    var decompose1 : (head: T, tail: [T])? {
        return (count > 0) ? (self[0],  Array(self[1..<count])) : nil
    }
    
    // better, leverages the tail function
    var decompose : (head: T, tail: [T])? {
        return (count > 0) ? (self[0],  self.tail) : nil
    }
    
    func take(n:Int) -> [T] {
        if n == 0 { return Array<T>() }
        if self.count == 0 { return Array<T>() }
        let (x,xs) = self.decompose!
        return [x] + xs.take(n - 1)
    }
    
}


var emptyIntArray:[Int] = []
let a = [3, 4, 1, 5, 2, 8]


head(emptyIntArray)
tail(emptyIntArray)
last(emptyIntArray)
beginning(emptyIntArray)

head(a)
tail(a)
last(a)
beginning(a)

emptyIntArray.head
emptyIntArray.tail
emptyIntArray.last
emptyIntArray.beginning

a.head
a.tail
a.last
a.beginning
a.decompose



// SORT

// Functional Programming in Swift book
func qsort(var array: [Int]) -> [Int] { // bad, it keep state on array
    if array.isEmpty { return [] }
    let pivot = array.removeAtIndex(0)
    let lesser = array.filter({ $0 < pivot })
    let greater = array.filter({ $0 >= pivot })
    return qsort(lesser) + [pivot] + qsort(greater)
}


// more functional versión, generic quickSort based on no generic form:
// http://www.objc.io/snippets/3.html
// it do not accept no typed empty arrays [], use only typed arrays ie: [Int]()
func quickSort<T: Comparable>(array:[T]) -> [T] {
    if let (x,xs) = array.decompose {
        let lesser = xs.filter({ $0 <= x })
        let greater = xs.filter({ $0 > x })
        return quickSort(lesser) + [x] + quickSort(greater)
    }
    else {
        return []
    }
}

let aSorted = qsort(a)
aSorted


// quickSort([]) // fails because it is not defined the type of T
quickSort([Int]())
quickSort(a)



//////////////////////////////////////////////////////////////////////////////////////
// RECURSION examples using Array.decompose (see Array extension above)
//////////////////////////////////////////////////////////////////////////////////////

// sum

func recursiveSum(array:[Int]) -> Int {
    if let (x,xs) = array.decompose {
        return x + recursiveSum(xs)
    }
    else {
        return 0
    }
}

recursiveSum([Int]())
recursiveSum([1,2,3])

// maximum --------------------------------------------------------

func recursiveMaximum<T: Comparable>(array:[T]) -> T! {
    if array.count == 1 { return array[0] }
    if let (x,xs) = array.decompose {
        let maxTail = recursiveMaximum(xs)
        return x > maxTail ? x : maxTail
    }
    else {
        return nil
    }
}

recursiveMaximum([Int]())
recursiveMaximum([1,2,3])

// replicate ------------------------------------------------------

func recursiveReplicate<T, I: IntegerType>(n:I, e:T) -> [T] {
    if n == 0 { return Array<T>() }
    return [e] + recursiveReplicate(n - 1, e)
}

recursiveReplicate(3, "n")
recursiveReplicate(15, 1)

// take -----------------------------------------------------------

func take<T, I: IntegerType>(n:I, array:[T]) -> [T] {
    if n == 0 { return Array<T>() }
    if array.count == 0 { return Array<T>() }
    let (x,xs) = array.decompose!
    return [x] + take(n - 1, xs)
}

take(0, a)
take(1, a)
take(3, a)
take(5, a)
// Array.take (see Array extension above)
a.take(0)
a.take(1)
a.take(3)
a.take(5)

// reverse --------------------------------------------------------

func reverse<T>(array:[T]) -> [T] {
    if array.count == 0 { return Array<T>() }
    if array.count == 1 { return array }
    let (x,xs) = array.decompose!
    return reverse(xs) + [x]
}

a
a.reverse() // Swift Standard Library
reverse(a)

// zip -------------------------------------------------------------

func zip<A,B>(aA:[A], aB:[B]) -> [(A,B)] {
    if let (x,xs) = aA.decompose, (y,ys) = aB.decompose {
        return [(x,y)] + zip(xs, ys)
    }
    else {
        return []
    }
}

zip(Array<String>(), [1, 2, 3])
zip([1,2,3], Array<String>())
zip([1,2,3,4,5], ["one","two","three"])

// zipWidth -------------------------------------------------------------

func zipWith<A,B,C>(f: (A, B) -> C, aA: [A], aB: [B]) -> [C] {
    if let (x,xs) = aA.decompose, (y,ys) = aB.decompose {
        return [f(x, y)] + zipWith(f, xs, ys)
    }
    else {
        return []
    }
}

let testF = { (a:Int, b:String) -> String in
    return "\(a):" + b
}

zipWith(testF, [1, 2, 3], ["one", "two"])

// contains --------------------------------------------------------

func contains<T: Equatable>(e:T, array:[T]) -> Bool {
    if array.count == 0 { return false }
    let (x,xs) = array.decompose!
    if x == e { return true }
    return contains(e, xs)
}

contains(1, [])
contains(4, [1,2,3])
contains(4, [1,2,3,4])


//////////////////////////////////////////////////////////////////////////////////////
// REDUCE
//////////////////////////////////////////////////////////////////////////////////////

// sum

func sumUsingReduce(xs: [Int]) -> Int {
    return reduce(xs, 0) { result, x in result + x }
}


sumUsingReduce([Int]())
sumUsingReduce([1,2,3])

func sumUsingReduceSimplest(xs: [Int]) -> Int {
    return reduce(xs, 0, +)
}

sumUsingReduceSimplest([Int]())

sumUsingReduceSimplest([1,2,3])

// maximum --------------------------------------------------------

func maximumUsingReduce<T: Comparable>(array:[T]) -> T! {
    if array.count == 0 { return nil }
    if array.count == 1 { return array[0] }
    return reduce(array, array[0]) { $0 > $1 ? $0 : $1 }
}

maximumUsingReduce([Int]())
maximumUsingReduce([1,2,3])


// reverse --------------------------------------------------------

func reverseUsingReduce<T>(array:[T]) -> [T] {
    return reduce(array, Array<T>()) { [$1] + $0 }
}

reverseUsingReduce([3,2,1])


// filter --------------------------------------------------------

func filterUsingReduce<T>(f:(T -> Bool), array:[T]) -> [T] {
    return reduce(array, Array<T>()) { f($1) ? $0 + [$1] : $0 }
}

filterUsingReduce(
    { $0 < 10 }, [1,20,3,45])

// 


























