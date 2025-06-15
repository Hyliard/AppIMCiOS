//
//  IMCView.swift
//  IMC
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI

struct IMCView: View {
    
    @State var gender: Int = 0
    @State var age: Int = 18
    @State var weight: Int = 80
    @State var height: Double = 150
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                HStack {
                    ToggleButton(text: "Hombre", imageName: "m.circle.fill", gender: 0, selectedGender: $gender )
                    ToggleButton(text: "Mujer", imageName: "f.circle.fill", gender: 1, selectedGender: $gender)
                }
                
                HeightCalculator(selectedHeight: $height)
                
                HStack {
                    CounterButton(text: "Edad", number: $age)
                    CounterButton(text: "Peso", number: $weight)
                }
                
                IMCCalculateButton(userWeight: Double(weight), userHeight: height)
                
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundApp"))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("IMC Calculator")
                        .bold()
                        .foregroundColor(.secondary)
                }
            }
            
        }
        
    }
    
}



struct IMCCalculateButton: View {
    let userWeight: Double
    let userHeight: Double
    
    var body: some View {
        NavigationLink(destination: IMCResult(userWeight: userWeight, userHeight: userHeight)) {
            Text("Calcular IMC")
                .font(.system(size: UIScreen.main.bounds.width < 375 ? 20 : 25))
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.purple)
                .cornerRadius(15)
                .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 5)
                .padding(.horizontal)

        }
    }
}

struct ToggleButton:View {
    let text:String
    let imageName:String
    let gender:Int
    @Binding var selectedGender:Int
    
    var body: some View {
        let isSelected = (gender == selectedGender)
        let color = isSelected ? Color("BackgroundComponentSelected") : Color("backgroundComponent")

        Button(action: {
            selectedGender = gender
        }) {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(isSelected ? .purple : .primary)
                Text(text)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
            .cornerRadius(10)
            .accessibilityLabel(Text("Género: \(text)"))
        }
    }
}


struct InformationText:View {
    let text:String
    var body: some View {
        Text(text).font(.largeTitle).bold().foregroundColor(.white)
    }
}

struct TitleText:View {
    let text:String

    var body: some View {
        Text(text).font(.title2).foregroundColor(.gray)
    }
}

struct HeightCalculator:View {
    @Binding var selectedHeight:Double
    
    var body: some View {
        VStack{
            TitleText(text: "Altura")
            InformationText(text: "\(Int(selectedHeight)) cm")
            Slider(value: $selectedHeight, in:100...220, step: 1).accentColor(.purple).padding(.horizontal, 16)
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity).background(Color("backgroundComponent"))
    }
}

struct CounterButton:View {
    let text:String
    @Binding var number:Int
    var body: some View {
        VStack{
            TitleText(text: text)
            InformationText(text: String(number))
            HStack{
                Button(action:{
                    if(number > 0){
                        number -= 1
                    }
                }){
                    ZStack{
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.purple)
                        Image(systemName: "minus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                        
                    }
                }
                Button(action:{
                    if(number < 150){
                        number += 1
                    }
                }){
                    ZStack{
                        Circle()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.purple)
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                        
                    }
                }
            }
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity).background(Color("backgroundComponent"))
    }
}

struct IMCView_Previews: PreviewProvider {
    static var previews: some View {
        IMCView()
    }
}


