//
//  KayzrStaffAPI.swift
//  KayzrStaff_Shared
//
//  Created by Jens Leirens on 08/12/2017.
//  Copyright © 2017 Jens Leirens. All rights reserved.
//

import Foundation
import RealmSwift

public enum KayzrStaffAPI {
    private static let session = URLSession(configuration: .ephemeral)
    
    public static func getAllUsers(completion: @escaping ([User]?) -> Void) -> URLSessionTask {
         let url = URL(string: "http://kayzrstaff.com/api/users/")!
        return session.dataTask(with: url){
            data, response, error in
            let completion: ([User]?) -> Void = {
                users in
                DispatchQueue.main.async {
                    completion(users)
                }
            }
            // status 200 = ok, when there is no data escape
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data else {
                    completion(nil)
                    return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data),
                let json = result as? [[String: Any]] else {
                    completion(nil)
                    return
            }
            
            var users: [User] = []
            for i in 0 ... json.count - 1  {
                let tempUser = json[i]
                users.append(User(userId: (tempUser["id"] as! NSNumber).intValue,
                                  username: tempUser["username"] as! String,
                                  fullname: tempUser["fullname"] as? String ?? "",
                                  password: "",
                                  phonenumber: tempUser["gsm"] as? String ?? "",
                                  role: .Mod))
            }
            completion(users)
        }
        
    }
    
    public static func getUser(for loginUser: String, completion: @escaping (User?) -> Void) -> URLSessionTask {
        let url = URL(string: "http://kayzrstaff.com/api/users/?user=\(loginUser)")!
        return session.dataTask(with: url){
            data, response, error in
            let completion: (User?) -> Void = {
                user in
                DispatchQueue.main.async {
                    completion(user)
                }
            }
            // status 200 = ok, when there is no data escape
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data else {
                    completion(nil)
                    return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data),
                let json = result as? [String: Any] else {
                    completion(nil)
                    return
            }
            
            var user = User()
        
            var role : User.Role
            switch json["role"] as? String ?? "Mod" {
            case "Mod":
                role = User.Role.Mod
            case "CM":
                role = User.Role.CM
            default:
                role = User.Role.Mod
            }
            user = User(userId: (json["id"] as? NSNumber)!.intValue,
                        username: (json["username"] as? String)!,
                        fullname: json["fullname"] as? String ?? "",
                        password: json["password"] as? String ?? "",
                        phonenumber: json["gsm"] as? String ?? "",
                        role: role)
            print(" username " + user.username)
            completion(user)
        }
        
    }
    
    public static func getTournamentsThisWeek(completion: @escaping ([Tournament]?) -> Void) -> URLSessionTask {
        let url = URL(string: "http://kayzrstaff.com/api/thisweek/")!
        return session.dataTask(with: url){
            data, response, error in
            let completion: ([Tournament]?) -> Void = {
                tournaments in
                DispatchQueue.main.async {
                    completion(tournaments)
                }
            }
            // status 200 = ok, when there is no data escape
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data else {
                    completion(nil)
                    return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data),
                let json = result as? [[String: Any]] else {
                    completion(nil)
                    return
            }
            var tournaments: [Tournament] = []
            for i in 0 ... json.count - 1  {
                let tempTournament = json[i]
                tournaments.append(Tournament(id: (tempTournament["id"] as! NSNumber).intValue ,
                                              name: tempTournament["naam"] as! String,
                                              nameShort: tempTournament["naamkort"] as! String,
                                              day: tempTournament["dag"] as! String,
                                              date: tempTournament["datum"] as! String,
                                              hour: tempTournament["uur"] as! String,
                                              moderator: tempTournament["moderator"] as? String ?? "No moderator assigned"))
            }
            completion(tournaments)
        }
        
    }
    
    public static func getAvailabilities(completion: @escaping ([Availability]?) -> Void) -> URLSessionTask {
        let url = URL(string: "http://kayzrstaff.com/api/availabilities/")!
        return session.dataTask(with: url){
            data, response, error in
            let completion: ([Availability]?) -> Void = {
                availabilities in
                DispatchQueue.main.async {
                    completion(availabilities)
                }
            }
            // status 200 = ok, when there is no data escape
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data else {
                    completion(nil)
                    return
            }
            guard let result = try? JSONSerialization.jsonObject(with: data),
                let json = result as? [[String: Any]] else {
                    completion(nil)
                    return
            }
            var availabilities: [Availability] = []
            for i in 0 ... json.count - 1  {
                let tempAv = json[i]
                availabilities.append(Availability(available: false,
                                                   id: (tempAv["tournamentId"] as! NSNumber).intValue,
                                                   name: "", nameShort: "", day: "", date: "", hour: "",
                                                   moderator: tempAv["user"] as! String))
            }
            completion(availabilities)
        }
        
    }
    
    public static func saveUser(for user: User) {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
            realm.add(user)
        }
        print("saved user \(user.username)")
    }
    
    public static func getLocalUser() -> User? {
        var savedUser : Results<User>?
        savedUser = try! Realm().objects(User.self)
        print("hereeeeeee")
        
        return savedUser?.first
    }
}
