//
//  IMCResultView.swift
//  IMC
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI

struct IMCResultView: View {
    @ObservedObject var viewModel: IMCViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color("BackgroundApp")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                navigationHeader
                resultGauge
                classificationCard
                recommendationsSection
                actionButtons
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Subviews
private extension IMCResultView {
    var navigationHeader: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            Spacer()
            Text("result_title")
                .font(.title.bold())
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.bottom, 20)
    }
    
    var resultGauge: some View {
        Gauge(value: viewModel.imcValue, in: 10...50) {
            Text("IMC")
                .font(.system(.caption, design: .rounded))
        } currentValueLabel: {
            Text("\(viewModel.imcValue, specifier: "%.1f")")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
        }
        .gaugeStyle(.accessoryCircular)
        .tint(Gradient(colors: [.blue, .green, .yellow, .orange, .red]))
        .scaleEffect(1.5)
        .padding(.vertical, 30)
        .accessibilityLabel("imc_value \(viewModel.imcValue)")
    }
    
    var classificationCard: some View {
        VStack(spacing: 15) {
            Text(viewModel.classification.title)
                .font(.title2.bold())
                .foregroundColor(viewModel.classification.color)
            
            Text(viewModel.classification.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal)
        }
        .padding()
        .background(Color("BackgroundComponent"))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, y: 3)
    }
    
    var recommendationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("health_recommendations")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(viewModel.recommendations, id: \.self) { recommendation in
                HStack(alignment: .top) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .padding(.top, 5)
                    Text(recommendation)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(Color("BackgroundComponent"))
        .cornerRadius(15)
    }
    
    var actionButtons: some View {
        HStack(spacing: 15) {
            Button(action: { dismiss() }) {
                Text("recalculate_button")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            Button(action: { viewModel.saveResult() }) {
                Image(systemName: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding(.top, 20)
    }
}

// MARK: - ViewModel Integration
final class IMCViewModel: ObservableObject {
    @Published var imcValue: Double
    @Published var classification: IMClassification
    
    private let weight: Double
    private let height: Double
    
    init(weight: Double, height: Double) {
        self.weight = weight
        self.height = height
        self.imcValue = weight / pow(height/100, 2)
        self.classification = IMClassification.classify(imcValue)
    }
    
    var recommendations: [String] {
        classification.recommendations
    }
    
    func saveResult() {
        // Lógica para guardar en CoreData/HealthKit
    }
}

// MARK: - Classification Model
enum IMClassification {
    case underweight
    case normal
    case overweight
    case obese
    
    var title: LocalizedStringKey {
        switch self {
        case .underweight: return "underweight_title"
        case .normal: return "normal_weight_title"
        case .overweight: return "overweight_title"
        case .obese: return "obese_title"
        }
    }
    
    var description: LocalizedStringKey {
        switch self {
        case .underweight: return "underweight_description"
        case .normal: return "normal_weight_description"
        case .overweight: return "overweight_description"
        case .obese: return "obese_description"
        }
    }
    
    var color: Color {
        switch self {
        case .underweight: return Color("UnderweightColor")
        case .normal: return Color("NormalWeightColor")
        case .overweight: return Color("OverweightColor")
        case .obese: return Color("ObeseColor")
        }
    }
    
    var recommendations: [LocalizedStringKey] {
        switch self {
        case .underweight:
            return ["rec_underweight_1", "rec_underweight_2"]
        case .normal:
            return ["rec_normal_1", "rec_normal_2"]
        case .overweight:
            return ["rec_overweight_1", "rec_overweight_2"]
        case .obese:
            return ["rec_obese_1", "rec_obese_2"]
        }
    }
    
    static func classify(_ value: Double) -> IMClassification {
        switch value {
        case ..<18.5: return .underweight
        case 18.5..<25: return .normal
        case 25..<30: return .overweight
        default: return .obese
        }
    }
}

// MARK: - Localization
/*
 Localizable.strings:

 "result_title" = "Tu resultado";
 "health_recommendations" = "Recomendaciones de salud";
 "recalculate_button" = "Recalcular";
 
 "underweight_title" = "Peso Bajo";
 "underweight_description" = "Estás por debajo del peso recomendado según el IMC.";
 "rec_underweight_1" = "Aumentar consumo de proteínas";
 "rec_underweight_2" = "Realizar entrenamiento de fuerza";
 
 "normal_weight_title" = "Peso Normal";
 "normal_weight_description" = "Estás en el rango de peso saludable.";
 "rec_normal_1" = "Mantener dieta balanceada";
 "rec_normal_2" = "Ejercicio regular 150min/semana";
 
 "overweight_title" = "Sobrepeso";
 "overweight_description" = "Estás por encima del peso recomendado.";
 "rec_overweight_1" = "Reducir alimentos procesados";
 "rec_overweight_2" = "Aumentar actividad física diaria";
 
 "obese_title" = "Obesidad";
 "obese_description" = "Consulta con un profesional de la salud.";
 "rec_obese_1" = "Programa de pérdida de peso supervisado";
 "rec_obese_2" = "Control médico regular";
 */
