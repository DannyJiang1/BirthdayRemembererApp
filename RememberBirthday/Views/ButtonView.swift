//
//  ButtonView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/6/25.
//

import SwiftUI

struct ButtonView: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(backgroundColor)
                
                Text(title)
                    .foregroundColor(Color.white)
                    .bold()
            }
        }
    }
}

#Preview {
    ButtonView(title: "title",
               backgroundColor: .blue){
        // Action
    }
}
