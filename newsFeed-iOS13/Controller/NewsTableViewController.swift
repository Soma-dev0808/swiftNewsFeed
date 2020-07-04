import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberOfViews: UILabel!
    @IBOutlet weak var contentTitle: UILabel!
    
}

class NewsTableViewController: UITableViewController {
    
    private var indicator = UIActivityIndicatorView()
    
    var seatchInfo: String?
    
    var category: String = "" {
        didSet {
            loadNewsLinks()
        }
    }
    
    private var techPosts: [TechResponse.Post] = [] {
        didSet {
            loadTable()
        }
    }
    
    private var financePost: [FinancialResponse.FinancialPosts] = [] {
        didSet {
            loadTable()
        }
    }
    
    private var searchPost: [SearchResponse.SearchPosts] = [] {
        didSet {
            loadTable()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadNewsLinks() {
        
        callLoadIndicator()
        
        let fetchNewsModel = FetchNewsModel.fetchNewsModel
        
        DispatchQueue.main.async {
            fetchNewsModel.fetchData(with: self.category, with: self.seatchInfo) { (result, error) in
                if error != nil {
                    print(error!)
                    self.alertError()
                }
            
                self.stopLoadIndicator()
                
                if let res = result {
                    
                    switch self.category {
                        case NameConst.technology:
                            return self.techPosts = res as! [TechResponse.Post]
                        case NameConst.finance:
                            return self.financePost = res as! [FinancialResponse.FinancialPosts]
                        case NameConst.search:
                            return self.searchPost = res as! [SearchResponse.SearchPosts]
                        default:
                            print(NameConst.noCategoryError)
                            return
                    }
                }
                
                print(NameConst.fetchDataError)
                self.alertError()
                return
            }
        }

    }
    
    func callLoadIndicator() {

        func activityIndicator() {
            indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            indicator.style = UIActivityIndicatorView.Style.medium
            indicator.center = self.view.center
            self.view.addSubview(indicator)
        }
        
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = .white
    }
    
    func stopLoadIndicator() {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    
    func loadTable() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.category {
            case NameConst.technology:
                return techPosts.count
            case NameConst.finance:
                return financePost.count
            case NameConst.search:
                return searchPost.count
            default:
                print(NameConst.noCategoryError)
                return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        
        cell.numberOfViews.adjustsFontSizeToFitWidth = true
        cell.contentTitle?.numberOfLines = 0
                
        var configuredCell: NewsTableViewCell
        
        switch self.category {
            case NameConst.technology:
                configuredCell = configTechCell(cell, indexPath)
            case NameConst.finance:
                configuredCell = configFinanceCell(cell, indexPath)
            case NameConst.search:
                configuredCell = configSearchCell(cell, indexPath)
            default:
                print(NameConst.noCategoryError)
                return cell
        }
                
        return configuredCell
    }
    
    func configTechCell(_ cell: NewsTableViewCell, _ indexPath: IndexPath) -> NewsTableViewCell {
        cell.numberOfViews?.text = String(techPosts[indexPath.row].points ?? 0)
        cell.contentTitle?.text = techPosts[indexPath.row].title ?? "no title"
        return cell
    }
    
    func configFinanceCell(_ cell: NewsTableViewCell, _ indexPath: IndexPath) -> NewsTableViewCell {
        cell.numberOfViews.isHidden = true
        cell.contentTitle?.text = financePost[indexPath.row].title ?? "no title"
        return cell
    }
    
    func configSearchCell(_ cell: NewsTableViewCell, _ indexPath: IndexPath) -> NewsTableViewCell {
        cell.numberOfViews.isHidden = true
        cell.contentTitle?.text = searchPost[indexPath.row].title ?? "no title"
        return cell
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNews" {
            let destination = segue.destination as! NewsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                switch self.category {
                    case NameConst.technology:
                        configTechDestination(destination, indexPath)
                    case NameConst.finance:
                        configFinanceDestination(destination, indexPath)
                    case NameConst.search:
                        configSearchDestination(destination, indexPath)
                    default:
                        print(NameConst.noCategoryError)
                }
            }
        }
    }
    
    func configTechDestination(_ destination: NewsViewController,_ indexPath: IndexPath) {
        if let url = techPosts[indexPath.row].url {
            destination.urlString = url
        }
        if let title = techPosts[indexPath.row].title {
            destination.newsTitle = title
        }
        if let objcId = techPosts[indexPath.row].objectID {
            destination.objectID = objcId
        }
    }
    
    func configFinanceDestination(_ destination: NewsViewController,_ indexPath: IndexPath) {
        if let url = financePost[indexPath.row].link {
            destination.urlString = url
        }
        if let title = financePost[indexPath.row].title {
            destination.newsTitle = title
        }
        if let objcId = financePost[indexPath.row].uuid {
            destination.objectID = objcId
        }
    }
    
    func configSearchDestination(_ destination: NewsViewController,_ indexPath: IndexPath) {
        if let url = searchPost[indexPath.row].url {
            destination.urlString = url
        }
        if let title = searchPost[indexPath.row].title {
            destination.newsTitle = title
        }
        
        destination.objectID = randomString(length: 8)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNews", sender: self)
    }

    @IBAction func favButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToFav", sender: self)
    }
    
    //MARK: - error handling
    func alertError() {
        // Create alert UI
        let alert = UIAlertController(title: "Unexpected error occured", message: "Was not able to load news list please try again it", preferredStyle: .alert)
        

        // Create action for alert
        let addItemAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }

        
        // Add ation to alert pop up
        alert.addAction(addItemAction)
        
        // Activate alert
        present(alert, animated: true, completion: nil)
    }
}

