//
//  SecondViewController.swift
//  E-Commerce App
//
//  Created by Mac on 22/05/22.
//

import UIKit

class SecondViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var titleLabelSV: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingTF: UITextField!

    //MARK: Variabeles
    var titleContainer: String = ""
    var descriptionContainer: String = ""
    var ratingContainer: String = ""
    var passDataClosure: ((String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        titleLabelSV.text = self.titleContainer
        descriptionLabel.text = self.descriptionContainer
        ratingTF.text = self.ratingContainer
        
        let rating = self.ratingTF.text ?? ""
         guard let closure = passDataClosure else {
             return
         }
         closure(rating)
        
    }
    
 
}
