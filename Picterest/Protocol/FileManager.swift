//
//  FileManager.swift
//  Picterest
//
//  Created by 조성빈 on 2022/07/30.
//

import UIKit

protocol FileManagerProtocol {
    func saveImageToFilemanager(_ image : UIImage, _ name : String) -> String
    func deleteImageFromFilemanager(_ name : String)
    func getSavedPhotoListFromFilemanager()
    func getSavedPhotoFromFilemanager(_ name : String) -> UIImage?
}
