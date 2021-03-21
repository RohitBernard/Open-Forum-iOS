//
//  PostViewController.swift
//  Open Forum
//
//  Created by Rohit Pratapa Bernard on 16/03/21.
//

import UIKit

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let defaults = UserDefaults.standard
    var user_id=""
    var token=""
    //var comments = [UIView]()
    var comments = [CommentData]()
    var commentHeight:CGFloat=0
    
    var voted:Bool=false
    var post_id=""
    var postImageData:Data?=nil
    var currentPost:Post=Post(post: nil, comments: nil)
    let defaultImage=UIImage(named: "defaultImage")!.pngData()
    var postHeight:CGFloat=132
    var mainViewController:ForumTableViewController?
    var index:Int?
    
    //MARK:- Outlets
    
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postUpVote: UIButton!
    @IBOutlet weak var postUpVoteCount: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    @IBOutlet weak var noHeight: NSLayoutConstraint!
    @IBOutlet weak var withHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let u=defaults.value(forKey: "user_id") as? Int,
           let t=defaults.value(forKey: "token") as? String{
            user_id=String(u)
            token=t
            print("fetched saved data")
        }
        else{
            print("oops")
        }
        //scrollView.contentSize=CGSize(width: 500, height: 500)
        getPost()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CommentTableViewCell.")
        }

        let eachComment = comments[indexPath.row]
        
        print("///\n\(eachComment)\n///")
        print("test1")
        print(comments.count)
        print("test2")
        //cell.textLabel?.text = swiftBlogs[row]
        cell.commenterName.text=eachComment.name
        cell.commentBody.text=eachComment.body
        
//        var thisCommentHeight:CGFloat=0
//        if(!cell.hasBeenLoaded){
//            let h=cell.commentBody.text?.height(withConstrainedWidth: cell.commentBody.bounds.width, font: UIFont.systemFont(ofSize: 17))
//            thisCommentHeight+=33
//            thisCommentHeight+=(h ?? 0)
//            commentHeight+=thisCommentHeight
//            tableHeight.constant=commentHeight
//            //self.viewWillLayoutSubviews()
//        }
//        cell.hasBeenLoaded=true
        tableView.layoutIfNeeded()
        print("tableView height: \(tableView.contentSize.height)")
        tableHeight.constant=tableView.contentSize.height
        //commentHeight=tableView.contentSize.height-commentHeight
        //print("commentHeight: \(commentHeight)")
        //postHeight+=commentHeight
        //postHeight+=tableView.contentSize.height
        print("postHeight: \(postHeight)")
        scrollView.contentSize=CGSize(width: innerView.bounds.width, height: postHeight+tableView.contentSize.height+8)
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight.constant = self.tableView.contentSize.height
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - API Calls
    
    private func getPost(){
        print("getting current posts")
        print(post_id)
        let session = URLSession.shared
        var request=URLRequest(url: URL(string: "https://morning-temple-69567.herokuapp.com/posts/"+post_id+"/"+user_id)!)
        request.httpMethod="GET"
        request.setValue(("Bearer "+token), forHTTPHeaderField: "Authorization")
        let dataTask = session.dataTask(with: request) { (data, response, _) in
            if let postData=data{
                DispatchQueue.main.async {
                    print(postData)
                    let postResult = try? JSONDecoder().decode(Post.self, from: postData)
                    do {
                        let messages = try JSONDecoder().decode(Post.self, from: postData)
                        print(messages as Any)
                    } catch DecodingError.dataCorrupted(let context) {
                        print(context)
                    } catch DecodingError.keyNotFound(let key, let context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch DecodingError.valueNotFound(let value, let context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch DecodingError.typeMismatch(let type, let context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                    //print(postResult as Any)
                    self.voted=(postResult?.post?.voted)!
                    
                    self.postTitle.text=postResult?.post?.title
                    self.postBody.text=postResult?.post?.body
                    let voteMessage=String((postResult?.post?.votes)!)+" UpVotes"
                    self.postUpVoteCount.text=voteMessage
                    
                    if self.postImageData==nil{
                        //print("\n\n\n\(cell.postTitle.text) Height=0\n\n\n")
                        self.noHeight.priority=UILayoutPriority(rawValue: 999)
                        self.withHeight.priority=UILayoutPriority(rawValue: 750)
                        
                    }
                    else{
                        //print("\n\n\n\(self.postTitle.text) Height is not 0\n\n\n")
                        self.noHeight.priority=UILayoutPriority(rawValue: 250)
                        self.withHeight.priority=UILayoutPriority(rawValue: 750)
                        self.postImage.image=UIImage(data: self.postImageData ?? self.defaultImage!)
                        
                        let ratio=(self.postImage.image?.size.height)!/(self.postImage.image?.size.width)!
                        self.withHeight.constant=self.postImage.bounds.width*ratio
                        
                        self.postHeight+=self.withHeight.constant
                    }

                    let h = self.postBody.text?.height(withConstrainedWidth: self.postBody.bounds.width, font: UIFont.systemFont(ofSize: 17))
                    self.postHeight+=h ?? 0
                    print(self.postHeight)
                    
                    if (postResult?.post?.voted)!{
                        self.postUpVote.setImage(UIImage(named: "upVotePressed"), for: .normal)
                    }
                    else{
                        self.postUpVote.setImage(UIImage(named: "upVoteNotPressed"), for: .normal)
                    }

                    
                    self.scrollView.contentSize=CGSize(width: self.innerView.bounds.width, height: self.postHeight)
                    //self.innerView.constraints.
                    postResult?.comments?.forEach{self.comments.append($0!)}
                    print("\n\n\n\(self.comments)\n\n\n")
                    self.tableView.reloadData()
                }
            }
        }
        dataTask.resume()
    }
    
    @IBAction func upVotePressed(_ sender: Any) {
        let upVote=UpVote(user_id: Int(user_id), post_id: Int(post_id))
        
        guard let uploadData = try? JSONEncoder().encode(upVote) else {
            return
        }
        
        let url = voted ? URL(string: "https://morning-temple-69567.herokuapp.com/votes/down/posts")! : URL(string: "https://morning-temple-69567.herokuapp.com/votes/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(("Bearer "+token), forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //let userResult = try? JSONDecoder().decode(UserResponse.self, from: data)
        //self.defaults.set(userResult.,forKey: "user_id")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            if let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    let upVoteResult = try? JSONDecoder().decode(UpVoteResponse.self, from: data)
                    print ("got data: \(dataString)")
                    
                    let voteMessage=String((upVoteResult?.votes)!)+" UpVotes"
                    self.postUpVoteCount.text=voteMessage
                    if (self.voted){
                        self.postUpVote.setImage(UIImage(named: "upVoteNotPressed"), for: .normal)
                        self.mainViewController?.onUpVote(voted: 0, votes: (upVoteResult?.votes)!, index: self.index!)
                    }
                    else{
                        self.postUpVote.setImage(UIImage(named: "upVotePressed"), for: .normal)
                        self.mainViewController?.onUpVote(voted: 1, votes: (upVoteResult?.votes)!, index: self.index!)
                    }
                    self.voted = !self.voted
                    print(self.index!)
                }
            }
        }
        task.resume()
    }
    
    
    
    

}
//MARK:- Extensions

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
