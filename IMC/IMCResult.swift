//
//  IMCResult.swift
//  IMC
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI

struct IMCResult: View {
    let userWeight: Double
    let userHeight: Double

    var result: Double {
        calculateImc(weight: userWeight, height: userHeight)
    }

    var body: some View {
        VStack {
            Text("Tu resultado")
                .font(.title)
                .bold()
                .foregroundColor(.white)

            InformationView(result: result)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundApp"))
    }
}


func calculateImc(weight: Double, height: Double) -> Double {
    // Calcular el IMC usando height correctamente
    let result = weight / ((height / 100) * (height / 100))
    return result
}

struct InformationView: View {
    let result: Double
    
    var body: some View {
        let information = getImcResult(result: result)
        
        VStack {
            Spacer()
            
            // Título con color dinámico
            Text(information.0)
                .foregroundColor(information.2)
                .font(.title)
                .bold()
            
            Spacer()
            
            // Mostrar el IMC calculado
            Text("\(result, specifier: "%.2f")")
                .font(.system(size: 80))
                .bold()
                .foregroundColor(.white)
            
            Spacer()
            
            // Descripción con padding horizontal
            Text(information.1)
                .foregroundColor(.white)
                .font(.title2)
                .padding(.horizontal, 16) // Aumenté el padding para mayor visibilidad
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("backgroundComponent"))
        .cornerRadius(16)
        .padding(16)
    }
}

func getImcResult(result: Double) -> (String, String, Color) {
    let title: String
    let description: String
    let color: Color
    
    switch result {
    case 0.00...18.5:
        title = "Peso Bajo"
        description = "Estás por debajo del peso recomendado según el IMC."
        color = Color.yellow
    case 18.5...24.9:
        title = "Peso Normal"
        description = "Estás en el peso recomendado según el IMC."
        color = Color.green
    case 25...29.9:
        title = "Sobrepeso"
        description = "Estás por encima del peso recomendado según el IMC."
        color = Color.orange
    case 30...100:
        title = "Obesidad"
        description = "Estás muy por encima del peso recomendado según el IMC."
        color = Color.red
    default:
        title = "ERROR"
        description = "Ha ocurrido un error"
        color = Color.gray
    }
    
    return (title, description, color)
}

struct IMCResult_Previews: PreviewProvider {
    static var previews: some View {
        IMCResult(userWeight: 80, userHeight: 190)
    }
}

