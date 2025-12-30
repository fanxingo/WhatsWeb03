//
//  FileManager.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/26.
//

import ZIPFoundation
import Foundation

class FileDefManager {
    static func handleZipFile(url: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        guard url.pathExtension.lowercased() == "zip" else { return }
        let fileManager = Foundation.FileManager.default
        do {
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsURL.appendingPathComponent("ChatFile").appendingPathComponent(UUID().uuidString)
            if !fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            }
            try fileManager.unzipItem(at: url, to: destinationURL)
            completion(.success(destinationURL))
        } catch {
            print("❌ 解压失败: \(error)")
            completion(.failure(error))
        }
    }
    
    static func saveZipFileNameToTxt(zipFilePath: String, saveTo directoryPath: String) {
        let zipFileName = (zipFilePath as NSString).lastPathComponent
        let saveURL = URL(fileURLWithPath: directoryPath).appendingPathComponent("ChatFileUserName.txt")
        do {
            try zipFileName.write(to: saveURL, atomically: true, encoding: .utf8)
            print("✅ 文件名写入成功: \(saveURL.path)")
        } catch {
            print("❌ 文件名写入失败: \(error)")
        }
    }
    static func deleteFile(at url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
            print("✅ 文件删除成功: \(url.path)")
        } catch {
            print("❌ 文件删除失败: \(error)")
        }
    }
    
    static func listChatFileDirectories() -> [URL] {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let chatFileURL = documentsURL.appendingPathComponent("ChatFile")
        var directories: [URL] = []
        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: chatFileURL.path, isDirectory: &isDir), isDir.boolValue else {
            return []
        }
        do {
            let contents = try fileManager.contentsOfDirectory(at: chatFileURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles])
            for url in contents {
                let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                if resourceValues.isDirectory == true {
                    directories.append(url)
                }
            }
        } catch {
            print("❌ 获取子目录失败: \(error)")
        }
        return directories
    }
    
    static func getChatMessage(directoryPath: String, fileName: String) -> String {
        let fileURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(fileName)
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("❌ 文件不存在: \(fileURL.path)")
            deleteFile(at: URL(fileURLWithPath: directoryPath))
            NotificationCenter.default.post(
                name: .didReceiveSharedFileURL,
                object: directoryPath
            )
            return ""
        }
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            return content
        } catch {
            print("❌ 读取文件失败: \(error)")
            deleteFile(at: URL(fileURLWithPath: directoryPath))
            NotificationCenter.default.post(
                name: .didReceiveSharedFileURL,
                object: directoryPath
            )
            return ""
        }
    }
    
    /// 根据 contentName 查找文件并返回完整路径
    static func getFileName(contentName: String, dicName: String) -> String {
        let fileManager = FileManager.default

        do {
            let fileList = try fileManager.contentsOfDirectory(atPath: dicName)
            for file in fileList {
                if contentName.contains(file) {
                    return dicName + file
                }
            }
        } catch {
            print("❌ 获取文件列表失败: \(error)")
        }

        return ""
    }
    
    static func deleteChatFileDirectory(withID id: String, completion: (Bool) -> Void) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let chatFileURL = documentsURL.appendingPathComponent("ChatFile").appendingPathComponent(id)
        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: chatFileURL.path, isDirectory: &isDir), isDir.boolValue else {
            print("❌ 目录不存在: \(chatFileURL.path)")
            completion(false)
            return
        }
        do {
            try fileManager.removeItem(at: chatFileURL)
            print("✅ 目录删除成功: \(chatFileURL.path)")
            completion(true)
        } catch {
            print("❌ 目录删除失败: \(error)")
            completion(false)
        }
    }
}
