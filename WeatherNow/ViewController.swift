//
//  ViewController.swift
//  WeatherNow
//
//  Created by Mwangi Gituathi on 4/8/22.
//

import UIKit

class ViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   
    //MARK: Ensures the "BACK" title is never changed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backitem = UIBarButtonItem()
        backitem.title = "Back"
        navigationItem.backBarButtonItem = backitem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //MARK: Freezes the View till 3 seconds elapse
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute:{
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? landingViewController {
                if let navigator = self.navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        })
    }
  
}

