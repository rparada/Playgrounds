/*:

 # Key Value Coding Implementation
 
 ### Limitations
    1. It can only get values for properties
    2. It cannot set the value of a property
    3. It cannot get the value returned by calling a method of the object
 
*/

let tuples = [ ("name", "ricardo"), ("age",50), (nil,"null"), ("hobby", nil) ] as [(String?, Any?)]

// for
print("This for loop iterates over all the tuples, including those with nil keys and values")
for (key,value) in tuples {
    let keyString = String(describing:key)
    let valueString = String(describing:value)
    print("\(keyString): \(valueString)")
}

print()

// for case let
print("This \"for case let\" loop skips nil keys")
for case let (key?,value) in tuples {
    let keyString = String(describing:key)
    let valueString = String(describing:value)
    print("\(keyString): \(valueString)")
}


// Bare bones key-value-coding implementation

protocol KVC {
    func value(forKey key: String) -> Any?
}

// Default implementation
extension KVC {
    func value(forKey key: String) -> Any? {
        let aMirror = Mirror(reflecting:self)
        for case let (label?, value) in aMirror.children {
            if label == key {
                return value
            }
        }
        return nil
    }
}

public struct Person : KVC {
    let firstName: String
    let lastName: String
    let age: Int
    
    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
}

let aPerson = Person(firstName:"Ricardo", lastName:"Parada", age:48)

// It works for stored properties
let lastName = aPerson.value(forKey:"lastName") as! String

print("Last name is \(lastName)")


