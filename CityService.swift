import Foundation
protocol ServiceDelegate {
    func ServiceDelegateDidFinishWithList(list : [String])

}
class Service {

    static var shared = Service()
    
    var delegate : ServiceDelegate?

        func fetchJSONData(searchText:String)  {

    
                let url = URL(string: "http://gd.geobytes.com/AutoCompleteCity?q=\(searchText)")!
          
                        print(url)
        
                       let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                           
                          
                           if let error = error {
                                print("error in url session")
                               print(error)
                               return
                           }
                           
                           // We want to ensure that we have a good HTTP response status
                           guard let httpResponse = response as? HTTPURLResponse,
                               (200...299).contains(httpResponse.statusCode)
                               else {
                                   // Show the URL and response status code in the debug console
                                   if let httpResponse = response as? HTTPURLResponse {
                                       print("URL: \(httpResponse.url!.path )\nStatus code: \(httpResponse.statusCode)")
                                   }
                                   return
                           }
                         
                               if let data = data {
                               
                               // Create and configure a JSON decoder
                               let decoder = JSONDecoder()
                               decoder.dateDecodingStrategy = .iso8601
                        
                               do {
                                
                                   let result = try decoder.decode([String].self, from: data)
                                self.delegate?.ServiceDelegateDidFinishWithList(list : result)

                                   // Diagnostic
                                print("result in url session")
                                print(result)
                               
                                   // Save the data (in memory)
                              //  completionHandler(result)

                                   // Then reload the table view; must be done this way
                                   
                               }
                               catch {
                                    print("error exception in url session")
                                print(error)
                               }
                           }
                       }
                       
                       // Now that "task" has been fully defined, execute it...
                       task.resume()
                  
            }
        
    }
