import UIKit
import WebKit
import RealmSwift

class NewsViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var isFavSaved: Bool = false
    var urlString: String?
    var newsTitle: String?
    var objectID: String?
    
    private let realm = try! Realm()

    private var favLinks: Results<Favorites>? {
        didSet {
            if (favLinks?.contains(where: {$0.objectID == objectID}))! {
                updatePin()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favLinks = realm.objects(Favorites.self)
                
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        
        loadWebView()
        
    }
    
    func updatePin() {
        DispatchQueue.main.async {
            self.pinButton.image = UIImage(systemName: self.isFavSaved ? "pin.fill" : "pin")
         }
         isFavSaved = !isFavSaved
    }
    
    //MARK: - webview
    
    func loadWebView() {
        if let safeUrl = urlString {
            if let url = URL(string: safeUrl) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
        DispatchQueue.main.async {
            self.backButton.isEnabled = false
            self.forwardButton.isEnabled = false
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.backButton.isEnabled = webView.canGoBack ? true: false
            self.forwardButton.isEnabled = webView.canGoForward ? true : false
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = true
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
             webView.goBack()
         }
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    //MARK: - Save favorite link
    @IBAction func pinButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: isFavSaved ? "Remove favorite" : "Add favorite", message: "", preferredStyle: .alert)
        
        let addFavAction = UIAlertAction(title: isFavSaved ? "Remove" : "Add", style: .default) { (action) in
            self.isFavSaved ? self.removeFavorite() : self.saveFavorite()
        }
        
        let caneclAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            return
        }
        
        alert.addAction(addFavAction)
        alert.addAction(caneclAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveFavorite() {
        let newFavorite = Favorites()
        newFavorite.url = urlString!
        newFavorite.title = newsTitle ?? "no title"
        newFavorite.objectID = objectID ?? "0"
        newFavorite.dateCreated = Date()
        do {
            try realm.write {
                realm.add(newFavorite)
            }
            updatePin()
        } catch {
            print(error)
        }
    }
    
    
    func removeFavorite() {
        if let item = favLinks?.first(where: {$0.objectID == objectID}) {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
                updatePin()
            } catch {
                print(error)
            }
        }
    }
    
    //MARK: - Scroll view
    private var lastContentOffset: CGFloat = 0

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        if lastContentOffset > scrollView.contentOffset.y && lastContentOffset < contentHeight {
            DispatchQueue.main.async {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }
        else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
            DispatchQueue.main.async {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
        lastContentOffset = scrollView.contentOffset.y
    }
    
    //MARK: - Page transition
    
    @IBAction func favButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToFav", sender: self)
    }

}


