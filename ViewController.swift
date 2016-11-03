//
//  ViewController.swift
//  WooHoo
//
//  Created by Code For Change on 11/3/16.
//  
//  LET'S GET CODING

import UIKit // Allows us to make our user interface
import MultipeerConnectivity // We use this to communicate with anyone nearby

class ViewController: UIViewController, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, UITextFieldDelegate, MCSessionDelegate {

    
    //This connects our code to the text input
    @IBOutlet weak var messageField: UITextField!
    
    //This connects our code to the text field so we can display messages
    @IBOutlet weak var chatbox: UITextView!
    
    let screenSize = UIScreen.main.bounds //Easy access to screen size
    
    //This is where we setup the app
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpSession()//Sets up the nearby communication for you
        
    }
    
    func sendMessage() { //when send is pressed, send message in textfield to peers
        
            let msg = self.messageField.text?.data(using: String.Encoding.utf8, allowLossyConversion: false)//Encode our message
            
            self.chatbox.text.append("Me" + ": " + messageField.text! + "\n")//Print out the message
  
            //Sends the message to all nearby peers
            do{
                try self.session.send(msg!, toPeers: self.session.connectedPeers,
                                      with: MCSessionSendDataMode.unreliable)
            }
                
            catch let error as NSError {
                print(error.localizedDescription)
            }
        
            //Clears messagefield
            self.messageField.text = ""
    }
    
    //Called when the user presses the send button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()//Send the message
        return true
    }
    
    //Set up the communication protocols - you can ignore
    var browser : MCNearbyServiceBrowser!
    var advertiser : MCNearbyServiceAdvertiser!
    var session : MCSession!
    var peerID: MCPeerID!
    
    func setUpSession(){
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        self.browser = MCNearbyServiceBrowser(peer: peerID,serviceType: "woohoo")
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "woohoo")
        self.browser.delegate = self
        self.advertiser.delegate = self
        
        self.browser.startBrowsingForPeers()
        self.advertiser.startAdvertisingPeer()
        
        self.messageField.delegate = self
    }
    
    //This is called when we recieve a message
    func session(_ session: MCSession, didReceive data: Data,
                 fromPeer peerID: MCPeerID)  {
        // Called when a peer sends a message to us
        
        // This needs to run on the main queue for speed
        DispatchQueue.main.async {
            let msg = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
            self.chatbox.text.append(peerID.displayName + ": " + (msg! as String) + "\n")
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    // YOU CAN IGNORE THIS CODE BELOW
    
    //invites peers to session automatically
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 20)
    }
    //autoaccepts
    func advertiser(_: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer: MCPeerID, withContext: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
    
    // The following methods do nothing, but we need them to compile
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress){
        // Called when a peer starts sending a file to us
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?)  {
        // Called when a file has finished transferring from another peer
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream,
                 withName streamName: String, fromPeer peerID: MCPeerID)  {
        // Called when a peer establishes a stream with us
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState)  {
        // Called when a connected peer changes state (for example, goes offline)
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    //Don't worry about this
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}



