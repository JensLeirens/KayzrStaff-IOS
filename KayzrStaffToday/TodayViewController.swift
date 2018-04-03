//
//  TodayViewController.swift
//  KayzrStaffToday
//
//  Created by Jens Leirens on 05/12/2017.
//  Copyright © 2017 Jens Leirens. All rights reserved.
//

import UIKit
import NotificationCenter
import KayzrStaff_Shared

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var todayTournamentsTable: UITableView!
    
    var tournaments: [Tournament] = []
    var tournamentsToday :  [Tournament] = []
    private var tournamentTask: URLSessionTask?
    private let userDefaults = UserDefaults(suiteName: "group.KayzrStaffToday")!
    
    override func viewDidLoad() {
        var username : String?
      
        username = userDefaults.string(forKey: "username")
        
        if username != nil  {
            tournamentTask?.cancel()
            tournamentTask = KayzrStaffAPI.getTournamentsThisWeek() {
                self.tournaments = $0!
                
                self.tournaments = self.tournaments.filter(){
                    $0.moderator.range(of: username!) != nil
                }
                
                for t in self.tournaments {
                    switch t.day {
                    case "Maandag" :
                        if Date().dayNumberOfWeek() == 2 {
                            self.tournamentsToday.append(t)
                        }
                    case "Dinsdag" :
                        if Date().dayNumberOfWeek() == 3 {
                            self.tournamentsToday.append(t)
                        }
                    case "Woensdag" :
                        if Date().dayNumberOfWeek() == 4 {
                            self.tournamentsToday.append(t)
                        }
                    case "Donderdag" :
                        if Date().dayNumberOfWeek() == 5 {
                            self.tournamentsToday.append(t)
                        }
                    case "Vrijdag" :
                        if Date().dayNumberOfWeek() == 6 {
                            self.tournamentsToday.append(t)
                        }
                    case "Zaterdag" :
                        if Date().dayNumberOfWeek() == 7 {
                            self.tournamentsToday.append(t)
                        }
                    case "Zondag" :
                        if Date().dayNumberOfWeek() == 1 {
                            self.tournamentsToday.append(t)
                        }
                    default :
                        break
                    }
                    
                }
                if self.tournamentsToday.count == 0 {
                    self.tournamentsToday.append(Tournament(id: -1, name: "No Tournament Today!", nameShort: "NTT", day: "", date: "", hour: "", moderator: ""))
                }
                self.todayTournamentsTable.reloadData()
            }
            tournamentTask!.resume()
        } else {
            tournaments.append(Tournament(id: -1, name: "Log in the application first", nameShort: "", day: "", date: "", hour: "", moderator: ""))
        }
        
    }
    
}
extension TodayViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournamentsToday.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentTodayCell", for: indexPath) as! TournamentTodayCell
        cell.tournament = tournamentsToday[indexPath.row]
        return cell
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
