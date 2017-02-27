//: Playground - noun: a place where people can play

import UIKit

var shoppingList = ["catfish", "water", "tulips", "blue paint"]
shoppingList[1] = "bottle of water"

var occupations = [
    "Malcolm": "Captain",
    "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"

let emprtyArray = [String]()
let emptyDictionary = [String: Float]()

var shopList = [Any]()
shopList.append("1")
print(shopList)


var array = [Int](repeating: 0, count: 100)


let individualScores = [45, 43, 43, 17, 12]
var teamScore = 0
for score in individualScores {
    if score > 50 {
        teamScore += 3
    }
    else {
        teamScore += 1
    }
}
print(teamScore)


var optionalString: String? = "Hello"
var greeting = "Hello!"
print(optionalString == greeting)

var optionalName: String? = "John Appleseed"
if let name = optionalName {
    greeting = "Hello, \(name)"
}
else {
    greeting = "this is nil"
}


let nickName: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)!"


let vegetable = "red pepper"
switch vegetable {
case "celery":
    let vegetableComment = "Add some raisins and make ants on a log."
case "cucumber", "watercrees":
    let vegetableComments = "That would make a good tea sandwich"
case let x where x.hasSuffix("pepper"):
    let vegetableComment = "Is it a spicy \(x)"
default:
    let vegetableComment = "Everything tastes good in soup"
}


let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 111, 13],
    "Fibonachi": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
var key = ""
for(kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
            key = kind
        }
    }
}
print("Largest:\(largest) in \(key)")


var n = 2
while n < 100 {
    n = n * 2
}
print (n)
var m:Float = 2
repeat {
    m = m * 2
} while m < 100
print(m)


var firstForLoop = 0
for i in 0...4 {
    firstForLoop += 1
}
print(firstForLoop)
var secondForLoop = 0
for i in 0..<4 {
    secondForLoop += 1
}
print(secondForLoop)




func greet(_ name: String, day: String) -> String {
    return "Hello \(name), today is \(day)"
}
greet("Bob", day: "Tuesaday")


func calculateStatistics(scores: [Int]) -> (min: Int, max: Int, sum: Int) {
    var min = scores[0]
    var max = scores[0]
    var sum = 0
    
    for score in scores {
        if score > max {
            max = score
        }
        else if score < min {
            min = score
        }
        sum += score
    }
    
    return (min, max, sum)
}
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
print(statistics.sum)
print(statistics.2)


func sumOf(numbers: Int...) -> Int {
    var sum = 0
    for number in numbers {
       sum += number
    }
    return sum
}
func midOf(numbers: Int...) -> Int {
    var mid = 0
    for number in numbers {
        mid += number
    }
    return mid/numbers.count
}
sumOf()
sumOf(numbers: 42, 597, 12)
midOf(numbers: 42, 597, 12)


func returnFifteen() -> Int {
    var y = 10
    func add() {
        y += 5
    }
    add()
    return y
}
returnFifteen()

func makeIncrement() -> ((Int) -> Int) {
    func addOne(numbers: Int) -> Int {
        return 1 + numbers
    }
    return addOne
}
var increment = makeIncrement()
increment(7)


func hasAnyMAtches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThenTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 7, 12]
hasAnyMAtches(list: numbers, condition: lessThenTen)




// замыкания
numbers.map({
    (number: Int) -> Int in
    let result = 3 * number
    return result
})

let mappedNumbers = numbers.map({ number in 3 * number})
print(mappedNumbers)

let sortedNumbers = numbers.sorted{$0 > $1}
print(sortedNumbers)




// функция - объект первого класса, т.е. ее можно хранить в переменной, передавать как параметр, возвращать в качестве результата работы другой функции

func add(op1: Double, op2: Double) -> Double {
    return op1 + op2
}
func substract(op1: Double, op2: Double) -> Double {
    return op1 - op2
}

// Описываем переменную
var operation: (Double, Double) -> Double
// Смело присваиваем этой переменной значение нужной нам функции,
// в зависимости от каких-либо условий:
for i in 0..<2 {
    if i == 0 {
        operation = add
    } else {
        operation = substract
    }
    
    let result = operation(1.0, 2.0) // "Вызываем" переменную
    print(result)
}

func performOperation(op1: Double, op2: Double, operation: (Double, Double) -> Double) -> Double {
    return operation(op1, op2)
}

let result = performOperation(op1: 1.0, op2: 2.0, operation: +)
print(result)
















