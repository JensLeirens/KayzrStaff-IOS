
public class Tournament {
    public var id : Int
    public var name: String
    public var nameShort: String
    public var day: String
    public var date: String
    public var hour: String
    public var moderator: String // hier mss een Usertype van maken en dan string mappen naar user
    
    public init(id: Int, name: String, nameShort: String, day: String, date: String, hour: String, moderator: String) {
        self.id = id
        self.name = name
        self.nameShort = nameShort
        self.day = day
        self.date = date
        self.hour = hour
        self.moderator = moderator
    }
    
    
}

