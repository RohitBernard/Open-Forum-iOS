//
//  ForumTableViewController.swift
//  Open Forum
//
//  Created by Rohit Pratapa Bernard on 15/03/21.
//

import UIKit
import GoogleSignIn

class ForumTableViewController: UITableViewController {
    
    
    let defaults = UserDefaults.standard
    var token=""
    var user_id=""
    var allPosts=[AllPosts]()
    let defaultImage=UIImage(named: "defaultImage")!.pngData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(getPosts), for: UIControl.Event.valueChanged)
        
        while (defaults.value(forKey: "user_id")==nil || defaults.value(forKey: "token")==nil){}
        if let u=defaults.value(forKey: "user_id") as? Int ,
           let t=defaults.value(forKey: "token") as? String {
            token=t
            user_id=String(u)
            print("fetched saved data\n\(token)\n\(user_id)")
        }
        else{
            print("oops")
        }
        getPosts()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allPosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as? PostTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PostTableViewCell.")
        }
        let eachPost=allPosts[indexPath.row]

        cell.postTitle.text=eachPost.title
        cell.postBody.text=eachPost.body
        let voteMessage=String(eachPost.votes)+" UpVotes"
        cell.postUpVoteCount.text=voteMessage
        cell.postUpVote.tag=indexPath.row
        
        if eachPost.voted==1{
            cell.postUpVote.setImage(UIImage(named: "upVotePressed"), for: .normal)
        }
        else
        {
            cell.postUpVote.setImage(UIImage(named: "upVoteNotPressed"), for: .normal)
        }
        
        
        if eachPost.image==""{
            //print("\n\n\n\(cell.postTitle.text) Height=0\n\n\n")
            cell.noHeight.priority=UILayoutPriority(rawValue: 999)
            cell.withHeight.priority=UILayoutPriority(rawValue: 750)
            
        }
        else{
            
            cell.noHeight.priority=UILayoutPriority(rawValue: 250)
            cell.withHeight.priority=UILayoutPriority(rawValue: 750)
            if eachPost.imageData==nil{
                print("\(eachPost.title) image is nil")
                getImage(postNo:indexPath.row)
            }
            cell.postImage.image=UIImage(data: eachPost.imageData ?? defaultImage!)
            let ratio=(cell.postImage.image?.size.height)!/(cell.postImage.image?.size.width)!
            cell.withHeight.constant=cell.postImage.bounds.width*ratio
            
        }
        print("\n\n\n\(cell.postTitle.text)\n\(eachPost.voted)\n\(cell.noHeight.priority)\n\n\n")
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
     }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let index = tableView.indexPathForSelectedRow?.row,
           let vc = segue.destination as? PostViewController,
           segue.destination is PostViewController
        {
            vc.mainViewController=self
            vc.index=index
            vc.post_id=String(allPosts[index].post_id)
            if allPosts[index].image != ""{
                vc.postImageData=allPosts[index].imageData ?? defaultImage!
                
            }
        }
    }
    
    func onUpVote(voted:Int, votes:Int, index:Int){
        allPosts[index].voted=voted
        allPosts[index].votes=votes
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    
    
    
    @IBAction func signOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        //let forum = self.storyboard?.instantiateViewController(withIdentifier: "ForumTableViewController") as! ForumTableViewController
        //self.navigationController?.pushViewController(forum, animated: true)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate
          else {
            return
          }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let controller = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        sceneDelegate.window?.rootViewController = controller
    }
    
    //MARK: - API Calls
    
    @objc private func getPosts(){
        //https://virtserver.swaggerhub.com/Suhas-C-V/OPEN_FORUM_WEB_API/1.0.0/posts
        //https://floating-ridge-28249.herokuapp.com/posts
        allPosts.removeAll()
        print("getting all posts")
        let session = URLSession.shared
        var request=URLRequest(url: URL(string: "https://morning-temple-69567.herokuapp.com/posts/log/"+user_id)!)
        request.setValue(("Bearer "+token), forHTTPHeaderField: "Authorization")
        request.httpMethod="GET"
        let dataTask = session.dataTask(with: request) { (data, response, _) in
            if let allPostData=data{
                DispatchQueue.main.async {
                    let dataString = String(data: allPostData, encoding: .utf8)
                    print ("got data: \(dataString) //end of data//")
                    print(allPostData)
                    let allPostResult = try? JSONDecoder().decode([AllPosts].self, from: allPostData)
                    print(allPostResult as Any)
                    allPostResult?.forEach{self.allPosts.append($0)}
                    print(self.allPosts)
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
        dataTask.resume()
    }
    
    private func getImage(postNo:Int){
        //https://virtserver.swaggerhub.com/Suhas-C-V/OPEN_FORUM_WEB_API/1.0.0/posts
        //https://floating-ridge-28249.herokuapp.com/posts
        //https://floating-ridge-28249.herokuapp.com/images/uploads
        print("getting image")
        let session = URLSession.shared
        let imgurl="https://morning-temple-69567.herokuapp.com/images/uploads/"+self.allPosts[postNo].image
        var request=URLRequest(url: URL(string: imgurl)!)
        request.setValue(("Bearer "+token), forHTTPHeaderField: "Authorization")
        request.httpMethod="GET"
        let dataTask = session.dataTask(with: request) { (data, response, _) in
            if let imageData=data{
                DispatchQueue.main.async {
                    print(imageData)
                    if response?.mimeType!.split(separator: "/")[0] == "image"{
                        self.allPosts[postNo].imageData=imageData
                    
                        self.tableView.reloadRows(at: [IndexPath(row: postNo, section: 0)], with: .automatic)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
//    @objc func upVoteTapped(_ sender: UIButton){
//      // use the tag of button as index
//      let thisPost = allPosts[sender.tag]
//        print("Pressed \(thisPost.title)")
//
//    }
    
    @IBAction func upVotePressed(_ sender: UIButton) {
        let thisPost = allPosts[sender.tag]
        let index=sender.tag
        let flag = thisPost.voted == 0 ? true : false
        print("Pressed \(thisPost.title)")
        let upVote=UpVote(user_id: Int(user_id), post_id: thisPost.post_id)
        
        guard let uploadData = try? JSONEncoder().encode(upVote) else {
            return
        }
        
        let url = flag ? URL(string: "https://morning-temple-69567.herokuapp.com/votes/posts")! : URL(string: "https://morning-temple-69567.herokuapp.com/votes/down/posts")!
        var request = URLRequest(url: url)
        request.setValue(("Bearer "+token), forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //let userResult = try? JSONDecoder().decode(UserResponse.self, from: data)
        //self.defaults.set(userResult.,forKey: "user_id")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            if let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    let upVoteResult = try? JSONDecoder().decode(UpVoteResponse.self, from: data)
                    print ("got data: \(dataString)")
                    self.allPosts[index].votes=upVoteResult?.votes ?? thisPost.votes
                    self.allPosts[index].voted = flag ? 1 : 0
                    self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
                    
                }
            }
        }
        task.resume()
        //print("button pressed")
    }
    
}
