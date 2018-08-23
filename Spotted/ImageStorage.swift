//
//  ImageStorage.swift
//  Spotted
//
//  Created by Joanne Lee on 8/23/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import FirebaseStorage

func downloadImage(_ name1 : String, _ name2 : String, _ count : Int, _ callback : @escaping (Data) -> Void)  {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let starsRef = storageRef.child("\(name1)/\(name2)/\(count).jpg")

    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    let downloadTask = starsRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if let error = error {
            print(error.localizedDescription)
        } else {
            callback(data!)
        }
    }
    
    // Observe changes in status
    downloadTask.observe(.resume) { snapshot in
        // Download resumed, also fires when the download starts
    }
    
    downloadTask.observe(.pause) { snapshot in
        // Download paused
    }
    
    downloadTask.observe(.progress) { snapshot in
        // Download reported progress
        let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
    }
    
    downloadTask.observe(.success) { snapshot in
        // Download completed successfully
    }
}
