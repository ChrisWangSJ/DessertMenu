//
//  ViewController.swift
//  FetchMenu
//
//  Created by Chenyu Yan on 6/3/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UITextFieldDelegate  {
    
    @IBOutlet weak var dessertCollectionView: UICollectionView!
    @IBOutlet weak var dessertImageL: UIImageView!
    @IBOutlet weak var dessertNameV: UILabel!
    @IBOutlet weak var Ingredients: UITextView!
    @IBOutlet weak var SearchTestField: UITextField!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var Instructions: UITextView!
    var dessertMenu: [Dessert] = []
    var dessert: Dessert?
    
    var dessertMeal: [DessertMeal] = []
    var dessertM: DessertMeal?
    
    var idString: String = "52768"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dessertCollectionView.delegate = self
        dessertCollectionView.dataSource = self
        //Instructions.adjustsFontSizeToFitWidth = true
        Ingredients.isEditable = false
        Ingredients.isScrollEnabled = true
        Ingredients.showsVerticalScrollIndicator = true
        
        Instructions.isEditable = false
        Instructions.isScrollEnabled = true
        Instructions.showsVerticalScrollIndicator = true
        SearchTestField.delegate = self
        
            
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 134)
        layout.scrollDirection = .vertical
        //layout.minimumLineSpacing = 30
        dessertCollectionView.collectionViewLayout = layout
        
        JsonFormatter().parse(url: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert", ext: "json"){ (dessertMenu) in
            self.dessertMenu = dessertMenu
            self.dessertCollectionView.reloadData()
            self.dessert = self.dessertMenu.first
            self.idString = self.dessert!.idMeal
            self.setupMenu()
            
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            
        SearchTestField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func SearchB(_ sender: UIButton) {
        idString = SearchTestField.text!
        print(idString)
        JsonFormatter().getMealInfo(url: "https://themealdb.com/api/json/v1/1/lookup.php?i=", ext: SearchTestField.text!){ (dessertMeal) in
            
            self.dessertMeal = dessertMeal
            self.dessertM = self.dessertMeal.first
            self.Instructions.text = self.dessertM?.strInstructions
            self.dessertNameV.text = self.dessertM?.strMeal
            self.dessertImageL.loadFrom((self.dessertM?.strMealThumb)!)
            
            var ingredientsText = ""

            if let dessertMeal = self.dessertM {
                let ingredients = Mirror(reflecting: dessertMeal).children.filter { $0.label?.hasPrefix("strIngredient") ?? false }
                let measures = Mirror(reflecting: dessertMeal).children.filter { $0.label?.hasPrefix("strMeasure") ?? false }
                
                for (ingredient, measure) in zip(ingredients, measures) {
                    if let ingredientValue = ingredient.value as? String,
                       let measureValue = measure.value as? String,
                       !ingredientValue.isEmpty {
                        let ingredientLine = "\(ingredientValue): \(measureValue)\n"
                        ingredientsText += ingredientLine
                    }
                }
            }

            let finalText = ingredientsText

            self.Ingredients.text = finalText
            
        }
    }
    
    
    func setupMeal(){
        guard let selected = dessertM else { return }
        Instructions.text = selected.strInstructions
    }
    
    func setupMenu() {
        guard let selected = dessert else { return }
        let mealName = selected.strMeal
        dessertNameV.text = mealName
        idString = selected.idMeal
        dessertImageL.loadFrom(selected.strMealThumb)
        
        JsonFormatter().getMealInfo(url: "https://themealdb.com/api/json/v1/1/lookup.php?i=", ext: idString){ (dessertMeal) in
            self.dessertMeal = dessertMeal
            self.dessertM = self.dessertMeal.first
            self.Instructions.text = self.dessertM?.strInstructions

            var ingredientsText = ""

            if let dessertMeal = self.dessertM {
                let ingredients = Mirror(reflecting: dessertMeal).children.filter { $0.label?.hasPrefix("strIngredient") ?? false }
                let measures = Mirror(reflecting: dessertMeal).children.filter { $0.label?.hasPrefix("strMeasure") ?? false }
                
                for (ingredient, measure) in zip(ingredients, measures) {
                    if let ingredientValue = ingredient.value as? String,
                       let measureValue = measure.value as? String,
                       !ingredientValue.isEmpty {
                        let ingredientLine = "\(ingredientValue): \(measureValue)\n"
                        ingredientsText += ingredientLine
                    }
                }
            }

            let finalText = ingredientsText

            self.Ingredients.text = finalText

        }
    }
    
    
    
    
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(dessertMenu.count)
        return dessertMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dessert = dessertMenu[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DessertCell", for: indexPath) as! CollectionCell
        cell.urlString = dessert.strMealThumb
        cell.nameStr = dessert.strMeal
        cell.idStr = dessert.idMeal
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dessert = dessertMenu[indexPath.item]
        self.idString = dessert!.idMeal
        print(idString)
        setupMenu()
        
    }
}


