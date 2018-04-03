import UIKit
import KayzrStaff_Shared
import RealmSwift
import Alamofire

class AvailabilityViewController : UIViewController {
    @IBOutlet weak var availabiltyTable: UITableView!
    @IBOutlet weak var sendAvailabilitiesButton: UIBarButtonItem!
    
    private var tournamentsTask: URLSessionTask?
    private var availabilitiesTask: URLSessionTask?
    private var clearAvailabiltiesTask: URLSessionTask?
    private var sendAvailabilitiesTask: URLSessionTask?
    
    var availabilitiesToAssign : [Availability]!
    var availabiltiesOfTheUser: [Availability]?
    var savedUser : Results<User>?
    var gotAvailabilities = false
    var gotTournaments = false
    var tournaments : [Tournament] = []
    var availabilitiesForDay = [Int : [Availability]]()
    var availabilitiesSend = 0
    
    override func viewDidLoad() {
        // eerst de user uit de realm gaan halen
        savedUser = try! Realm().objects(User.self)
        // daarna de availabilities van de users gaan ophalen
        // deze filteren voor juist deze user
        availabilitiesTask?.cancel()
        availabilitiesTask = KayzrStaffAPI.getAvailabilities(){
            self.availabiltiesOfTheUser = $0
            self.availabiltiesOfTheUser = self.availabiltiesOfTheUser?.filter(){
                $0.moderator == self.savedUser!.first!.username
            }
            // van zodra ik de availabilities en de tournaments heb kan ik deze controleren en toevoegen
            self.gotAvailabilities = true
            self.calculateAvailabilities()
        }
        availabilitiesTask?.resume()
        tournamentsTask?.cancel()
        tournamentsTask = KayzrStaffAPI.getTournamentsThisWeek() {
            self.tournaments = $0!
            self.gotTournaments = true
            self.calculateAvailabilities()
            
        }
        tournamentsTask!.resume()
    }
    
    @IBAction func sendAvailabilities() {
        availabilitiesSend = 0
        var avToSend : [Availability] = []
        for i in 0 ... 6 {
            for av in availabilitiesForDay[i]! {
                if av.available{
                    avToSend.append(av)
                }
            }
        }
        
        Alamofire.request("http://kayzrstaff.com/api/ClearAV/?user=\(savedUser!.first!.username)&key=8w03QQ2ByD6vxZEPSBjPJR89SeQhoR8C", method: .get).response {_ in
            for av in avToSend {
                Alamofire.request("http://kayzrstaff.com/api/SendAV/?user=\(self.savedUser!.first!.username)&id=\(av.id)&key=8w03QQ2ByD6vxZEPSBjPJR89SeQhoR8C", method: .get).response{ _ in
                    self.availabilitiesSend += 1
                    if self.availabilitiesSend == avToSend.count {
                        let alert = UIAlertController(title: "Availabilities send",
                                                      message: "\(self.availabilitiesSend) / \(avToSend.count) " +
                            "\(avToSend.count > 1 ? "availabilities have" : "availability has") been sent.",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
            
            if self.availabilitiesSend == 0 && avToSend.count == 0{
                let alert = UIAlertController(title: "Availabilities send",
                                              message: "no availabilities have been sent!",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        
        tabBarController?.selectedIndex = 0
    }
    
    func calculateAvailabilities(){
        if gotTournaments && gotAvailabilities {
            self.availabilitiesToAssign = []
            //  adding the tournaments to the availabilities
            for t in tournaments {
                availabilitiesToAssign.append(Availability(available: false, id: t.id, name: t.name, nameShort: t.nameShort, day: t.day, date: t.date, hour: t.hour, moderator: ""))
            }
            // checking if the user already set his availabilities
            // then set the available to true
            // after that we add the availabilities to our dictionary of days
            for availability in self.availabilitiesToAssign {
                
                if (self.availabiltiesOfTheUser?.count ?? 0 ) > 0  {
                    if self.availabiltiesOfTheUser!.contains(where: { $0.id == availability.id }){
                        availability.available = true
                    }
                }
                switch availability.day {
                case "Maandag":
                    if let _ = self.availabilitiesForDay[0] {
                        self.availabilitiesForDay[0]!.append(availability)
                    } else {
                        self.availabilitiesForDay[0] = [availability]
                    }
                case "Dinsdag":
                    if let _ = self.availabilitiesForDay[1] {
                        self.availabilitiesForDay[1]!.append(availability)
                    } else {
                        self.availabilitiesForDay[1] = [availability]
                    }
                case "Woensdag":
                    if let _ = self.availabilitiesForDay[2] {
                        self.availabilitiesForDay[2]!.append(availability)
                    } else {
                        self.availabilitiesForDay[2] = [availability]
                    }
                case "Donderdag":
                    if let _ = self.availabilitiesForDay[3] {
                        self.availabilitiesForDay[3]!.append(availability)
                    } else {
                        self.availabilitiesForDay[3] = [availability]
                    }
                case "Vrijdag":
                    if let _ = self.availabilitiesForDay[4] {
                        self.availabilitiesForDay[4]!.append(availability)
                    } else {
                        self.availabilitiesForDay[4] = [availability]
                    }
                case "Zaterdag":
                    if let _ = self.availabilitiesForDay[5] {
                        self.availabilitiesForDay[5]!.append(availability)
                    } else {
                        self.availabilitiesForDay[5] = [availability]
                    }
                case "Zondag":
                    if let _ = self.availabilitiesForDay[6] {
                        self.availabilitiesForDay[6]!.append(availability)
                    } else {
                        self.availabilitiesForDay[6] = [availability]
                    }
                default:
                    break
                }
            }
            self.availabiltyTable.reloadData()
        }
        
    }
    
}

extension AvailabilityViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // amount of days
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // amount of rows for param section return int
        return availabilitiesForDay[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // return a vaible cell for that Indexpath.section and indexpath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "availabilityCell", for: indexPath) as! AvailabilityCell
        cell.availability = availabilitiesForDay[indexPath.section]![indexPath.row]
        //cell.tournamentAvailable.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
        return cell
    }
}
extension AvailabilityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell") as! HeaderDayCell
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        
        
        
        switch section {
        case 0:
            cell.day = " Maandag " + formatter.string(from: date.maandag!)
        case 1:
            cell.day = "Dinsdag " + formatter.string(from: date.dinsdag!)
        case 2:
            cell.day = "Woensdag " + formatter.string(from: date.woensdag!)
        case 3:
            cell.day = "Donderdag " + formatter.string(from: date.donderdag!)
        case 4:
            cell.day = "Vrijdag " + formatter.string(from: date.vrijdag!)
        case 5:
            cell.day = "Zaterdag " + formatter.string(from: date.zaterdag!)
        case 6:
            cell.day = "Zondag " +  formatter.string(from: date.zondag!)
        default:
            break
        }
        return cell
    }
}
extension Date {
    // Source: https://stackoverflow.com/questions/33397101/how-to-get-mondays-date-of-the-current-week-in-swift
    // ik heb het wel aangepast en uitgebreid zodat ik elke dag van de volgende week krijg
    public var maandag: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 8, to: sunday)
    }
    public var dinsdag: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 9, to: sunday)
    }
    public var woensdag: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 10, to: sunday)
    }
    public var donderdag: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 11, to: sunday)
    }
    public var vrijdag: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 12, to: sunday)
    }
    public var zaterdag: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 13, to: sunday)
    }
    public var zondag: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 14, to: sunday)
    }
}


