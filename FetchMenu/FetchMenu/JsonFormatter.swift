import Foundation

class JsonFormatter {
    func parse(url: String, ext: String, completion: (([Dessert]) -> Void)?) {
        guard let theUrl = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: theUrl) { (data, response, error) in
            if let error = error {
                print("Error loading data: \(error)")
                completion?([])
                return
            }
            
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(DessertList.self, from: data)
                    completion?(results.meals)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion?([])
                }
            }
        }
        
        task.resume()
    }
    
    func getMealInfo(url: String, ext: String, completion: (([DessertMeal]) -> Void)?) {
        guard let theUrl = URL(string: url+ext)else{
            return
        }
        let task = URLSession.shared.dataTask(with: theUrl) { (data, response, error) in
            if let error = error {
                print("Error loading data: \(error)")
                completion?([])
                return
            }
            
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(MealInfo.self, from: data)
                    completion?(results.meals)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion?([])
                }
            }
        }
        
        task.resume()
    }
}

