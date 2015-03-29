//: Playground - noun: a place where people can play

import UIKit


import Foundation

func getContents(url: String) -> String {
    return NSString(contentsOfURL: NSURL(string: url)!, encoding: NSUTF8StringEncoding, error: nil)! as String
}

func lines(input: String) -> [String] {
    return input.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
}

let linesInURL = { url in count(lines(getContents(url))) }

linesInURL("http://www.objc.io")


infix operator <<< { associativity left }

func <<< <A, B> (f: A -> B, x: A) -> B {
    return f(x)
}

func <<< <A, B, C> (f: B -> C, g: A -> B) -> (A -> C) {
    return { x in f(g(x)) }
}


let linesInURL2 = (count <<< lines <<< getContents)("http://www.objc.io/books")

let linesInURL3 = count <<< lines <<< getContents <<< "http://www.objc.io/books"



// --


infix operator >>> { associativity right }

func >>> <A, B> (s: A, f: A -> B) -> B {
    return f(s)
}

func >>> <A, B, C> (f: A -> B, g: B -> C) -> (A -> C) {
    return { x in g(f(x)) }
}

let linesInURL4 = "http://www.objc.io/books" >>> getContents >>> lines >>> count
