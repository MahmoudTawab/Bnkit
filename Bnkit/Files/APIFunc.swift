//
//  APIFunc.swift
//  APIFunc
//
//  Created by Emoji Technology on 27/09/2021.
//  Copyright © 2021 Mahmoud Tawab. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseStorage
import FirebaseFirestore


    func LodAPI()  {
    Firestore.firestore().collection("API").document("BaseUrls").addSnapshotListener { (querySnapshot, err) in
    if let err = err {
    print(err.localizedDescription)
    defaults.set("https://bnkitapi.azurewebsites.net/", forKey: "API")
    return
    }
    guard let data = querySnapshot?.data() else {
    defaults.set("https://bnkitapi.azurewebsites.net/", forKey: "API")
    return
    }
    DispatchQueue.main.async {
    let API = data["IOS"] as? String
    defaults.set(API, forKey: "API")
    }
    }
    }


   func AlamofireCall(Url:String,HTTP:HTTPMethod,parameters:[String:Any]?,encoding: ParameterEncoding = URLEncoding.default, Success: @escaping () -> Void = { },Array: @escaping ([[String: Any]]) -> Void = {_ in },Dictionary: @escaping ([String: Any]) -> Void = {_ in }, Err: @escaping ((String) -> Void)) {
           
    AF.sessionConfiguration.timeoutIntervalForRequest = 40
    AF.request(Url, method: HTTP, parameters: parameters, encoding: encoding) { $0.timeoutInterval = 40 }
    .validate().response(queue: .main) { response in
        
    switch response.result {
    case .success(let value):
    Success()
        
    do {
    guard let data = value else { return }
        
    if let array = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
    Array(array)
    }
            
    if let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
    Dictionary(dictionary)
    }
            
    }catch{
    Err(error.localizedDescription)
    }
        
    case .failure(let error):
    if response.response?.statusCode == 406 {
    guard let data = response.data else { return }
    if let strContent = String(data: data, encoding: .utf8) {
    Err(strContent)
    }
    }else{
    print(error)
    Err("ErrorApi".localizable)
    }
    }
    }
    }
    

    func Storag(child:[String] , image:Data , completionHandler: @escaping ((String) -> Void), Err: @escaping ((String) -> Void)) {

    let storage = Storage.storage().reference().child(child[0]).child(child[1]).child(child[2]).child(child[3])

    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
    storage.putData(image, metadata: metaData, completion: { (url, err) in
    if let err = err {
    Err(err.localizedDescription)
    return
    }
    storage.downloadURL {(url, err) in
    if let err = err {
    Err(err.localizedDescription)
    return
    }
    guard let add_downloadUrl = url?.absoluteString else{return}
    completionHandler(add_downloadUrl)
    }
    })
    }
