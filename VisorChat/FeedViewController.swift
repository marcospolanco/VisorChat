//
//  ViewController.swift
//  VisorChat
//
//  Created by Marcos Polanco on 6/24/18.
//  Copyright © 2018 Visor Labs. All rights reserved.
//

import UIKit
import Parse
import MessengerKit
import SwiftDate
import ParseLiveQuery
import SwiftyCam

class FeedViewController: MSGMessengerViewController {
    
    var target: PFUser? {
        didSet {self.load()}
    }
    
    var posts: [Post] = [] {
        didSet {
            self.messages = posts.enumerated().map {(arg: (offset: Int, post: Post)) -> MSGMessage? in
                let (index, post) = arg
                
                guard let source = post.source, let sentAt = post.createdAt, let content = post.content else {return nil}
                return MSGMessage.init(id: index, body: .text(content), user: source, sentAt: sentAt)
                }.compactMap{$0}.map {[$0]}
        }
    }
    
    var messages = [[MSGMessage]](){
        didSet {self.collectionView.reloadData()}
    }
    
    weak var camera: CameraViewController?
    
    var subscription: Subscription<PFObject>?
    
    private func addMediaButton(){
        guard let messageInputView = self.messageInputView as? VisorMessageInputView else {return print("invalid input view")}
        messageInputView.mediaTapper.onTap(target: self, selector: #selector(mediaButtonTapped))
    }
    
    @objc func mediaButtonTapped(){
        let camera = CameraViewController()
        camera.cameraDelegate = self
        
        self.camera = camera
        self.present(camera, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        self.addMediaButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.load()
        self.subscribe()

        NotificationCenter.default.addObserver(forName: .onTargetSelected, object: nil, queue: nil) {[weak self] notification in
            if let target = notification.object as? PFUser {
                self?.target = target
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .onTargetSelected, object: nil)
    }
    
    private func subscribe() {
        guard let query = Post.query()?.whereKeyExists(Post.Fields.target.rawValue).includeKeys([Post.Fields.source.rawValue,Post.Fields.target.rawValue]) else {return print("nil query")}
        subscription = AppDelegate.shared?.client?.subscribe(query).handle(Event.created){[weak self] _ , post in
            guard let post = post as? Post else {return print("post coult not be cas to Post")}
            DispatchQueue.main.async {
                post.source?.fetchIfNeededInBackground {result, error in
                    guard let _ = result else {return print("error fetchting post.source")}
                    self?.posts.append(post)
                }
            }
        }
    }
    
    private func load() {
        
        
        //return any posts where the current user is the source or target
        guard let senderQ = Post.query()?.whereKey(Post.Fields.source.rawValue, equalTo: PFUser.current() as Any),
            let targetQ = Post.query()?.whereKey(Post.Fields.target.rawValue, equalTo: PFUser.current() as Any)
            else {return print("could not build queries")}
        
        
        let orQ = PFQuery.orQuery(withSubqueries: [senderQ, targetQ])
        orQ.includeKeys([Post.Fields.source.rawValue,Post.Fields.target.rawValue])
        
        orQ.findObjectsInBackground {[weak self] results, error in
            guard let posts = results as? [Post] else {return print("error:\(error?.localizedDescription ?? "")")}
            self?.posts = posts
        }
    }
    
    override var style: MSGMessengerStyle {
        var style = MessengerKit.Styles.travamigos
        style.inputView = VisorMessageInputView.self
        return style
    }
    
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        if inputView.message.lowercased() == "logout" {
            PFUser.logOut()
            AppDelegate.rootViewController?.verifyAuthentication()
            return
        }
        
        let post = Post()
        post.source = PFUser.current()
        post.content = inputView.message
        post.saveInBackground {[weak self] success, error in
            guard let _self = self, success else
            {return print("error: \(error?.localizedDescription ?? "")")}
            
            guard let user = PFUser.current() else {return print("user == nil")}
            
            let message = MSGMessage.init(id: _self.messages.count,
                                          body: .text(inputView.message),
                                          user: user, sentAt: Date())
            _self.insert(message)
        }
    }
    
    override func insert(_ message: MSGMessage) {
        collectionView.performBatchUpdates({
            if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                self.messages[self.messages.count - 1].append(message)
                
                let sectionIndex = self.messages.count - 1
                let itemIndex = self.messages[sectionIndex].count - 1
                self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
                
            } else {
                self.messages.append([message])
                let sectionIndex = self.messages.count - 1
                self.collectionView.insertSections([sectionIndex])
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: true)
            self.collectionView.layoutTypingLabelIfNeeded()
        })
    }
}

extension FeedViewController: MSGDataSource {
    func numberOfSections() -> Int {
        return messages.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return messages[section].count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        return messages[indexPath.section][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return messages[section].last?.sentAt.colloquial(to: Date())
    }
    
    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }
}

extension Double {var asInt: Int {return Int(self)}}

extension FeedViewController: SwiftyCamButtonDelegate {
    func buttonWasTapped() {
        self.camera?.takePhoto()
    }
    
    func buttonDidBeginLongPress() {
        print(#function)
    }
    
    func buttonDidEndLongPress() {
        print(#function)
    }
    
    func longPressDidReachMaximumDuration() {
        print(#function)
    }
    
    func setMaxiumVideoDuration() -> Double {
        return 1000.00
    }
}

extension FeedViewController: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        swiftyCam.dismiss(animated: true)
        
        guard let user = PFUser.current() else {return print("no authenticated user")}
        let message = MSGMessage.init(id: Date().timeIntervalSinceReferenceDate.asInt,
                                      body: .image(photo), user: user, sentAt: Date())
        self.insert(message)
    }
}
extension FeedViewController: MSGDelegate {
    func linkTapped(url: URL) {}
    func avatarTapped(for user: MSGUser) {}
    func tapReceived(for message: MSGMessage) {}
    func longPressReceieved(for message: MSGMessage) {}
    func shouldDisplaySafari(for url: URL) -> Bool {return false}
    func shouldOpen(url: URL) -> Bool {return false}
}

extension PFUser : MSGUser {
    public var displayName: String {
        return self.fullname ?? "Anonymous"
    }
    
    public var avatar: UIImage? {
        get {
            return nil
        }
        set(newValue) {
        }
    }
    
    public var isSender: Bool {
        return PFUser.current() == self
    }
}
