//
//  MainView.swift
//  IMC
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = IMCViewModel()
    @FocusState private var campoActivo: Campo?
    
    enum Campo: Hashable {
        case peso
        case altura
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    inputSection
                    resultadoSection
                    consejosSection
                }
                .padding()
            }
            .navigationTitle("Calculadora IMC")
            .toolbar { keyboardToolbar }
            .alert("Error", isPresented: $viewModel.mostrarAlerta) {
                Button("OK") { viewModel.estado = .idle }
            } message: {
                Text(viewModel.mensajeAlerta)
            }
            .animation(.easeInOut, value: viewModel.estado)
        }
    }
    
    private var headerSection: some View {
        VStack {
            Image("IMCLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .padding(.bottom, 8)
            
            Text("ingresa_datos")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var inputSection: some View {
        Group {
            TextField("peso_placeholder", text: $viewModel.peso)
                .keyboardType(.decimalPad)
                .focused($campoActivo, equals: .peso)
                .inputStyle(icon: "scalemass", isValid: viewModel.esNumeroValido(viewModel.peso))
            
            TextField("altura_placeholder", text: $viewModel.altura)
                .keyboardType(.decimalPad)
                .focused($campoActivo, equals: .altura)
                .inputStyle(icon: "ruler", isValid: viewModel.esNumeroValido(viewModel.altura))
            
            Button(action: viewModel.calcularIMC) {
                Label("calcular_button", systemImage: "function")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!viewModel.calcularHabilitado)
            .opacity(viewModel.calcularHabilitado ? 1 : 0.6)
        }
    }
    
    private var resultadoSection: some View {
        Group {
            switch viewModel.estado {
            case .cargando:
                ProgressView()
                    .transition(.opacity)
                
            case .exito:
                VStack(spacing: 16) {
                    Text("resultado_titulo")
                        .font(.title2.bold())
                        .foregroundColor(viewModel.colorClasificacion)
                    
                    Gauge(value: Double(viewModel.imcFormateado) ?? 0, in: 10...50) {
                        Text(viewModel.imcFormateado)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    } currentValueLabel: {
                        Text("IMC")
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(Gradient(colors: [.blue, .green, .yellow, .orange, .red]))
                    .scaleEffect(1.4)
                    .padding()
                    
                    VStack(spacing: 8) {
                        Text(viewModel.resultado)
                            .font(.title3)
                        Text(viewModel.rangoClasificacion)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(15)
                .transition(.scale.combined(with: .opacity))
                
            default:
                EmptyView()
            }
        }
    }
    
    private var consejosSection: some View {
        Group {
            if case .exito = viewModel.estado {
                VStack(alignment: .leading, spacing: 12) {
                    Text("consejos_salud")
                        .font(.headline)
                    
                    switch viewModel.resultado {
                    case IMCModel.Clasificacion.bajoPeso.descripcion:
                        Text("consejo_bajo_peso")
                    case IMCModel.Clasificacion.normal.descripcion:
                        Text("consejo_normal")
                    case IMCModel.Clasificacion.sobrepeso.descripcion:
                        Text("consejo_sobrepeso")
                    default:
                        Text("consejo_obesidad")
                    }
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(12)
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    private var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(action: { campoActivo = nil }) {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
    }
}

// MARK: - Modificador Personalizado
struct InputStyle: ViewModifier {
    let icon: String
    let isValid: Bool
    
    func body(content: Content) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isValid ? .blue : .secondary)
                .frame(width: 30)
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isValid ? Color.blue.opacity(0.5) : Color.red.opacity(0.3), lineWidth: 1.5)
        )
        .animation(.easeOut(duration: 0.2), value: isValid)
    }
}

extension View {
    func inputStyle(icon: String, isValid: Bool) -> some View {
        modifier(InputStyle(icon: icon, isValid: isValid))
    }
}
