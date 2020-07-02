import UIKit
import RealmSwift

class FavoriteItemsTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var savedFavs: Results<Favorites>?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
    }
        
    func loadItems() {
        savedFavs = realm.objects(Favorites.self).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFavs?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        
        cell.textLabel?.text = savedFavs?[indexPath.row].title ?? ""
        
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNews" {
            let destination = segue.destination as! NewsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                if let url = savedFavs?[indexPath.row].url {
                    destination.urlString = url
                }
                if let title = savedFavs?[indexPath.row].title {
                    destination.newsTitle = title
                }
                if let objcId = savedFavs?[indexPath.row].objectID {
                    destination.objectID = objcId
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNews", sender: self)
    }


}
