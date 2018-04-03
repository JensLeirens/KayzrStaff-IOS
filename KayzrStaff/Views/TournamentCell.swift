import UIKit
import KayzrStaff_Shared

class TournamentCell: UITableViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var moderatorLabel: UILabel?
    
    
    var tournament: Tournament! {
        didSet{
            dateLabel.text = tournament.day + " " + tournament.date
            
            if tournament.hour == "" {
                 startTimeLabel.text = "" 
            } else {
                startTimeLabel.text = "Begint om: " + tournament.hour
            }
            
            if tournament.moderator != "" {
                if tournament.moderator.contains(";") {
                    tournament.moderator = tournament.moderator.replacingOccurrences(of: ";", with: " & ")
                }
                moderatorLabel?.text = tournament.moderator
            } else {
                moderatorLabel?.text = "No moderator assigned"
            }
            
            if tournament.nameShort.contains("CS:GO"){
                gameImage.image = #imageLiteral(resourceName: "CSGO")
            } else if tournament.nameShort.contains("LoL"){
                gameImage.image = #imageLiteral(resourceName: "LOL")
            } else if tournament.nameShort.contains("RL") {
                gameImage.image = #imageLiteral(resourceName: "RL")
            } else if tournament.nameShort.contains("HS") {
                gameImage.image = #imageLiteral(resourceName: "HS")
            } else if tournament.nameShort.contains("FIFA") {
                gameImage.image = #imageLiteral(resourceName: "Fifa")
            } else if tournament.nameShort.contains("R6") {
                gameImage.image = #imageLiteral(resourceName: "R6")
            } else if tournament.nameShort.contains("SC II") {
                gameImage.image = #imageLiteral(resourceName: "SCII")
            } else if tournament.nameShort.contains("COD") {
                gameImage.image = #imageLiteral(resourceName: "COD")
            } else if tournament.nameShort.contains("BR") {
                gameImage.image = #imageLiteral(resourceName: "battlerite")
            } else if tournament.nameShort.contains("BH") {
                gameImage.image = #imageLiteral(resourceName: "brawlhalla")
            } else if tournament.nameShort.contains("Dota") {
                gameImage.image = #imageLiteral(resourceName: "dota")
            } else if tournament.nameShort.contains("OW") {
                gameImage.image = #imageLiteral(resourceName: "overwatch")
            } else {
                gameImage.image = #imageLiteral(resourceName: "icon")
            }
            
            if tournament.name.starts(with: "PS:") {
                tournament.name = String(tournament.name.dropFirst(4))
            } else if tournament.name.starts(with: "Fun:") {
                tournament.name = String(tournament.name.dropFirst(5))
            }
            nameLabel.text = tournament.name
        }
    }
    
}

