//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Denys Medina Aguilar on 11/03/15.
//  Copyright (c) 2015 Denys Medina Aguilar. All rights reserved.
//

import UIKit

final class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL?
    var title: String?
    
    init(filePathUrl: NSURL, title: String) {

        self.filePathUrl = filePathUrl
        self.title = title
        super.init()
        
    }
    
}
