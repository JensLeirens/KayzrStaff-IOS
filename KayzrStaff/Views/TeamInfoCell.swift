import UIKit
import KayzrStaff_Shared

class TeamInfoCell : UITableViewCell {
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    var user : User! {
        didSet{
            callButton.layer.cornerRadius = 10
            nickNameLabel.text = user.username
            fullNameLabel.text = user.fullname
            phoneNumberLabel.text = " - " + user.phonenumber
        }
    }
    
    @IBAction func callTeamMember(){
        if let url = URL(string: "telprompt://\(user.phonenumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

