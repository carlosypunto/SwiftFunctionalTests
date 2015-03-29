//: Playground - noun: a place where people can play

import UIKit

// Based in article:
// http://www.drewag.me/posts/practical-use-for-curried-functions-in-swift

struct Logger {
    
    /// Level of log message to aid in the filtering of logs
    enum Level: Int, Printable {
        /// Messages intended only for debug mode
        case Debug = 3
        
        /// Messages intended to warn of potential errors
        case Warn =  2
        
        /// Critical error messagees
        case Error = 1
        
        /// Log level to turn off all logging
        case None = 0
        
        var description: String {
            switch(self) {
            case .Debug:
                return "Debug"
            case .Warn:
                return "Warning"
            case .Error:
                return "Error"
            case .None:
                return ""
            }
        }
    }
    
    /// Log a message to the console
    ///
    /// :param: level What level this log message is for
    /// :param: name A name to group a set of logs by
    /// :param: message The message to log
    ///
    /// :returns: the logged message
    static func log
        (#level: Level)
        (@autoclosure name: () -> String)
        (@autoclosure message: () -> String) -> String
    {
        if level.rawValue <= Logger.logLevel.rawValue {
            let full = "\(level.description): \(name()) - \(message())"
            println(full)
            return full
        }
        return ""
    }
    
    /// What is the max level to be logged
    ///
    /// Any logs under the given log level will be ignored
    static var logLevel: Level = .Warn
    
    /// Logger for debug messages
    static var debug = Logger.log(level: .Debug)
    
    /// Logger for warnings
    static var warn = Logger.log(level: .Warn)
    
    /// Logger for errors
    static var error = Logger.log(level: .Error)
}

Logger.logLevel = .Debug

Logger.log(level: .Debug)(name: "SomeName")(message: "message")

Logger.debug(name: "SomeName")(message: "message 2")

let myLog = Logger.debug(name: "My")
myLog(message: "message 3")

