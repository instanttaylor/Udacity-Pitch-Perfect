//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Taylor Smith on 9/17/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
    
    init(file: NSURL, title: String) {
        self.filePathURL = file
        self.title = title
    }
}