//
//  ViewController.swift
//  aRadar
//
//  Created by hortune on 2018/6/2.
//  Copyright © 2018年 hortune. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.searchBar.borderStyle = UITextBorderStyle.roundedRect
        self.searchBar.returnKeyType = .done
        self.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startSearch" {
            let arViewController: ARViewController = segue.destination as! ARViewController
            arViewController.roomCode = self.searchBar.text!
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

