//
//  ARViewController.swift
//  aRadar
//
//  Created by hortune on 2018/6/3.
//  Copyright © 2018年 hortune. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation


class ARViewController: UIViewController {
    let button = UIButton(frame: CGRect(x: 10, y: 20, width: 20, height: 20))
    var sceneLocationView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "close.png") {
            button.setImage(image, for:[])
        }
        button.addTarget(self,action: #selector(self.garbage(_:)), for: UIControlEvents.touchDown)
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        view.addSubview(button)
        // Do any additional setup after loading the view.



        let coordinate = CLLocationCoordinate2D(latitude: 25.021918, longitude: 121.535285)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        let image = UIImage(named: "pin")!
        let nimage = textToImage(drawText: "台大新體", inImage: image, atPoint: CGPoint(x:40, y:40))
        let annotationNode = LocationAnnotationNode(location: location, image: nimage)
        //annotationNode.accessibilityLabel = "wtf"
        //annotationNode.scaleRelativeToDistance = true

        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }

    @objc func garbage(_ sender: UIButton){ //<- needs `@objc`
        self.performSegue(withIdentifier: "backToOrigin", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        sceneLocationView.frame = view.bounds
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!

        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)

        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))

        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
