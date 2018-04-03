import UIKit
import RealmSwift
import KayzrStaff_Shared
import CryptoSwift

class LoginUserViewController : UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var userTask: URLSessionTask?
    private let userDefaults = UserDefaults(suiteName: "group.KayzrStaffToday")!
    
    var team : [User]!
    var savedUser : Results<User>?
    var user : User?
    var decryptedPassword = ""
    
    override func viewDidLoad() {
        savedUser = try! Realm().objects(User.self)
        usernameField.text = savedUser?.first?.username
        passwordField.text = savedUser?.first?.password
        if  savedUser?.first != nil {
            getTheUser(username: savedUser!.first!.username, checkuser: false)
        }
        usernameField.becomeFirstResponder()
        loginButton.layer.cornerRadius = 5
    }
    
    @IBAction func logUserIn() {
        getTheUser(username: usernameField.text!, checkuser: true)
       
    }
    
    @IBAction func moveFocusToPassword() {
        usernameField.resignFirstResponder()
        passwordField.becomeFirstResponder()
    }
    
    
    
    private func getTheUser(username: String, checkuser: Bool) {
        userTask?.cancel()
        userTask = KayzrStaffAPI.getUser(for: username ) {
            self.user = $0
            if checkuser {
                self.checkUserAndPerformSegue()
            }
            
        }
        userTask!.resume()
    }
    
    private func checkUserAndPerformSegue(){
        if user == nil  {
            let alert = UIAlertController(title: "User Not found", message: "We did not find user: \(usernameField.text ?? "")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            if passwordField.text! == user!.password {
                //pasword was already encrypted
                performSegue(withIdentifier: "MainAppSegue", sender: self)
                
            } else {
                // Source: https://github.com/krzyzanowskim/CryptoSwift to encrypt the password which is added in the podfile
                decryptedPassword = passwordField.text!.sha256()
                
                if decryptedPassword == user!.password {
                    //user is valid
                    // the user can now continue because the user var is now the logged in user
                    performSegue(withIdentifier: "MainAppSegue", sender: self)
                } else {
                    let alert = UIAlertController(title: "Password not correct", message: "The password for user \(user!.username) was not correct. Please try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "MainAppSegue" else {
            fatalError("Unknown Segue")
        }
        let destination = ((segue.destination as! UITabBarController).viewControllers![0] as! UINavigationController).topViewController as! HomeViewController
        destination.user = user!
        
        let realm = try! Realm()
        try! realm.write {
            // this is temp because the plan is to store more then just the logged in user
            realm.deleteAll()
            realm.add(user!)
        }
       
        userDefaults.set(user!.username, forKey: "username")
    }
    
    
}

