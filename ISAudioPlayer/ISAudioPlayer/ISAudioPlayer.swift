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
    private var isPlayerExist:Bool = false
    private var currentPosition = 0
	
	var isPlaying:Bool{
		get{
			return ISAudioPlayerManager.shared.isPlaying(uuid: uuid)
		}
	}
	
    /// the audio file url
    let fileUrl:URL
    
    /// if true shows all the logs associated to the ISAudioPlayerFramework 
    /// that connected this instance
    public var showLogs:Bool = false
    
    public init(fileUrl:URL){
        self.fileUrl = fileUrl
        initPlayer()
    }
	
	public func deinitPlayer(){
		ISAudioPlayerManager.shared.deinitPlayer(uuid: uuid)
	}

    /// plays the audio
    public func play(){
        if !isPlayerExist{
            initPlayer()
        }
        
        ISAudioPlayerManager.shared.play(uuid: uuid, showLogs: showLogs,delegate:self)
    }
    
    /// use to pause the player so you can play(contnue) it later on 
    // if you dont need it anymore use stop instead
    public func pasue(){
        guard isPlayerExist else{
            return
        }
        
        ISAudioPlayerManager.shared.pause(uuid:uuid,showLogs: showLogs)
    }
    
    /// dont use unless you dont need anymore the player instead use pause
    public func stop(){
        guard isPlayerExist else{
            return
        }
        
        ISAudioPlayerManager.shared.stop(uuid:uuid,showLogs: showLogs)
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
	
	public func getDuration() -> TimeInterval?{
		return ISAudioPlayerManager.shared.getDuration(uuid:uuid,showLogs:showLogs)
	}
    
    private func initPlayer(){
        ISAudioPlayerManager.shared.initPlayer(withPath:fileUrl.path,uniqeId:uuid,showLogs:showLogs)
        isPlayerExist = true
    }
	
	func didStopPlayer(){}
	
	func didPlayPlayer(){}
	
	func didPausePlayer(){}
	
	func didFinishPlaying(){}
	
	func didDeinitilizePlayer(){}
	
	func didUpdatePlayerCurrentPosition(){}
}
