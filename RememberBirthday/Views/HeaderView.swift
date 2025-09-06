//
//  HeaderView.swift
//  RememberBirthday
//
//  Created by BigMacProMeal on 9/6/25.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color.yellow)
                .rotationEffect(Angle(degrees: 15))
            VStack {
                Text("Remember Birthday")
                    .font(.system(size: 40))
                    .foregroundColor(Color.white)
                    .bold()
                
                Text("Never forget your birthday again!").foregroundColor(Color.white)
            }
            .padding(.top, 40)
        }
        .frame(width: UIScreen.main.bounds.width * 3,
               height: 300)
        .offset(y: -100)
    }
}

#Preview {
    HeaderView()
}
