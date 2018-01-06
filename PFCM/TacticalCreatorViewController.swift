//
//  TacticalScreenViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 19/02/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import UIView_draggable
import Firebase
import Hue
import SCLAlertView

var loadPreset: Bool?
var chosenPreset: String?
var loadTactic: Bool?

var lgkCoord: CGPoint?
var lp2Coord: CGPoint?
var lp3Coord: CGPoint?
var lp4Coord: CGPoint?
var lp5Coord: CGPoint?
var lp6Coord: CGPoint?
var lp7Coord: CGPoint?
var lp8Coord: CGPoint?
var lp9Coord: CGPoint?
var lp10Coord: CGPoint?
var lp11Coord: CGPoint?
var lannotationLink: String?

class TacticalCreatorViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var drawPanel: UIImageView!
    @IBOutlet weak var pB1: UIView!
    @IBOutlet weak var pB2: UIView!
    @IBOutlet weak var pB3: UIView!
    @IBOutlet weak var pB4: UIView!
    @IBOutlet weak var pB5: UIView!
    @IBOutlet weak var pB6: UIView!
    @IBOutlet weak var pB7: UIView!
    @IBOutlet weak var pB8: UIView!
    @IBOutlet weak var pB9: UIView!
    @IBOutlet weak var pB10: UIView!
    @IBOutlet weak var pB11: UIView!
    @IBOutlet weak var tacticView: UIView!
    @IBOutlet var pics: [UIImageView]!
    @IBOutlet weak var tacticsBar: UIBarButtonItem!
    @IBOutlet var names: [UILabel]!
    @IBOutlet var numbers: [UILabel]!
    @IBOutlet var images: [UIImageView]!
    @IBOutlet var tool: UIImageView!
    @IBOutlet var IDs: [UILabel]!
    
    var cage = CGRect.zero
    var playerName: String?
    var playerNo: String?
    var picPath: String?
    var playerID: String?
    var selectedPosition: UIView?
    var isDrawing = false
    var lastPoint = CGPoint.zero
    var swiped = false
    var strokeColor = UIColor.white.cgColor
    var isErasing = false
    var tacticName: String?
    var annotationURL: String?
    var players = [String]()
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    
    var profileImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableDrag()
        setViewsCorners()
        setImageCircles ()
        drawPanel.isUserInteractionEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if loadPreset == true {
            print ("The chosen preset tactic is:  \(chosenPreset!)")
            fadeInImages()
            loadedPreset()
        }
        
        if loadTactic == true {
            print("custom tactic loading")
            fadeInImages()
            loadedTactic()
            loadAnnotation(picURL: lannotationLink!)
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resetGlobal()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print ("touch started")
        swiped = false
        
        let touch = touches.first
        if(touch?.view == drawPanel){
            lastPoint = touch!.location(in: self.view)
        }
        
        let whatView = touch?.view
        let whatNumber = whatView?.viewWithTag(3) as? UILabel
        if whatView != nil {
            if whatNumber != nil{
                print (whatNumber!.text!)
                print ((touch?.view?.center)!)
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        let touch = touches.first
        if(touch?.view == drawPanel) {
            let currentPoint = touch!.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
    }
    
    func fadeInImages () {
        profileImage?.fadeOut(withDuration: 0)
        profileImage?.fadeIn(withDuration: 1.5)
    }
    
    func resetGlobal () {
        loadPreset = nil
        loadTactic = nil
        chosenPreset = nil
        lannotationLink = nil
    }
    
    
    @IBAction func back(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let confirmAlertView = SCLAlertView(appearance: appearance)
        self.isErasing = false
        
        confirmAlertView.addButton("Yes") {
            self.dismiss(animated: true, completion: nil)
        }
        confirmAlertView.addButton("No") {
            
        }
        
        confirmAlertView.showWarning("Leave?", subTitle: "Are you sure you want to leave?")
        
    }
    
    @IBAction func tacticsButton(_ sender: UIBarButtonItem) {
        print ("Tactics")
        let actionSheetController = UIAlertController(title: "Please select...", message: "Choose to load a preset formation or a saved tactic.", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        
        let savedActionButton = UIAlertAction(title: "Load Tactic", style: .default) { action -> Void in
            print("Load Tactic")
            
            self.performSegue(withIdentifier: "LoadSegue", sender: nil)
        }
        
        let presetActionButton = UIAlertAction(title: "Preset Formations", style: .default) { action -> Void in
            print("preset")
            
            self.performSegue(withIdentifier: "PresetSegue", sender: nil)
        }
        
        
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(presetActionButton)
        actionSheetController.addAction(savedActionButton)
        actionSheetController.view.tintColor = UIColor (hex: "#31A343")
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func drawButton(_ sender: Any) {
        let actionSheetController = UIAlertController(title: "Please select...", message: "Choose to enable, disable, undo or redo a drawing.", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
            
        }
        
        let enableActionButton = UIAlertAction(title: "Draw", style: .default) { action -> Void in
            self.setTool()
            print("Enable Drawing")
            self.isDrawing = true
            self.isErasing = false
            self.drawPanel.isUserInteractionEnabled = true
            self.tool.isHidden = false
            self.tool.image = UIImage(named: "drawingbtn.png")
            self.disablePlayers()
            self.tacticsBar.isEnabled = false
            self.tacticsBar.tintColor = UIColor.lightGray
        }
        
        let disableActionButton = UIAlertAction(title: "Stop", style: .default) { action -> Void in
            print("Disable Drawing")
            self.isDrawing = false
            self.isErasing = false
            self.drawPanel.isUserInteractionEnabled = false
            self.tool.isHidden = true
            self.enablePlayers()
            self.tacticsBar.isEnabled = true
            self.tacticsBar.tintColor = UIColor.white
        }
        
        let eraseActionButton = UIAlertAction(title: "Erase", style: .default) { action -> Void in
            self.isDrawing = true
            print("Erase")
            self.tool.image = UIImage(named: "eraser.png")
            self.tool.isHidden = false
            self.isErasing = true
        }
        
        let clearActionButton = UIAlertAction(title: "Clear", style: .default) { action -> Void in
            print("Clear")
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let confirmAlertView = SCLAlertView(appearance: appearance)
            self.isErasing = false
            self.tool.image = UIImage(named: "drawingbtn.png")
            
            confirmAlertView.addButton("Yes") {
                self.drawPanel.image = nil
            }
            confirmAlertView.addButton("No") {
                
            }
            
            confirmAlertView.showInfo("Clear?", subTitle: "Are you sure you want to clear the background?")
        }
        
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(enableActionButton)
        actionSheetController.addAction(disableActionButton)
        actionSheetController.addAction(eraseActionButton)
        actionSheetController.addAction(clearActionButton)
        actionSheetController.view.tintColor = UIColor (hex: "#31A343")
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        nameTactic(nextGame: false)
    }
    
    
    @IBAction func share(_ sender: Any) {
        print("share")
        let tacticImg = UIImage(view: tacticView)
        
        let objectsToShare = [ tacticImg ]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.excludedActivityTypes = [ UIActivityType.openInIBooks, UIActivityType.postToFlickr, UIActivityType.postToTencentWeibo, UIActivityType.postToWeibo, UIActivityType.addToReadingList ]
        
        // present the view controller
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func selectAPlayer(_ sender: UITapGestureRecognizer) {
        let viewController = "addPlayerPopover"
        let storyboard : UIStoryboard = UIStoryboard(name: "Tactics", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewController) as? TacticsPlayerAddViewController
        vc?.selectedPosition = sender.view
        let nav = UINavigationController(rootViewController: vc!)
        
        nav.navigationBar.barStyle = .blackTranslucent
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        popover?.delegate = self
        nav.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        popover?.permittedArrowDirections = [.down, .up]
        popover?.sourceRect = CGRect(x: sender.view!.bounds.origin.x, y: sender.view!.bounds.origin.y, width: sender.view!.bounds.width, height: 0)
        popover?.sourceView = sender.view
        present(nav, animated: true, completion:nil)
        
        self.selectedPosition = sender.view
        print (selectedPosition!)
    }
    
    func nameTactic(nextGame: Bool) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Enter your tactic's name...")
        _ = alert.addButton("Save") {
            self.tacticName = txt.text
            self.createTactic()
        }
        _ = alert.addButton("Cancel") {
            
        }
        _ = alert.showInfo("Tactic Name", subTitle: "Give your tactic a name...")
    }
    
    func createTactic() {
        let club = FIRAuth.auth()?.currentUser?.uid
        let storageRef = storage.reference()
        let tacticID = "\(tacticName!)\(NSUUID().uuidString)"
        let aPath = "\(club!)/tactics/\(tacticID).png"
        self.annotationURL = aPath
        let picRef = storageRef.child(aPath)
        let annotations = UIImage(view: drawPanel)
        let data = UIImagePNGRepresentation(annotations)! as Data
        picRef.put(data,metadata: nil)
        
        
        let tactic = Tactic(tid: tacticID, tacticName: tacticName!,
                            gkCoord_x: Double(pB1.center.x), gkCoord_y: Double(pB1.center.y),
                            p2Coord_x: Double(pB2.center.x), p2Coord_y: Double(pB2.center.y),
                            p3Coord_x: Double(pB3.center.x), p3Coord_y: Double(pB3.center.y),
                            p4Coord_x: Double(pB4.center.x), p4Coord_y: Double(pB4.center.y),
                            p5Coord_x: Double(pB5.center.x), p5Coord_y: Double(pB5.center.y),
                            p6Coord_x: Double(pB6.center.x), p6Coord_y: Double(pB6.center.y),
                            p7Coord_x: Double(pB7.center.x), p7Coord_y: Double(pB7.center.y),
                            p8Coord_x: Double(pB8.center.x), p8Coord_y: Double(pB8.center.y),
                            p9Coord_x: Double(pB9.center.x), p9Coord_y: Double(pB9.center.y),
                            p10Coord_x: Double(pB10.center.x), p10Coord_y: Double(pB10.center.y),
                            p11Coord_x: Double(pB11.center.x), p11Coord_y: Double(pB11.center.y),
                            aURL: annotationURL!)
        
            let clubRef = ref.child(club!)
            let tacticsRef = clubRef.child("tactics")
            tacticsRef.child(tacticID).setValue(tactic.toAny())
            let addSuccessAlertView = SCLAlertView()
            addSuccessAlertView.showSuccess("Congrats!", subTitle: "Tactic has successfully been saved.")
        
    }
    
    func saveTactic() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let confirmAlertView = SCLAlertView(appearance: appearance)
        confirmAlertView.addButton("Yes") {
            self.createTactic()
            self.isDrawing = false
            self.isErasing = false
            self.drawPanel.isUserInteractionEnabled = false
            self.tool.isHidden = true
            self.enablePlayers()
            self.tacticsBar.isEnabled = true
            self.tacticsBar.tintColor = UIColor.white
        }
        
        confirmAlertView.addButton("No") {
            
        }
        
        confirmAlertView.showInfo("Save Tactic?", subTitle: "Are you sure you want to save this tactic?")
    }
    
    
    func loadAnnotation(picURL: String) {
        if lannotationLink != nil {
            let storageRef = storage.reference(withPath: picURL)
            drawPanel.sd_setImage(with: storageRef)
        } else {
            print("annotation not loaded")
        }
    }
    
    func loadedPreset () {
        switch chosenPreset! {
        case "4-4-2":
            print(chosenPreset!)
            t442()
        case "4-3-3":
            print(chosenPreset!)
            t433()
        case "4-2-3-1":
            print(chosenPreset!)
            t4231()
        case "3-4-3":
            print(chosenPreset!)
            t343()
        case "3-5-2":
            print(chosenPreset!)
            t352()
        case "3-6-1":
            print(chosenPreset!)
            t361()
        case "5-3-2":
            print(chosenPreset!)
            t532()
        default:
            print ("default")
            loadPreset = false
        }
    }
    
    func loadedTactic() {
        
        pB1.center = lgkCoord!
        
        pB2.center = lp2Coord!
        
        pB3.center = lp3Coord!
        
        pB4.center = lp4Coord!
        
        pB5.center = lp5Coord!
        
        pB6.center = lp6Coord!
        
        pB7.center = lp7Coord!
        
        pB8.center = lp8Coord!
        
        pB9.center = lp9Coord!
        
        pB10.center = lp10Coord!
        
        pB11.center = lp11Coord!
        
    }
    
    func t442 () {
        pB1.center = CGPoint(x: 207.5, y: 639.5)
        pB2.center = CGPoint(x: 41.5, y: 495.5)
        pB3.center = CGPoint(x: 151.5, y: 535.5)
        pB4.center = CGPoint(x: 265.5, y: 535.5)
        pB5.center = CGPoint(x: 372.5, y: 495.5)
        pB6.center = CGPoint(x: 41.5, y: 215.5)
        pB7.center = CGPoint(x: 151.5, y: 344.5)
        pB8.center = CGPoint(x: 265.5, y: 344.5)
        pB9.center = CGPoint(x: 372.5, y: 215.5)
        pB10.center = CGPoint(x: 151.5, y: 123.5)
        pB11.center = CGPoint(x: 265.5, y: 110.5)
    }
    
    func t433 () {
        pB1.center = CGPoint(x: 207.5, y: 639.5)
        
        pB2.center = CGPoint(x: 41.5, y: 495.5)
        
        pB3.center = CGPoint(x: 151.5, y: 535.5)
        
        pB4.center = CGPoint(x: 265.5, y: 535.5)
        
        pB5.center = CGPoint(x: 372.5, y: 495.5)
        
        pB6.center = CGPoint(x: 151.5, y: 344.5)
        
        pB7.center = CGPoint(x: 207.5, y: 440.0)
        
        pB8.center = CGPoint(x: 265.5, y: 344.5)
        
        pB9.center = CGPoint(x: 372.5, y: 215.5)
        
        pB10.center = CGPoint(x: 207.5, y: 110.5)
        
        pB11.center = CGPoint(x: 41.5, y: 215.5)
    }
    
    func t4231 () {
        pB1.center = CGPoint(x: 207.5, y: 639.5)
        
        pB2.center = CGPoint(x: 41.5, y: 495.5)
        
        pB3.center = CGPoint(x: 151.5, y: 535.5)
        
        pB4.center = CGPoint(x: 265.5, y: 535.5)
        
        pB5.center = CGPoint(x: 372.5, y: 495.5)
        
        pB6.center = CGPoint(x: 207.5, y: 240.0)
        
        pB7.center = CGPoint(x: 151.5, y: 344.5)
        
        pB8.center = CGPoint(x: 265.5, y: 344.5)
        
        pB9.center = CGPoint(x: 372.5, y: 215.5)
        
        pB10.center = CGPoint(x: 207.5, y: 110.5)
        
        pB11.center = CGPoint(x: 41.5, y: 215.5)
    }
    
    func t343 () {
        pB1.center = CGPoint(x: 207.5, y: 639.5)
        
        pB2.center = CGPoint(x: 41.5, y: 325.0)
        
        pB3.center = CGPoint(x: 100.0, y: 490.0)
        
        pB4.center = CGPoint(x: 207.5, y: 540.0)
        
        pB5.center = CGPoint(x: 310.0, y: 490.0)
        
        pB6.center = CGPoint(x: 135.0, y: 215.0)
        
        pB7.center = CGPoint(x: 151.5, y: 410.0)
        
        pB8.center = CGPoint(x: 265.5, y: 410.0)
        
        pB9.center = CGPoint(x: 372.5, y: 325.0)
        
        pB10.center = CGPoint(x: 207.5, y: 110.5)
        
        pB11.center = CGPoint(x: 280, y: 215.0)
    }
    
    func t352 () {
        pB1.center = CGPoint(x: 207.5, y: 639.5)
        
        pB2.center = CGPoint(x: 41.5, y: 325.0)
        
        pB3.center = CGPoint(x: 100.0, y: 490.0)
        
        pB4.center = CGPoint(x: 207.5, y: 540.0)
        
        pB5.center = CGPoint(x: 310.0, y: 490.0)
        
        pB6.center = CGPoint(x: 207.5, y: 240.0)
        
        pB7.center = CGPoint(x: 151.5, y: 344.5)
        
        pB8.center = CGPoint(x: 265.5, y: 344.5)
        
        pB9.center = CGPoint(x: 372.5, y: 325.0)
        
        pB10.center = CGPoint(x: 151.5, y: 123.5)
        
        pB11.center = CGPoint(x: 265.5, y: 110.5)
    }
    
    func t361 () {
        pB1.center = CGPoint(x: 207.5, y: 639.5)
        
        pB2.center = CGPoint(x: 41.5, y: 325.0)
        
        pB3.center = CGPoint(x: 100.0, y: 490.0)
        
        pB4.center = CGPoint(x: 207.5, y: 540.0)
        
        pB5.center = CGPoint(x: 310.0, y: 490.0)
        
        pB6.center = CGPoint(x: 151.5, y: 344.5)
        
        pB7.center = CGPoint(x: 207.5, y: 440.0)
        
        pB8.center = CGPoint(x: 265.5, y: 344.5)
        
        pB9.center = CGPoint(x: 372.5, y: 325.0)
        
        pB10.center = CGPoint(x: 207.5, y: 110.5)
        
        pB11.center = CGPoint(x: 207.5, y: 215.0)
        
    }
    
    func t532 () {
        pB1.center = CGPoint(x: 207.5, y: 639.5)
        
        pB2.center = CGPoint(x: 41.5, y: 460.0)
        
        pB3.center = CGPoint(x: 130.0, y: 490.0)
        
        pB4.center = CGPoint(x: 207.5, y: 540.0)
        
        pB5.center = CGPoint(x: 275.0, y: 490.0)
        
        pB6.center = CGPoint(x: 207.5, y: 240.0)
        
        pB7.center = CGPoint(x: 151.5, y: 344.5)
        
        pB8.center = CGPoint(x: 265.5, y: 344.5)
        
        pB9.center = CGPoint(x: 372.5, y: 460.0)
        
        pB10.center = CGPoint(x: 151.5, y: 123.5)
        
        pB11.center = CGPoint(x: 265.5, y: 110.5)
    }
    
    
    func setTool () {
        tool.image = UIImage(named: "drawingbtn.png")
    }
    
    func drawLines (fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        drawPanel.image?.draw(in: CGRect(x:0, y:0, width: self.view.frame.width, height:self.view.frame.height))
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y : fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y : toPoint.y))
        if (isErasing) {
            context?.setBlendMode(CGBlendMode.clear)
            context?.setLineWidth(25)
        } else {
            context?.setBlendMode(CGBlendMode.normal)
            context?.setLineWidth(4)
        }
        
        context?.setLineCap(CGLineCap.round)
        
        context?.setStrokeColor(strokeColor)
        context?.strokePath()
        
        drawPanel.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    
    // UIPopoverPresentationControllerDelegate method
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
    
    func setPlayer () {
        if selectedPosition != nil {
            
            if let nameLabel: UILabel = selectedPosition?.viewWithTag(2) as? UILabel {
                nameLabel.text = playerName
            }
            if let noLabel: UILabel = selectedPosition?.viewWithTag(3) as? UILabel {
                noLabel.text = playerNo
            }
            if let pid: UILabel = selectedPosition?.viewWithTag(4) as? UILabel {
                pid.text = playerID
            }
            
            profileImage = selectedPosition?.viewWithTag(1) as? UIImageView
            loadImage(path: picPath!, imageView: profileImage!)
        }
    }
    
    func setImageCircles () {
        for pic in self.pics {
            circlePicture(imageView: pic)
        }
    }
    
    func circlePicture (imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderColor = UIColor(hex: "#31A343").cgColor
        imageView.layer.borderWidth = 0.7
        imageView.layer.shouldRasterize = true
    }
    
    func loadImage (path: String, imageView: UIImageView) {
        
        let storageRef = storage.reference(withPath: path)
        imageView.sd_setImage(with: storageRef)
    }
    
    func enablePlayers () {
        pB1.isUserInteractionEnabled = true
        pB2.isUserInteractionEnabled = true
        pB3.isUserInteractionEnabled = true
        pB4.isUserInteractionEnabled = true
        pB5.isUserInteractionEnabled = true
        pB6.isUserInteractionEnabled = true
        pB7.isUserInteractionEnabled = true
        pB8.isUserInteractionEnabled = true
        pB9.isUserInteractionEnabled = true
        pB10.isUserInteractionEnabled = true
        pB11.isUserInteractionEnabled = true
    }
    
    func disablePlayers () {
        pB1.isUserInteractionEnabled = false
        pB2.isUserInteractionEnabled = false
        pB3.isUserInteractionEnabled = false
        pB4.isUserInteractionEnabled = false
        pB5.isUserInteractionEnabled = false
        pB6.isUserInteractionEnabled = false
        pB7.isUserInteractionEnabled = false
        pB8.isUserInteractionEnabled = false
        pB9.isUserInteractionEnabled = false
        pB10.isUserInteractionEnabled = false
        pB11.isUserInteractionEnabled = false
    }
    
    
    func setViewsCorners(){
        pB1.setCorners()
        pB2.setCorners()
        pB3.setCorners()
        pB4.setCorners()
        pB5.setCorners()
        pB6.setCorners()
        pB7.setCorners()
        pB8.setCorners()
        pB9.setCorners()
        pB10.setCorners()
        pB11.setCorners()
        
        pB1.addDropShadowToView()
        pB2.addDropShadowToView()
        pB3.addDropShadowToView()
        pB4.addDropShadowToView()
        pB5.addDropShadowToView()
        pB6.addDropShadowToView()
        pB7.addDropShadowToView()
        pB8.addDropShadowToView()
        pB9.addDropShadowToView()
        pB10.addDropShadowToView()
        pB11.addDropShadowToView()
    }
    
    func enableDrag() {
        cage = self.drawPanel.frame
        
        //pB1.enableDragging()
        pB1.cagingArea = cage
        
        pB2.enableDragging()
        pB2.cagingArea = cage
        
        pB3.enableDragging()
        pB3.cagingArea = cage
        
        pB4.enableDragging()
        pB4.cagingArea = cage
        
        pB5.enableDragging()
        pB5.cagingArea = cage
        
        pB6.enableDragging()
        pB6.cagingArea = cage
        
        pB7.enableDragging()
        pB7.cagingArea = cage
        
        pB8.enableDragging()
        pB8.cagingArea = cage
        
        pB9.enableDragging()
        pB9.cagingArea = cage
        
        pB10.enableDragging()
        pB10.cagingArea = cage
        
        pB11.enableDragging()
        pB11.cagingArea = cage
    }
    
    
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
        
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool
    {
        return true
    }
    
}

extension UIView {
    func setCorners() {
        self.layer.cornerRadius = 9.5
        self.layer.borderColor = UIColor.white
            .cgColor
        self.layer.borderWidth = 0.7
        self.clipsToBounds = true
    }
    func addDropShadowToView(){
        self.layer.masksToBounds =  false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:2.0, height: 1.5)
        self.layer.shadowOpacity = 0.2
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

//For Preset Formations

/*print("pB1.center = CGPoint(x: \(self.pB1.center.x), y: \(self.pB1.center.y))\n")
 print("pB2.center = CGPoint(x: \(self.pB2.center.x), y: \(self.pB2.center.y))\n")
 print("pB3.center = CGPoint(x: \(self.pB3.center.x), y: \(self.pB3.center.y))\n")
 print("pB4.center = CGPoint(x: \(self.pB4.center.x), y: \(self.pB4.center.y))\n")
 print("pB5.center = CGPoint(x: \(self.pB5.center.x), y: \(self.pB5.center.y))\n")
 print("pB6.center = CGPoint(x: \(self.pB5.center.x), y: \(self.pB5.center.y))\n")
 print("pB7.center = CGPoint(x: \(self.pB7.center.x), y: \(self.pB7.center.y))\n")
 print("pB8.center = CGPoint(x: \(self.pB8.center.x), y: \(self.pB8.center.y))\n")
 print("pB9.center = CGPoint(x: \(self.pB9.center.x), y: \(self.pB9.center.y))\n")
 print("pB10.center = CGPoint(x: \(self.pB10.center.x), y: \(self.pB10.center.y))\n")
 print("pB11.center = CGPoint(x: \(self.pB11.center.x), y: \(self.pB11.center.y))\n")*/

