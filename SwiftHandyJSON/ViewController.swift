//
//  ViewController.swift
//  SwiftHandyJSON
//
//  Created by 乐天 on 2017/10/10.
//  Copyright © 2017年 乐天. All rights reserved.
//

import UIKit
import HandyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonString = "{\"name\":\"cat\",\"id\":\"12345\",\"num\":180}"
        
        if let animal = JSONDeserializer<Animal>.deserializeFrom(json: jsonString) {
            print(animal.name!)
            print(animal.id!)
            print(animal.num!)
        }
        
        
        let jsonString1 = "{\"id\":1234567,\"name\":\"Kitty\",\"friend\":[\"Tom\",\"Jack\",\"Lily\",\"Black\"],\"weight\":15.34,\"alive\":false,\"color\":\"white\"}"
        
        if let cat1 = JSONDeserializer<Cat1>.deserializeFrom(json: jsonString1) {
            print(cat1.friend!)
        }
        
        if let cat = JSONDeserializer<Cat>.deserializeFrom(json: jsonString1) {
            print(cat.friend!)
        }
        
        
        
        
        let jsonString2 = "{\"num\":12345,\"comp1\":{\"aInt\":1,\"aString\":\"aaaaa\"},\"comp2\":{\"aInt\":2,\"aString\":\"bbbbb\"}}"
        
        if let composition = JSONDeserializer<Composition>.deserializeFrom(json: jsonString2) {
            print(composition.comp1?.aString! as Any)
        }
        
        
        let jsonString3 = "{\"cat_id\":12345,\"name\":\"Kitty\",\"parent\":\"Tom/Lily\"}"
        
        if let composition = JSONDeserializer<Cat3>.deserializeFrom(json: jsonString3) {
            print(composition.parent!)
        }
        
        
        let jsonString4 = "{\"dating_apply_price\":0,\"female_audio_price\":\"0\",\"slogan\":\"开心果是除烦恼，应开心\",\"unit\":[{\"aInt\":2,\"aString\":\"bbbbb\"},{\"aInt\":2,\"aString\":\"bbbbb\"},{\"aInt\":2,\"aString\":\"bbbbb\"}]}"
        
        if let people = JSONDeserializer<people>.deserializeFrom(json: jsonString4) {
            print("///////////////",people.unit!.count)
        }
    }

}

class unit: HandyJSON {
    
    var aInt: Int?
    var aString: String?
    required init() {}
}

class people: HandyJSON {
    
    var dating_apply_price : String!;
    var female_audio_price : String!;
    var slogan : String!;
    
    var unit : [[String : Any]]!

    required init() {}
    
    

}


class Cat3: HandyJSON {
    
//    可以看到，Cat类的id属性和JSON文本中的Key是对应不上的；而对于parent这个属性来说，它是一个元组，做不到从JSON中的"Tom/Lily"解析出来。所以我们要定义一个Mapping函数来做这两个支持
    
    var id: Int64!
    var name: String!
    var parent: (String, String)?
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        
        // 指定 id 字段用 "cat_id" 去解析
        mapper.specify(property: &id, name: "cat_id")
        
        // 指定 parent 字段用这个方法去解析
        mapper.specify(property: &parent) { (rawString) -> (String, String) in
            
            let parentNames = rawString.characters.split{$0 == "/"}.map(String.init)
            return (parentNames[0], parentNames[1])
        }
    }
}


class Animal: HandyJSON {
    var name: String?
    var id: String?
    var num: Int?
    
    required init() {} // 如果定义是struct，连init()函数都不用声明；
}

class Cat1: HandyJSON {
    
    var id: Int64!
    var name: String!
    var friend: [String]?
    var weight: Double?
    var alive: Bool = true
    var color: NSString?
    
    required init() {}// 如果定义是struct，连init()函数都不用声明；
}

struct Cat: HandyJSON {
    
    var id: Int64!
    var name: String!
    var friend: [String]?
    var weight: Double?
    var alive: Bool = true
    var color: NSString?
}




struct Component: HandyJSON {
    var aInt: Int?
    var aString: String?
}

struct Composition: HandyJSON {
    var aInt: Int?
    var comp1: Component?
    var comp2: Component?
}













