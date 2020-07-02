import Foundation

struct UrlDictionary {
    
    let category: String
    var url: String?
    let header: Any?
    
    init(with categoryName: String) {
        self.category = categoryName
        self.url = urlDictionary[category]?["url"] as? String
        self.header = urlDictionary[category]?["header"]!
    }
    
    private let urlDictionary = [
        "Technology" : [
            "url": "https://hn.algolia.com/api/v1/search?tags=front_page",
            "header": nil,
        ],
        "Finance": [
            "url": "https://apidojo-yahoo-finance-v1.p.rapidapi.com/news/list?category=generalnews&region=US",
            "header": [
                "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com",
                "x-rapidapi-key": "f7c1b85ca9msh05c5acc9e50b3c3p15d91djsnde214bbb84e5"
            ],
        ],
        "Search": [
            "url": "https://newsapi.org/v2/everything",
            "header": [
                "X-Api-Key": "ca7e6b70f29e4c94a88d8241c6afe8f6"
            ],
        ]
    ]
}

struct TechResponse: Decodable {
    let hits: [Post]
    
    struct Post: Decodable {
        var id: String? {
            return objectID
        }
        let objectID: String?
        let points: Int?
        let title: String?
        let url: String?
    }
}

struct FinancialResponse: Decodable {
    let items: FResult
    
    struct FResult: Decodable {
        let result: [FinancialPosts]
    }

    struct FinancialPosts: Decodable {
        let title: String?
        let link: String?
        let uuid: String?
    }
}

struct SearchResponse: Decodable {
    let articles: [SearchPosts]
    
    struct SearchPosts: Decodable {
        let title: String?
        let url: String?
    }
}



