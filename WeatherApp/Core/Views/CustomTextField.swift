//
//  CustomTextField2.swift
//  WeatherApp
//
//  Created by Samson Oluwapelumi on 28/08/2025.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    var placeholderColor: Color = .gray
    var placeholderFont: Font = .body
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            TextField("", text: $text)
                .frame(height: 50)
                .autocorrectionDisabled()
                .padding(.horizontal, 15)
                .foregroundColor(.black)
                .background(Color("TextfiledColor").cornerRadius(10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black)
                )
                .frame(height: 50)
                .padding(.horizontal, 20)

            
            Text(placeholder)
                .foregroundColor(Color("buttonBlue"))
                .font(.custom("Poppins-Regular", size: 10))
                .padding(.horizontal, 20)
        }

    }
}
