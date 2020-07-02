import UIKit

class CategoryViewController: UIViewController {
    
    var selectedCategory: String?
    var textField = UITextField()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var techButton: UIButton!
    @IBOutlet weak var financeButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadUI()
        splashAnimation()
    }
    
    func loadUI() {
        techButton.layer.cornerRadius = 5
        techButton.layer.shadowColor = UIColor.black.cgColor
        techButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        techButton.layer.shadowRadius = 5
        techButton.layer.shadowOpacity = 0.3
        
        financeButton.layer.cornerRadius = 5
        financeButton.layer.shadowColor = UIColor.black.cgColor
        financeButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        financeButton.layer.shadowRadius = 5
        financeButton.layer.shadowOpacity = 0.3
        
        searchButton.layer.cornerRadius = 5
        searchButton.layer.shadowColor = UIColor.black.cgColor
        searchButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        searchButton.layer.shadowRadius = 5
        searchButton.layer.shadowOpacity = 0.3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewsTable" {
            let destinationVC = segue.destination as! NewsTableViewController
        
            destinationVC.category = selectedCategory ?? NameConst.technology
            destinationVC.seatchInfo = textField.text
        }
    }
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        
        selectedCategory = sender.titleLabel?.text
        
        if selectedCategory == "Search" {
            
            let alert = UIAlertController(title: "Please enter your interest", message: "", preferredStyle: .alert)
            // Add text field
            alert.addTextField { (alertTextfield) in
                alertTextfield.placeholder = "Search topic"
                // Alert alertTextfield is local variable, hence put into textfield which is global
                self.textField = alertTextfield
            }
            
            // Create action for alert
            let addSearchAction = UIAlertAction(title: "Search", style: .default) { (action) in
                if !(self.textField.text!.trimmingCharacters(in: .whitespaces).isEmpty) {
                    self.performSegue(withIdentifier: "goToNewsTable", sender: self)
                }
                return
            }
            
            alert.addAction(addSearchAction)
            present(alert, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "goToNewsTable", sender: self)
        }
    }
    
    @IBAction func favButtonPressed(_ sender: UIBarButtonItem) {
        print("pressed")
        self.performSegue(withIdentifier: "goToFav", sender: self)
    }
    
}

extension CategoryViewController {
    func splashAnimation() {
        var charIndex: Double = 0.0
        let titleText: String = "NewsFeed⚡️"
        self.titleLabel.text = ""
        
        for letter in titleText {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + charIndex) {
                self.titleLabel.text?.append(letter)
            }
            charIndex += 0.1
        }
    }
}
