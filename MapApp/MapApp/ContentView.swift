//
//  ContentView.swift
//  MapApp
//
//  Created by 藤 治仁 on 2020/08/14.
//

import SwiftUI
import MapKit

// MapAnnotationProtocolに適用させるための構造体
struct AnnotationItemStruct:Identifiable{
    // ID(識別子)
    let id = UUID()
    // 緯度経度
    let coordinate:CLLocationCoordinate2D
}

struct ContentView: View {
    // 入力するキーワード
    @State var keyword: String = ""
    // 地図の表示位置
    @State var coordinate = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.0, longitude: 138), latitudinalMeters: 2000000, longitudinalMeters: 2000000)
    // ピンの位置を格納するArray
    @State var annotationItems: [AnnotationItemStruct] = []
    
    var body: some View {
        VStack {
            // 文字を入力
            TextField("Keyword", text: $keyword) { (result) in
                //None
            } onCommit: {
                // CLGeocoderインスタンスを取得
                let geocoder = CLGeocoder()
                
                // 入力された文字から位置情報を取得
                geocoder.geocodeAddressString( keyword ) { (placemarks, error) in
                    // リクエストの結果が存在し、1件目の情報から位置情報を取り出す
                    if let placemarks = placemarks ,
                       let firstPlacemark = placemarks.first ,
                       let location = firstPlacemark.location {
                        
                        // 位置情報から緯度経度をtargetCoordinateに取り出す
                        let pinCoordinate = location.coordinate
                        
                        // ピンの情報に置く場所の緯度経度を設定
                        let annotationItem = AnnotationItemStruct(coordinate: pinCoordinate)
                        
                        // ピンを地図に置く
                        annotationItems.append(annotationItem)
                        
                        // 緯度経度を中心にして半径500mの範囲を表示
                        coordinate = MKCoordinateRegion(
                            center: pinCoordinate,
                            latitudinalMeters: 500.0,
                            longitudinalMeters: 500.0)
                    }
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            // 地図を表示
            Map(coordinateRegion: $coordinate, annotationItems: annotationItems) { annotationItem in
                // annotationItemsから１つ取りだした情報からピンを打つ
                MapPin(coordinate: annotationItem.coordinate)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
