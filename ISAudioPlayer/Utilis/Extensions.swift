//
//  Extensions.swift
//  ISAudioPlayer
//
//  Created by Igor Sokolovsky on 1/14/17.
//  Copyright © 2017 Igor Sokolovsky. All rights reserved.
//

import Foundation
extension URL{
    static func getFileFromBundle(byName name:String , withExtention:String)->URL?{
        if let path = Bundle.main.path(forResource: name, ofType: withExtention){
            let url = URL(fileURLWithPath: path)
            return url
        }
        return nil
    }
}


extension String{
   static var uuid:String{
        get{
            return UUID().uuidString
        }
    }
}
