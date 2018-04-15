//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B> (_ a: A, _ f: (A) -> B) -> B {
    return f(a)
}

infix operator |: ForwardApplication

func | <A, B> (_ a: A, _ f: (A) -> B) -> B {
    return f(a)
}

func incr(_ a: Int) -> Int {
    return a + 1
}

func square(_ a: Int) -> Int {
    return a * a
}

func uppercased(_ a: String) -> String {
    return a.uppercased()
}

2 |> incr |> square |> String.init

"Ricardo" |> uppercased


precedencegroup ForwardComposition {
    higherThan: ForwardApplication
    associativity: left
}

infix operator >>>: ForwardComposition

func >>> <A,B,C> (_ f: @escaping (A) -> B, _ g: @escaping (B) -> C )
    -> ((A) -> C)
{
    return { a in
        let b = f(a)
        let c = g(b)
        return c
    }
}

2 |> incr >>> square |> String.init

("3" |> Int.init)! |> incr |> square

[1,2,3,4,5]
    .map(incr)
    .map(square)

[1,2,3,4,5]
    .map(incr >>> square)


struct Person {
    var firstName: String
    var lastName: String
    var age: Int
    
    var fullName: String {
        return "\(lastName), \(firstName)"
    }
}

extension Person: CustomStringConvertible {
    var description: String {
        return "{\(fullName), age: \(age)} "
    }
}

let family = [
    Person(firstName: "Emiliano", lastName: "Parada", age: 5),
    Person(firstName: "Luna", lastName: "Parada", age: 11),
    Person(firstName: "Olivia", lastName: "Rebull", age: 12),
    Person(firstName: "Sofia", lastName: "Rebull", age: 14),
    Person(firstName: "Aymara", lastName: "Parada", age: 47),
    Person(firstName: "Ricardo", lastName: "Parada", age: 50)
]

func sortOrdering<Object,Value>(_ keyPath: KeyPath<Object,Value>, _ isOrdered: @escaping (Value, Value) -> Bool) -> (Object, Object) -> Bool {
    return { leftObject, rightObject in
        let leftValue = leftObject[keyPath: keyPath]
        let rightValue = rightObject[keyPath: keyPath]
        return isOrdered(leftValue, rightValue)
    }
}

func asc<Object,Value>(_ keyPath: KeyPath<Object,Value>) -> (Object, Object) -> Bool
    where Value: Comparable
{
    return { left, right in
        let leftValue = left[keyPath: keyPath]
        let rightValue = right[keyPath: keyPath]
        return leftValue < rightValue
    }
}

func desc<Object,Value>(_ keyPath: KeyPath<Object,Value>) -> (Object, Object) -> Bool
    where Value: Comparable
{
    return { left, right in
        let leftValue = left[keyPath: keyPath]
        let rightValue = right[keyPath: keyPath]
        return leftValue > rightValue
    }
}


sortOrdering(\Person.age, >)


func combine<Element>(_ orderings: [(Element,Element) -> Bool] )
    -> ((Element, Element) -> Bool)
{
    return {
        leftObject, rightObject in
        for areInIncreasingOrder in orderings {
            if areInIncreasingOrder(leftObject, rightObject) { return true }
            if areInIncreasingOrder(rightObject, leftObject) { return false }
        }
        return false
    }
}


extension Array {
    func sortedBy(_ orderings: ((Element, Element) -> Bool)...) -> Array
    {
        let isOrderedBefore = combine(orderings)
        return self.sorted( by: isOrderedBefore)
    }
}

// orderings.sorted(family)

//family.sortedBy( \Person.lastName | asc, \.age | desc )
//    .forEach { print($0) }
//
//print()
//
//family.sorted(by: combine(orderings))
//    .forEach { print($0) }


func combine<Element>(orderings: [(Element,Element) -> Bool] )
    -> ((Element, Element) -> Bool)
{
    return {
        leftObject, rightObject in
        for areInOrder in orderings {
            if areInOrder(leftObject, rightObject) { return true }
            if areInOrder(rightObject, leftObject) { return false }
        }
        return false
    }
}


family.sorted(by: combine(orderings: [asc(\Person.fullName), desc(\Person.age)]))
    .forEach { print($0) }

print()

// f(x,y) = y/x
//
// Function currying
//      Give x = 2 return a new function g(y) = f(2,y)
//
// Example:

func fxy(_ x: Double, _ y: Double) -> Double {
    return x * x + y * y + y / x
}
fxy(2,3)

func curry<A,B,C>(_ f: @escaping (A,B) -> C)
    -> ((A) -> (B) -> C)
{
    return { a in
        return { b in f(a,b) }
    }
}

curry(fxy)(2)(3)

let enLocale = Locale(identifier: "en")
"Hello".uppercased(with: enLocale)

let uppercasedWithLocale = String.uppercased(with:)

func flip<A,B,C>(_ f: @escaping (A) -> (B) -> C)
    -> ((B) -> (A) -> C)
{
    return { b in { a in f(a)(b) } }
}

let uppercasedWithEn = flip(uppercasedWithLocale)(enLocale)

uppercasedWithEn("ricardo")


Person(firstName: "Ricardo", lastName: "Parada", age: 50)
let keyPath = \Person.firstName
let keyPath2 = \Person.lastName
