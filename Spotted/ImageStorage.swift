//
//  ImageStorage.swift
//  Spotted
//
//  Created by Joanne Lee on 8/23/18.
//  Copyright © 2018 Spotted. All rights reserved.
//

import FirebaseStorage

func imageStoragePath(_ name1: String, _ name2: String, _ count: Int) -> String {
    return "\(name1)/\(name2)/\(count).jpg"
}

func downloadImage(_ name1 : String, _ name2 : String, _ count : Int, _ callback : @escaping (Data) -> Void)  {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let imageRef = storageRef.child(imageStoragePath(name1, name2, count))

    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    let downloadTask = imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
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
        // let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
    }
    
    downloadTask.observe(.success) { snapshot in
        // Download completed successfully
    }
}

func uploadData(with data: Data, storagePath: String) {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let riversRef = storageRef.child(storagePath)
    
    let metadata = StorageMetadata()
    let uploadTask = riversRef.putData(data, metadata: metadata)
    
    // Listen for state changes, errors, and completion of the upload.
    uploadTask.observe(.resume) { snapshot in
        // Upload resumed, also fires when the upload starts
    }
    
    uploadTask.observe(.pause) { snapshot in
        // Upload paused
    }
    
    uploadTask.observe(.progress) { snapshot in
        // Upload reported progress
        //let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
        //self.ProgressView.progress = Float(percentComplete)
    }
    
    uploadTask.observe(.success) { snapshot in
        // Upload completed successfully
    }
}
