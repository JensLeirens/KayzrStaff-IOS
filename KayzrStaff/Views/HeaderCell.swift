import UIKit

class HeaderDayCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    
    var day : String! {
        didSet{
            dayLabel.text = day
            
        }
    }
}

