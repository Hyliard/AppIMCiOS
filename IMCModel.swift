//
//  IMCModel.swift
//  IMC
//
//  Created by Luis Martinez on 19/05/2025.
//

import Foundation

class IMCModel {
    enum Clasificacion: String {
        case bajoPeso = "bajo_peso"
        case normal = "normal"
        case sobrepeso = "sobrepeso"
        case obesidad = "obesidad"
        
        var descripcion: String {
            NSLocalizedString(self.rawValue, comment: "")
        }
        
        var rango: String {
            switch self {
            case .bajoPeso: return "< 18.5"
            case .normal: return "18.5 - 24.9"
            case .sobrepeso: return "25 - 29.9"
            case .obesidad: return "≥ 30"
            }
        }
    }
    
    enum IMCError: Error {
        case valorInvalido
        case alturaCero
    }
    
    func calcularIMC(peso: Double, altura: Double) throws -> (imc: Double, clasificacion: Clasificacion) {
        guard peso > 0, altura > 0 else {
            throw altura == 0 ? IMCError.alturaCero : IMCError.valorInvalido
        }
        
        let imc = peso / pow(altura, 2)
        
        switch imc {
        case ..<18.5: return (imc, .bajoPeso)
        case 18.5..<25: return (imc, .normal)
        case 25..<30: return (imc, .sobrepeso)
        default: return (imc, .obesidad)
        }
    }
}
