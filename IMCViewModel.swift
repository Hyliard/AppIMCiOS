//
//  IMCViewModel.swift
//  IMC
//
//  Created by Luis Martinez on 19/05/2025.
//

import Combine
import SwiftUI

class IMCViewModel: ObservableObject {
    // MARK: - Propiedades Publicadas
    @Published var peso: String = ""
    @Published var altura: String = ""
    @Published var resultado: String = ""
    @Published var imcFormateado: String = ""
    @Published var colorClasificacion: Color = .primary
    @Published var rangoClasificacion: String = ""
    @Published var mostrarAlerta: Bool = false
    @Published var mensajeAlerta: String = ""
    
    // MARK: - Propiedades Privadas
    private let model = IMCModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Estados
    enum Estado {
        case idle
        case cargando
        case exito
        case error(IMCModel.IMCError)
    }
    
    @Published var estado: Estado = .idle
    
    // MARK: - Inicialización
    init() {
        configurarValidacionCampos()
    }
    
    // MARK: - Configuración de Validación
    private func configurarValidacionCampos() {
        Publishers.CombineLatest($peso, $altura)
            .map { peso, altura in
                !peso.isEmpty && !altura.isEmpty && self.esNumeroValido(peso) && self.esNumeroValido(altura)
            }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Lógica de Cálculo
    func calcularIMC() {
        estado = .cargando
        
        guard let peso = Double(peso.reemplazarComa),
              let altura = Double(altura.reemplazarComa) else {
            manejarError(.valorInvalido)
            return
        }
        
        do {
            let resultado = try model.calcularIMC(peso: peso, altura: altura)
            actualizarUI(resultado: resultado)
            estado = .exito
        } catch let error as IMCModel.IMCError {
            manejarError(error)
        } catch {
            manejarError(.valorInvalido)
        }
    }
    
    // MARK: - Helpers
    var calcularHabilitado: Bool {
        !peso.isEmpty && !altura.isEmpty && esNumeroValido(peso) && esNumeroValido(altura)
    }
    
    private func esNumeroValido(_ valor: String) -> Bool {
        let valorLimpio = valor.reemplazarComa
        return Double(valorLimpio) != nil && Double(valorLimpio)! > 0
    }
    
    private func actualizarUI(resultado: (imc: Double, clasificacion: IMCModel.Clasificacion)) {
        imcFormateado = String(format: "%.1f", resultado.imc)
        resultado = resultado.clasificacion.descripcion
        rangoClasificacion = resultado.clasificacion.rango
        colorClasificacion = colorParaClasificacion(resultado.clasificacion)
    }
    
    private func colorParaClasificacion(_ clasificacion: IMCModel.Clasificacion) -> Color {
        switch clasificacion {
        case .bajoPeso: return .yellow
        case .normal: return .green
        case .sobrepeso: return .orange
        case .obesidad: return .red
        }
    }
    
    private func manejarError(_ error: IMCModel.IMCError) {
        estado = .error(error)
        
        switch error {
        case .alturaCero:
            mensajeAlerta = NSLocalizedString("error_altura_cero", comment: "")
        case .valorInvalido:
            mensajeAlerta = NSLocalizedString("error_valor_invalido", comment: "")
        }
        
        mostrarAlerta = true
        resetearCamposInvalidos()
    }
    
    private func resetearCamposInvalidos() {
        if !esNumeroValido(peso) { peso = "" }
        if !esNumeroValido(altura) { altura = "" }
    }
}

// MARK: - Extensión para manejo de decimales
extension String {
    var reemplazarComa: String {
        self.replacingOccurrences(of: ",", with: ".")
    }
}
