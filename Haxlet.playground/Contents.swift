//: Playground - noun: a place where people can play

import UIKit
import Foundation

/// Ветвление. Урок 8

//let p = (2,2)
//switch p {
//case (_, 2):
//    "Good Job"
//case let (x,y) where x==y:
//    "Super Greate Job"
//default: "Else"
//}


/// Функции. Урок 9

//func hi(name: String="DC") -> (word: String, name: String) {
//    return ("Hi, ", name)
//}
//
//hi()


/// Переменные параметры и inout

//func swapTwoInts(a: inout Int, b: inout Int) {
//    let temp = a
//    a = b
//    b = temp
//}
//
//var a = 10
//var b = 50
//swapTwoInts(a: &a, b: &b)
//a
//b


/// Тип функции. (Int, Int) -> Int

//typealias mathFunc = (Int, Int) -> Int
//
//func addTwoInts(a:Int, b:Int) -> Int {
//    return a+b
//}
//
//var math: mathFunc = addTwoInts
//
//func overMathFunction(aFunction: mathFunc) -> Int {
//    return aFunction(42, 42)
//}
//
//overMathFunction(aFunction: addTwoInts)


/// Пример замыкания. Урок 13

//let names = ["Anna", "Alex", "Drogo", "Peter", "Jeremy", "Zeus"]
//
//func backwards(s1: String, s2: String) -> Bool {
//    return s1 > s2
//}
//
//let names2 = names.sorted(by: backwards)
//
//var reversed = names.sorted { (s1, s2) -> Bool in
//    return s1 > s2
//}
//
//reversed = names.sorted(by: {$0 > $1})
//reversed


/// Замыкание. Урок 14

//func makeIncrementor(forIncrement amount: Int) -> () -> Int {
//    var runningTotal = 0
//    
//    func incrementor() -> Int {
//        runningTotal += amount
//        return runningTotal
//    }
//    
//    return incrementor
//}
//
//var incrementByTen = makeIncrementor(forIncrement: 10)
//incrementByTen()


/// Энумератор (перечисление). Урок 15

//enum CompassPoint {
//    case North
//    case South
//    case East
//    case West
//}
//
//var direction = CompassPoint.North
//direction = .East
//
//enum Barcode {
//    case UPCA (Int, Int, Int)
//    case QRCode (String)
//}
//
//var productBarcode = Barcode.UPCA(12, 21312, 43)
//productBarcode = .QRCode("RFVDFRGV")


/// Value type vs. Reference type

//struct Resolution {
//    var width = 0
//    var height = 0
//}
//
//class VideoMode {
//    var resolution = Resolution()
//    var interlaced = false
//    var frameRate = 0.0
//    var name: String?
//}
//
// structs and enums are value types
//var hd = Resolution(width: 1920, height: 1080)
//var cinema = hd
//cinema.width = 2048
//hd.width
//
// classes are reference types
//let tenEighty = VideoMode()
//tenEighty.resolution = hd
//tenEighty.interlaced = true
//tenEighty.name = "1080i"
//tenEighty.frameRate = 25.0
//
//let alsoTenEighty = tenEighty
//alsoTenEighty.frameRate = 30.0
//tenEighty.frameRate


/// Вычисляемые (computed) свойства. Урок 19

//struct Point {
//    var x = 0.0, y = 0.0
//}
//
//struct Size {
//    var width = 0.0, height = 0.0
//}
//
//struct Rect {
//    var origin = Point()
//    var size = Size()
//    var center: Point {
//        get {
//            let centerX = origin.x + (size.width/2)
//            let centerY = origin.y + (size.height/2)
//            return Point(x:centerX, y:centerY)
//        }
//        set(newCenter) {
//            origin.x = newCenter.x - (size.width/2)
//            origin.y = newCenter.y - (size.height/2)
//        }
//    }
//}
//
//var square = Rect(origin: Point(x: 0.0, y: 0.0),
//                  size: Size(width: 10.0, height: 10.0))
//let initialSquareCenter = square.center
//square.center = Point(x: 15.0, y: 15.0)


/// Наблюдатели (property observers)

