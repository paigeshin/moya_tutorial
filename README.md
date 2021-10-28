- UserService

```swift
//
//  UserService.swift
//  MoyaTutorial
//
//  Created by paige on 2021/10/29.
//

import Foundation
import Moya

struct User: Decodable {
    let id: Int
    let name: String
}

enum UserService {
    case createUser(name: String)
    case readUsers
    case updateUser(id: Int, name: String)
    case deleteUser(id: Int)
}

extension UserService: TargetType {
    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        switch self {
        case .readUsers, .createUser(_) :
            return "/users"
        case .updateUser(let id, _), .deleteUser(let id):
            return "/users/\(id)"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .createUser(_):
            return .post
        case .readUsers:
            return .get
        case .updateUser(_, _):
            return .put
        case .deleteUser(_):
            return .delete
        }
    }
    
    // Unit Test
    var sampleData: Data {
        switch self {
        case .createUser(let name):
            return "{'name':'\(name)'}".data(using: .utf8)!
        case .readUsers:
            return Data()
        case .updateUser(let id, let name):
            return "{'id':'\(id)','name':'\(name)'}".data(using: .utf8)!
        case .deleteUser(let id):
            return "{'id':'\(id)'}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .readUsers, .deleteUser(_):
            return .requestPlain
        case .createUser(let name), .updateUser(_, let name):
            return .requestParameters(parameters: ["name": name], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
```

- Main

```swift
//
//  ViewController.swift
//  MoyaTutorial
//
//  Created by paige on 2021/10/29.
//

import UIKit
import Moya

class ViewController: UIViewController {

    let userProvider = MoyaProvider<UserService>()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userProvider.request(.readUsers) { result in
            switch result {
            case .success(let response):
                let json = try! JSONSerialization.jsonObject(with: response.data, options: [])
                print(json)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func createUser() {
        let user = User(id: 55, name: "user1")
        userProvider.request(.createUser(name: user.name)) { result in
            switch result {
            case .success(let response):
                let newUser = try! JSONDecoder().decode(User.self, from: response.data)
                print(newUser)
                self.users.append(user)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUser(userId: Int, name: String) {
        userProvider.request(.updateUser(id: userId, name: name)) { result in
            switch result {
            case .success(let response):
                let modifiedUser = try! JSONDecoder().decode(User.self, from: response.data)
                print(modifiedUser)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteUser(userId: Int) {
        userProvider.request(.deleteUser(id: userId)) { result in
            switch result {
            case .success(let response):
                print("Delete: \(response)")
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
```
