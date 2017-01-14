//
//  ISAudioPlayer.swift
//  ISAudioPlayer
//
//  Created by Igor Sokolovsky on 1/14/17.
//  Copyright © 2017 Igor Sokolovsky. All rights reserved.
//

import Foundation
import AVFoundation

public class ISAudioPlayer:ISAudioPlayerManagerDelegate{
    
    private let uuid:String = String.uuid
    private var isPlaying:Bool = false
    private var isPlayerExist:Bool = false
    private var currentPosition = 0
    
    /// the audio file url
    let fileUrl:URL
    
    /// if true shows all the logs associated to the ISAudioPlayerFramework 
    /// that connected this instance
    public var showLogs:Bool = false
    
    public init?(fileUrl:URL){
        self.fileUrl = fileUrl
        initPlayer()
    }

    /// plays the audio
    public func play(){
        if !isPlayerExist{
            initPlayer()
        }
        
        ISAudioPlayerManager.shared.play(uuid: uuid, showLogs: showLogs,delegate:self)
        isPlaying = true
    }
    
    /// use to pause the player so you can play(contnue) it later on 
    // if you dont need it anymore use stop instead
    public func pasue(){
        guard isPlayerExist else{
            return
        }
        
        ISAudioPlayerManager.shared.pause(uuid:uuid,showLogs: showLogs)
        isPlaying = false
    }
    
    /// dont use unless you dont need anymore the player instead use pause
    public func stop(){
        guard isPlayerExist else{
            return
        }
        
        ISAudioPlayerManager.shared.stop(uuid:uuid,showLogs: showLogs)
        isPlaying = false
    }
    
    
    /// pass position in seconds
    ///
    /// - Parameter timePosition: the time position you desire
    public func setAudioPosition(timePosition:TimeInterval){
        ISAudioPlayerManager.shared.setPosition(uuid: uuid, showLogs: showLogs, position: timePosition)
    }
    
    /// return the audio position in seconds
    public func getCurrentPosition() -> TimeInterval?{
        return ISAudioPlayerManager.shared.currentPosition(uuid: uuid, showLogs: showLogs)
    }
    
    private func initPlayer(){
        ISAudioPlayerManager.shared.initPlayer(withPath:fileUrl.path,uniqeId:uuid,showLogs:showLogs)
        isPlayerExist = true
    }
    
    func isPlaying(isPlaying: Bool) {
        self.isPlaying = isPlaying
    }
}
