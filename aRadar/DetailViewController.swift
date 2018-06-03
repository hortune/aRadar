//
//  DetailViewController.swift
//  aRadar
//
//  Created by hortune on 2018/6/3.
//  Copyright © 2018年 hortune. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    let button = UIButton(frame: CGRect(x: 10, y: 20, width: 20, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "close.png") {
            button.setImage(image, for:[])
        }
        button.addTarget(self,action: #selector(self.dismiss(_:)), for: UIControlEvents.touchDown)
        view.addSubview(button)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismiss(_ sender: UIButton){ //<- needs `@objc`
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