//class StepCounter {
//    var totalSteps:Int = 0 {
//        willSet(newTotalSteps) {
//            print("About to set totalSteps to \(newTotalSteps)")
//        }
//        didSet {
//            if totalSteps > oldValue {
//                print("Added \(totalSteps - oldValue) steps")
//            }
//        }
//    }
//}
//
//let stepCounter = StepCounter()
//stepCounter.totalSteps = 200
//
//stepCounter.totalSteps = 360


/// Свойства типа. Урок 21

//struct SomeStructure {
//    static var storedTypeProperty = "Some value"
//    static var computedTypePropery: Int {
//        return 100 // return an Int
//    }
//}
//
//enum SomeEnumeration {
//    static var storedTypeProperty = "Some value"
//    static var computedTypeProperty: Int {
//        return 100 // return an Int
//    }
//}
//
//class SomeClass {
//    class var computedTypePropety: Int {
//        return 100 // return an Int
//    }
//    class func someTypeMethod() {
//        // type method code
//    }
//}


/// Мутирующие (mutating) методы
/// structurs and enums are value types, they can't be modified from within their instance methods

//struct Point {
//    var x = 0.0, y = 0.0
//    mutating func moveByX(deltaX: Double, deltaY: Double) {
//        x += deltaX
//        y += deltaY
//    }
//}
//
//var somePoint = Point(x: 1.0, y: 1.0)
//somePoint.moveByX(deltaX: 2.0, deltaY: 3.0)
//somePoint.x
//somePoint.y
//
//let fixedPoint = Point(x: 1.0, y: 1.0)
// fixedPoint.moveByX(deltaX: 2.0, deltaY: 3.0)


///  Сабскрипты (subscripts). Урок 24

//struct SomeStruct {
//    subscript(index: Int) -> String {
//        get { return "Return something" }
//        set (newValue) { "Set something" }
//    }
//}
//
//struct TimesTable {
//    let multiplier: Int
//    subscript(index: Int) -> Int {
//        return multiplier * index
//    }
//}
//
//let threeTimesTable = TimesTable(multiplier: 3)
//threeTimesTable[10]


/// Наследование. Урок 25

//final class Vehicle {
//    var numberOfWheels: Int
//    var maxPassengers: Int
//    var speed: Double
//    
//    func description() -> String {
//        return "\(numberOfWheels) wheels; up to \(maxPassengers) passengers"
//    }
//    
//    init() {
//        numberOfWheels = 0
//        maxPassengers = 1
//        speed = 20
//    }
//}
//
//class Bicycle: Vehicle {
//    override var speed: Double {
//        get {
//            return super.speed
//        }
//        set {
//            super.speed = min(newValue, 50.0)
//        }
//    }
//    override init() {
//        super.init()
//        numberOfWheels = 2
//    }
//    
//    override func description() -> String {
//        return super.description() + "; " + " and it's a bicycle!"
//    }
//}


/// Инициализаторы. Урок 26

//struct Color {
//    var red = 0.0, green = 0.0, blue = 0.0
//    let alpha: Double?
//    
//    init(red: Double, green: Double, blue: Double) {
//        self.red = red
//        self.green = green
//        self.blue = blue
//        self.alpha = 10.0
//    }
//}
//
//let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
//// let wrong = Color(0.0, 0.2, 0.3)
//
//class ShoppingListItem {
//    var name: String?
//    var quantity = 1
//    var purchased = false
//}
//
//var item = ShoppingListItem()
//item.quantity = 10


/// ARC (Automatic reference counting). Урок 28

//class Person {
//    let name: String
//    init (name: String) {
//        self.name = name
//        print("\(name) is being initialized")
//    }
//    deinit {
//        print("\(name) is being deinitialized")
//    }
//}
//
//var ref1: Person?
//var ref2: Person?
//var ref3: Person?
//
//ref1 = Person(name: "Jake")
//
//ref2 = ref1
//ref3 = ref1
//
//ref1 = nil
//ref2 = nil
//ref3 = nil


/// Расширения (extension). Урок 29

struct SomeStruct {
    var someProp = 1.0
}

extension SomeStruct {
    init(prop: Double) {
        let newProp = prop + 42
        self.init(someProp: newProp)
    }
}

var a = SomeStruct(prop: 2)
































