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
import SceneKit
import FirebaseFirestore

struct spot {
    var latitude: Double?
    var longitude: Double?
    var name = String()
    var desc = String()
    var image = String()
}

class ARViewController: UIViewController, SceneLocationViewDelegate {
    let button = UIButton(frame: CGRect(x: 10, y: 20, width: 20, height: 20))
    var spots = [spot]()
    var sceneLocationView = SceneLocationView()
    var lastIndex: Int = 1
    var roomCode:String = "d2a1"
    
//    for fire base
    var db: Firestore?
    var docRef: DocumentReference? = nil
    
    var data = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(self.tap(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        syncData()
        sceneLocationView.locationDelegate = self
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        loadButton()
//        loadSpots()
    }
    
    func syncData(){
        db = Firestore.firestore()
        let qq = self
        db?.collection("Event").document(roomCode).getDocument{ (document, error) in
            if let error = error{
                print("Error getting documents: \(error)")
            }
            else{
                let prev = qq
                if let eventName = document?.data()?["Category"]{
                    self.db?.collection("Spot").whereField("Category", isEqualTo: eventName)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                print("eventName",eventName)
                                print("Hello")
                                print("querySnapshot",querySnapshot!.documents)
                                for document in querySnapshot!.documents {
                                    print("\(document.documentID) => \(document.data())")
                                    let data = document.data()
                                    if data["SubCategory"] as! String != "Virtual" && data["SubCategory"] as! String != "Misc"{
                                        let pos = data["Position"] as! GeoPoint
                                        prev.spots.append(
                                            spot(latitude: pos.latitude,
                                                 longitude: pos.longitude,
                                                 name: data["Title"] as! String,
                                                 desc: data["Description"] as! String,
                                                 image: data["Graph"] as! String)
                                        )
                                    }
                                }
                                prev.loadSpots()
                            }
                    }
                } else{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    func loadSpots(){
//        spots.append(
//            spot(latitude: 25.021918,
//                 longitude: 121.535285,
//                 name: "台大新體",
//                 desc: "台大知識王產地，康正男的財產台灣大學，yoyo，這是民主的聖地，屌到爆的地方，你知道嗎，這地方辦過ｌｏｌ世界賽。",
//                 image: "http://google.com")
//        )
        print("spots count",spots.count)
        for index in 0...(spots.count-1){
            let spotNode = spots[index]
            let coordinate = CLLocationCoordinate2D(latitude: spotNode.latitude!, longitude: spotNode.longitude!)
            let location = CLLocation(coordinate: coordinate, altitude: 25)
            let image = UIImage(named: "pin")!
            let nimage = textToImage(drawText: spotNode.name , inImage: image, atPoint: CGPoint(x:40, y:40))
            let annotationNode = LocationAnnotationNode(location: location, image: nimage)
            annotationNode.annotationNode.name = "\(index)"
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }
    
    func loadButton(){
        if let image = UIImage(named: "close.png") {
            button.setImage(image, for:[])
        }
        button.addTarget(self,action: #selector(self.dismiss(_:)), for: UIControlEvents.touchDown)
        view.addSubview(button)
    }

    @objc func dismiss(_ sender: UIButton){ //<- needs `@objc`
//        self.performSegue(withIdentifier: "backToOrigin", sender: self)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func garbage1(_ sender: UIButton){ //<- needs `@objc`
        self.performSegue(withIdentifier: "go", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        sceneLocationView.frame = view.bounds
    }

     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            let detailViewController: DetailViewController = segue.destination as! DetailViewController
            detailViewController.data = spots[lastIndex]
            
        }
    }
    
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
    
    // Location Delegate
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation){
        
    }
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation){
        
    }
    
    ///After a node's location is initially set based on current location,
    ///it is later confirmed once the user moves far enough away from it.
    ///This update uses location data collected since the node was placed to give a more accurate location.
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode){
        
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode){
        
    }
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode){
//        print("Debug lcoationNode")
//        print("LocationNode position",locationNode.position)
//        print("LocationNode location",locationNode.location)
//        print("LocationNode Worldposition",locationNode.worldPosition)
//        print("Button position",locationNode.childNodes[0].position)
//        print("Button Worldposition",locationNode.childNodes[0].worldPosition)
//        print("location scale",locationNode.childNodes[0].scale)
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        print("8787")
        let location = sender.location(in: sceneLocationView)
        let sceneHitTestResult = sceneLocationView.hitTest(location, options: nil)
//        print("948794879487")
        if let lastNode = sceneHitTestResult.last?.node {
            lastIndex = Int(lastNode.name!)!
//            print(lastIndex)
            self.performSegue(withIdentifier: "go", sender: self)
        }
    }
}

class ClickableView: UIButton{
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addTarget(self, action:  #selector(objectTapped(_:)), for: .touchUpInside)
        
        self.backgroundColor = .red
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Detects Which Object Was Tapped
    ///
    /// - Parameter sender: UIButton
    @objc func objectTapped(_ sender: UIButton){
        
        print("Object With Tag \(tag)")
        
    }
}
