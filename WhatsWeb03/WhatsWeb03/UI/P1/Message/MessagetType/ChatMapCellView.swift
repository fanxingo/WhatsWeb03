//
//  Untitled.swift
//  WhatsWeb03
//
//  Created by zy-14 on 2025/12/29.
//

import SwiftUI
import MapKit

struct ChatMapCellView: View {
    let message: ChatMessageModel
    let isSelf: Bool

    @State private var titleText: String = ""
    @State private var addressText: String = ""

    private var coordinate: CLLocationCoordinate2D {
        extractCoordinates(from: message.content)
    }
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    private func reverseGeocode() {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, error == nil {
                let name = placemark.name ?? ""
                let country = placemark.country ?? ""
                let postalCode = placemark.postalCode ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let subAdministrativeArea = placemark.subAdministrativeArea ?? ""
                let locality = placemark.locality ?? ""
                let subLocality = placemark.subLocality ?? ""
                let thoroughfare = placemark.thoroughfare ?? ""
                let subThoroughfare = placemark.subThoroughfare ?? ""

                self.titleText = name
                self.addressText = country
                    + postalCode
                    + administrativeArea
                    + subAdministrativeArea
                    + locality
                    + subLocality
                    + thoroughfare
                    + subThoroughfare
            } else {
                self.titleText = "Unable to obtain address".localized()
                self.addressText = ""
            }
        }
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isSelf {
                Spacer()
                CustomText(
                    text: message.time,
                    fontName: Constants.FontString.medium,
                    fontSize: 10,
                    colorHex: "#AEAEAEFF"
                )
                .padding(.bottom, 2)
            }
            VStack(alignment: .leading, spacing: 4) {
                MapView(region: region)
                    .frame(width: 180, height: 160)
                    .cornerRadius(10)
                    .onTapGesture {
                        let urlString = "http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)"
                        if let url = URL(string: urlString) {
                            UIApplication.shared.open(url)
                        }
                    }

                if !titleText.isEmpty {
                    CustomText(text: titleText,fontName: Constants.FontString.semibold, fontSize: 14, colorHex: "#101010FF")
                }
                if !addressText.isEmpty {
                    CustomText(text: addressText,fontName: Constants.FontString.medium, fontSize: 12, colorHex: "#7D7D7DFF")
                }
            }
            .padding(12)
            .background(isSelf ? Color(hex: "#71FF89FF") : Color(hex: "#FFFFFFFF"))
            .cornerRadius(10)
            .onAppear {
                reverseGeocode()
            }
            if !isSelf {
                CustomText(
                    text: message.time,
                    fontName: Constants.FontString.medium,
                    fontSize: 10,
                    colorHex: "#AEAEAEFF"
                )
                .padding(.bottom, 2)
            }
            if !isSelf { Spacer() }
        }
    }
}

func extractCoordinates(from urlString: String) -> CLLocationCoordinate2D {
    guard
        let equalIndex = urlString.firstIndex(of: "=")
    else {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    let coordinatePart = urlString[urlString.index(after: equalIndex)...]
    let components = coordinatePart.split(separator: ",")

    guard components.count >= 2,
          let lat = Double(components[0]),
          let lon = Double(components[1]) else {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }

    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
}

struct MapView: View {
    let region: MKCoordinateRegion
    @State private var cameraPosition: MapCameraPosition

    init(region: MKCoordinateRegion) {
        self.region = region
        _cameraPosition = State(initialValue: .region(region))
    }

    var body: some View {
        Map(position: $cameraPosition) {
            Marker("", coordinate: region.center)
        }
    }
}
 
