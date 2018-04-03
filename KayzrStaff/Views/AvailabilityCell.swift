import UIKit

import KayzrStaff_Shared
class AvailabilityCell: UITableViewCell {
    @IBOutlet weak var tournamentNameLabel: UILabel!
    @IBOutlet weak var tournamentHourLabel: UILabel!
    @IBOutlet weak var tournamentAvailable: UISwitch!
    
    var availability : Availability! {
        didSet{
            tournamentHourLabel.text = availability.hour
            tournamentAvailable.isOn =  availability.available
            
            if availability.nameShort.starts(with: "PS:") {
                availability.nameShort = String(availability.nameShort.dropFirst(4))
            } else if availability.nameShort.starts(with: "Fun:") {
                availability.nameShort = String(availability.nameShort.dropFirst(5))
            }
            
            tournamentNameLabel.text = availability.nameShort
        }
    }
    @IBAction func switchChanged(_ sender: Any) {
        availability.available = tournamentAvailable.isOn
    }
    
}

