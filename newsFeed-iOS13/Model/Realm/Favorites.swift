import Foundation
import RealmSwift

class Favorites: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var objectID: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var dateCreated: Date?    
}
