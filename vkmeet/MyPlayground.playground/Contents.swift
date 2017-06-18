//: Playground - noun: a place where people can play

import UIKit

//var str = "Hello, playground"
//let eventStart = 1496840400
//
//let someDate = Date()
//let timeInterval = someDate.timeIntervalSince1970
//let myInt = Int(timeInterval)
//
//let time = eventStart - myInt


var willgoEventsID = ["146609781","133127050","147241231"]

//if let firstSuchElement = willgoEventsID.first(where: { $0 == "146609781" }) {
//    print("True")
//}
//
//if willgoEventsID.contains(where: { $0 == "146609781" }) {
//    print("Yes")
//}
//
//if willgoEventsID.contains("146609781") {
//    print("Green")
//}

let indexOfEvent = willgoEventsID.index(of: "146609781")
willgoEventsID.remove(at: indexOfEvent!)
willgoEventsID

