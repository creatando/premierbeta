//
//  SocialCentreViewController.swift
//  PFCM
//
//  Created by Thomas Anderson on 10/04/2017.
//  Copyright © 2017 Thomas Anderson. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView
import FirebaseStorageUI

class SocialCentreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var post: UIButton!
    @IBOutlet weak var txt: UITextField!
    
    var results: [Post] = []
    var searchResults: [Post] = []
    var searchController: UISearchController!
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    let user = FIRAuth.auth()?.currentUser?.uid
    
    let imagePicker = UIImagePickerController()
    
    var postID: String?
    var like: Int?
    var likeRef: FIRDatabaseReference?
    var indexPaths = [IndexPath]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        imagePicker.delegate = self
        tableView.dataSource = self
        retrievePosts()
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrievePosts() {
        let postsRef = ref.child("posts").queryLimited(toLast: 20)
        
        postsRef.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.results.removeAll()
                for snap in snapshot {
                    let post = Post(snapshot: snap)
                    self.results.append(post)
                }
                self.results.sort(by: {$0.timestamp as! Double > $1.timestamp as! Double})
            }
            
            self.tableView.reloadData()
        })
    }
    
    
    func setupSearch() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = UIColor.white
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView?.addSubview(searchController.searchBar)
        
    }
    
    
    @IBAction func addPhoto(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func post (_ sender: Any) {
        createPost()
    }
    
    @IBAction func back (_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func reset() {
        addImage.image = UIImage(named: "addimage.png")
        self.addImage.layer.cornerRadius = 0
        self.addImage.layer.borderWidth = 0
        self.addImage.layer.shouldRasterize = false
        txt.text = nil
    }
    
    func circlePicture () {
        self.addImage.layer.cornerRadius = self.addImage.frame.size.width / 2
        self.addImage.layer.borderColor = UIColor (hex: "#31A343").cgColor
        self.addImage.layer.borderWidth = 2
        self.addImage.layer.shouldRasterize = true
    }
    
    
    func createPost () {
        let key = ref.child("posts").childByAutoId().key
        print(key)
        
        let storageRef = storage.reference()
        let picPath = "\(user!)/posts/\(key).jpg"
        let picRef = storageRef.child(picPath)
        let data = UIImageJPEGRepresentation(self.addImage.image!, 0.7)! as Data
        picRef.put(data,metadata: nil)
        
        let post = Post(postID: key, userID: user!, caption: txt.text!, imageURL: picPath, likes: 0, timestamp: FIRServerValue.timestamp())
        let postsRef = ref.child("posts")
        let userRef = ref.child("users").child(user!)
        postsRef.child(key).setValue(post.toAny())
        userRef.child("posts").child(key).setValue(true)
        
        reset()
        let addSuccessAlertView = SCLAlertView()
        addSuccessAlertView.showSuccess("Congrats!", subTitle: "Post has successfully been added.")
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        NSLog("\(info)")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImage.image = image
            print("picked3 image picker")
            dismiss(animated: true, completion: nil)
            circlePicture()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("dismissed image picker")
    }
    
    override var prefersStatusBarHidden: Bool {return true}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let postCell = cell as? PostCell
        
        if (!indexPaths.contains(indexPath)) {
            indexPaths.append(indexPath)
            cell.fadeOut(withDuration: 0)
            postCell?.likeButton.fadeOut(withDuration: 0)
            postCell?.profilePic.fadeOut(withDuration: 0)
            postCell?.likeButton.fadeIn()
            postCell?.profilePic.fadeIn()
            cell.fadeIn()
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let posts: Post = self.results[indexPath.row]
        
        let storageRef = storage.reference(withPath: posts.imageURL)
        var userStorageRef: FIRStorageReference?
        var profileURL: String?
        
        let userRef = ref.child("users").child(posts.userID)
        var username: String?
        
        let likedRef = ref.child("users").child(user!).child("liked")
        let userLikedRef = likedRef.child(posts.postID)
        
        DispatchQueue.main.async {
            cell.circlePicture()
            cell.caption.text = posts.caption
            cell.likes.text = String(posts.likes)
            cell.postImg.sd_setImage(with: storageRef, placeholderImage: nil)
            
            userRef.observe( .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                username = value?["name"] as? String ?? ""
                cell.name.text = username
                print("got name,")
                
                profileURL = value?["imgURL"] as? String ?? ""
                userStorageRef = self.storage.reference(withPath: profileURL!)
                print(userStorageRef!)
                cell.profilePic.sd_setImage(with: userStorageRef!)
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            userLikedRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    print("this post is liked by the user")
                    cell.likeButton.fadeOut(withDuration: 0.5)
                    cell.likeButton.imageView?.image = UIImage(named: "like-filled.png")
                    cell.likeButton.fadeIn(withDuration: 0.5)
                }
            })
            
            cell.tapBlock = {
                self.postID = posts.postID
                self.like = posts.likes
                userLikedRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNull {
                        print("this has post just been liked")
                        cell.likeButton.imageView?.image = UIImage(named: "like-filled.png")
                        userLikedRef.setValue(true)
                        self.addLikes(add: true)
                    } else {
                        print("this post has just been unliked")
                        cell.likeButton.imageView?.image = UIImage(named: "like.png")
                        userLikedRef.removeValue()
                        self.addLikes(add: false)
                    }
                })
            }
        }
        
        return cell
    }
    
    func addLikes (add: Bool) {
        if add {
            let postRef = ref.child("posts").child(postID!)
            like = like! + 1
            postRef.updateChildValues(["likes": like ?? 0])
        } else {
            let postRef = ref.child("posts").child(postID!)
            like = like! - 1
            postRef.updateChildValues(["likes": like ?? 0])
        }
    }
}



// MARK: - UISearchResultsUpdating
extension SocialCentreViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        print (searchText)
        searchResults = results.filter { post in
            return post.caption.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
}

// MARK: - UISearchBarDelegate
extension SocialCentreViewController:  UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var tapBlock: (() -> Void)? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func circlePicture () {
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        self.profilePic.layer.borderColor = UIColor(hex: "#31A343").cgColor
        self.profilePic.layer.borderWidth = 0.7
        self.profilePic.layer.shouldRasterize = true
    }
    
    @IBAction func liked(_ sender: UIButton) {
        
        if let tapBlock = self.tapBlock {
            tapBlock()
        }
    }
    
    override func prepareForReuse() {
        likeButton.imageView?.image = UIImage(named: "liked.png")
    }
    
}

public extension UIView {
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
}


