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

