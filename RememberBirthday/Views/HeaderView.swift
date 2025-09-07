//
//  HeaderView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/6/25.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let angle: Double
    let backgroundColor: Color
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(backgroundColor)
                .rotationEffect(Angle(degrees: angle))
            VStack {
                Text(title)
                    .font(.system(size: 40))
                    .foregroundColor(Color.white)
                    .bold()
                
                Text(subtitle).foregroundColor(Color.white)
            }
            .padding(.top, 40)
        }
        .frame(width: UIScreen.main.bounds.width * 3,
               height: 300)
        .offset(y: -140)
    }
}

#Preview {
    HeaderView(title: "", subtitle: "", angle: 15, backgroundColor: Color.yellow)
}
