//: Playground - noun: a place where people can play

import Cocoa

let json =
    """
    {
        "name": "analysisID",
        "columnName": "ANALYSIS_ID",
        "allowsNull": false,
        "prototypeName": "id"
    }
    """
let plist =
    """
    {
        name = analysisID;
        columnName = "ANALYSIS_ID";
        allowsNull = N;
        prototypeName = id;
    }
    """
//        userInfo = {"ERXCopyable.CopyType" = Nullify; };

struct EOAttribute: Codable {
    enum Keys: String, CodingKey {
        case name, columnName, allowsNull, prototypeName
/*        case columnName = "columnName"
        case allowsNull = "allowsNull"
        case prototypeName = "prototypeName"
 */
    }
    
    var name: String?
    var columnName: String?
    var allowsNull: Bool?
    var prototypeName: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let name = try container.decode(String.self, forKey: .name)
        let columnName = try container.decode(String.self, forKey: .columnName)
        let allowsNull = try container.decode(Bool.self, forKey: .allowsNull)
        let prototypeName = try container.decode(String.self, forKey: .prototypeName)
        
        self.name = name
        self.columnName = columnName
        self.allowsNull = allowsNull
        self.prototypeName = prototypeName
    }
}
if let data = json.data(using: .utf8) {
    let decoder = JSONDecoder()
    do {
        let attr = try decoder.decode(EOAttribute.self, from: data)
        print(attr)
    } catch {
        print(error)
    }
}

//let decoder = PropertyListDecoder()
//let container = try decoder.container(keyedBy: EOAttribute.Keys.self)

//print(container)
/*
if let data = plist.data(using: .utf8) {
    let decoder = PropertyListDecoder()
    do {
        let attr = try decoder.decode(EOAttribute.self, from:data)
        print(attr)
    } catch {
        print(error)
    }
}
*/

print("Done")
