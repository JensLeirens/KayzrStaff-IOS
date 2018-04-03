
public class Availability: Tournament {
    public var available: Bool = false
    
    public init(available: Bool, id: Int, name: String, nameShort: String, day: String, date: String, hour: String,
                moderator: String) {
        self.available = available
        super.init(id: id, name: nameShort, nameShort: nameShort, day: day, date: date, hour: hour, moderator: moderator)
    }
    
}

