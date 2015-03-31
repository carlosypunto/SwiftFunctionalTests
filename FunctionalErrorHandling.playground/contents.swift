

// Based on MCE 2015 - Chris Eidhof - Fun with Swift Conference:
// URL: https://www.youtube.com/watch?v=KNJ_UPebGOQ


import Foundation

class Box<T> {
    let unbox: T
    init (_ value: T) { self.unbox = value }
}

enum Result<T> {
    case Error(NSError)
    case Success(Box<T>)
}

// --------------

let myURL = NSURL(string: "https://api.github.com/users/carlosypunto") // Good URL
let my2URL = NSURL(string: "https://xapi.github.com/users/carlosypunto") // Inexixtent URL
let my3URL = NSURL(string: "https://www.github.com/") // Bad URL

// --------------

func getData(url: NSURL) -> Result<NSData> {
    var error: NSError? = nil
    let optionalData = NSData(contentsOfURL: url, options: NSDataReadingOptions.allZeros, error: &error)
    if let data = optionalData {
        return .Success(Box(data))
    }
    else {
        return .Error(error!)
    }
}

typealias JSONDict = [String:AnyObject]

func parseJSON(data: NSData) -> Result<JSONDict> {
    var error: NSError? = nil
    if let obj = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as? JSONDict {
        return .Success(Box(obj))
    }
    else {
        return .Error(error!)
    }
}

func parsePublicRepos(dict:JSONDict) -> Result<Int> {
    if let number = dict["id"] as? Int {
        return .Success(Box(number))
    }
    else {
        let error = NSError(domain: "cgn.es", code: 42, userInfo: [:])
        return .Error(error)
    }
}

// --------------

infix operator >>> { associativity left }

func >>><A, B>(value: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch value {
    case .Error(let e):
        return .Error(e)
    case .Success(let boxed):
        return f(boxed.unbox)
    }
}

// ---------------------------------------------------------------------------------------

func getIdFromURL(url:NSURL) -> Result<Int> {
    return getData(url) >>> parseJSON >>> parsePublicRepos
}

switch getIdFromURL(myURL!) {
case .Success(let number):
    println("SUCCESS!: \(number.unbox)")
case .Error(let err):
    println(err.localizedDescription)
}

/*
switch getData(myURL!) {
case .Success(let data):
    switch parseJSON(data.unbox) {
    case .Success(let json):
        switch parsePublicRepos(json.unbox) {
        case .Success(let n):
            println("Number: \(n.unbox)")
        case .Error(let err):
            println("Some error: \(err.localizedDescription)")
        }
    case .Error(let err):
        println(err.localizedDescription)
    }
case .Error(let err):
    println(err.localizedDescription)
}
*/


// ---------------------------------------------------------------------------------------

func getData2(options: NSDataReadingOptions) -> (NSURL -> Result<NSData>) {
    return { url in
        var error: NSError? = nil
        let optionalData = NSData(contentsOfURL: url, options: options, error: &error)
        if let data = optionalData {
            return .Success(Box(data))
        }
        else {
            return .Error(error!)
        }
    }
}

func getIdFromURL2(url:NSURL) -> Result<Int> {
    return getData2(NSDataReadingOptions.allZeros)(url) >>> parseJSON >>> parsePublicRepos
}

switch getIdFromURL2(myURL!) {
case .Success(let number):
    println("SUCCESS!: \(number.unbox)")
case .Error(let err):
    println(err.localizedDescription)
}



