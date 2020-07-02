
import Foundation

class FetchNewsModel {
            
    func fetchData(with category: String, with queryInfo: String? = nil,_ completion: @escaping (Any?, Error?) -> ()) {
        
        var apiRequestOptions = UrlDictionary(with: category)
        
        if category == "Search" {
            if let searchQuery = queryInfo{
                apiRequestOptions.url = ("\(apiRequestOptions.url!)?q=\(searchQuery)")
            }
        }
    
        if let url = URL(string: apiRequestOptions.url!) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            if let requestHeader = apiRequestOptions.header {
                request.allHTTPHeaderFields = requestHeader as? [String : String]
            }
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { (data, res, error) in
                if let e = error { print(e) }
                    
                else {
                    switch category {
                        case NameConst.technology:
                            if let result = self.decodeTechData(with: data) {
                                DispatchQueue.main.async {
                                    completion(result.hits, nil)
                                }
                                return
                            }
                        case NameConst.finance:
                            if let result = self.decodeFinanceData(with: data) {
                                DispatchQueue.main.async {
                                    completion(result.items.result, nil)
                                }
                                return
                            }
                        case NameConst.search:
                            if let result = self.decodeSearchData(with: data) {
                                DispatchQueue.main.async {
                                    completion(result.articles, nil)
                                }
                                return
                        }
                        
                        default:
                            completion(nil, NameConst.noCategoryError as? Error)
                            return
                        }
                    return completion(nil, NameConst.decodeDataError as? Error)
                }
            }
            task.resume()
        }
    }
    
    func decodeTechData(with data: Data?) -> TechResponse? {
        let decoder = JSONDecoder()
        if let safeData = data {
            do {
                let decodedData = try decoder.decode(TechResponse.self, from: safeData)
                return decodedData
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    func decodeFinanceData(with data: Data?) -> FinancialResponse? {
        let decoder = JSONDecoder()
        if let safeData = data {
            do {
                let decodedData = try decoder.decode(FinancialResponse.self, from: safeData)
                return decodedData
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    
    func decodeSearchData(with data: Data?) -> SearchResponse? {
        let decoder = JSONDecoder()
        if let safeData = data {
            do {
                let decodedData = try decoder.decode(SearchResponse.self, from: safeData)
                return decodedData
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
     static let fetchNewsModel = FetchNewsModel()
}







