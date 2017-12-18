import UIKit
import KayzrStaff_Shared

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var tournamentTask: URLSessionTask?
    var user: User!
    var tournamentsToModerate: [Tournament] = []
 
    override func viewDidLoad() {
        tournamentTask?.cancel()
        tournamentTask = KayzrStaffAPI.getTournamentsThisWeek() {
            self.tournamentsToModerate = $0!
            
            self.tournamentsToModerate = self.tournamentsToModerate.filter(){
                $0.moderator == self.user.username
            }
            
            if self.tournamentsToModerate.count == 0 {
               self.tournamentsToModerate.append(Tournament(id: -1, name: "No tournaments assigned!", nameShort: "NTA", day: "", date: "", hour: "", moderator: "-"))
            }
            
            self.tableView.reloadData()
        }
        tournamentTask!.resume()
    }
}
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tournamentsToModerate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tournamentCell", for: indexPath) as! TournamentCell
        cell.tournament = tournamentsToModerate[indexPath.row]
        return cell
    }
}
