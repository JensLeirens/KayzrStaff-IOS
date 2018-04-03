import UIKit
import KayzrStaff_Shared
class ThisWeekDayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var day = ""
    var tournamentsToModerate: [Tournament]!
    var tournamentsThisDay: [Tournament] = []
    
    override func viewDidLoad() {
        for tournament in tournamentsToModerate {
            if day == tournament.day {
                tournamentsThisDay.append(tournament)
            }
        }
        
        title = day
    }
}
extension ThisWeekDayViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournamentsThisDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as! TournamentCell
        cell.tournament = tournamentsThisDay[indexPath.row]
        return cell
    }
}
