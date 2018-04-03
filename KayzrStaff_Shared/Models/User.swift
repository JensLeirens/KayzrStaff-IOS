import RealmSwift
public class User: Object {
     @objc dynamic public var userId: Int = -1
     @objc dynamic public var username: String = ""
     @objc dynamic public var fullname: String = ""
     @objc dynamic public var password: String = ""
     @objc dynamic public var phonenumber: String = ""

    
    public enum Role : String{
        
        case CM = "CM"
        case Mod = "Mod"
        case Admin = "Admin"
        
        static let roles: [Role] = [Role.CM, .Mod, .Admin]
    }
    @objc dynamic var roleRaw = ""
    public var role : Role {
        get {
            return Role(rawValue: roleRaw) ?? .Mod
        } set {
            roleRaw = newValue.rawValue
        }
    }
    
     public convenience init(userId: Int, username: String, fullname: String, password: String, phonenumber: String, role: Role) {
        self.init()
        self.userId = userId
        self.username = username
        self.fullname = fullname
        self.password = password
        self.phonenumber = phonenumber
        self.role = role
    }
}

