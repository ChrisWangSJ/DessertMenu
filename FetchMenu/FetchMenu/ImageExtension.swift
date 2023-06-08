//
//  ImageExtension.swift
//  FetchMenu
//
//  Created by Chenyu Yan on 6/4/23.
//

import UIKit

extension UIImageView {
    
    func loadFrom(_ urlString: String) {
        
        //Vérifie si cette string est une url
        guard let url = URL(string: urlString) else { return }
        
        //Lancement URLSession
        /// URLSession est une classe qui est à l'intérieur de UIKit :
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //Vérifier si erreur
            if let err = error {
                print(err.localizedDescription)
            }
            //Verifier si data
            if let d = data {
                //Convertir data en image
                let image = UIImage(data: d)
                //Revenir sur le main
                DispatchQueue.main.async {
                    //Attribuer l'image
                    self.image = image
                }
            }
        }.resume()
    }
    
}


