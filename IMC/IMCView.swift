//
//  IMCView.swift
//  IMC
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI

struct IMCView: View {
    @StateObject private var viewModel = IMCViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case age
        case weight
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    genderSection
                    heightSection
                    ageWeightSection
                    calculateButton
                }
                .padding()
            }
            .background(Color("BackgroundApp"))
            .navigationTitle("title_imc_calculator")
            .toolbar { keyboardToolbar }
            .navigationDestination(isPresented: $viewModel.showResult) {
                IMCResultView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Subviews
private extension IMCView {
    var genderSection: some View {
        HStack(spacing: 15) {
            GenderButton(
                title: "gender_male",
                icon: "figure.male",
                isSelected: viewModel.gender == .male
            ) {
                viewModel.gender = .male
            }
            
            GenderButton(
                title: "gender_female",
                icon: "figure.female",
                isSelected: viewModel.gender == .female
            ) {
                viewModel.gender = .female
            }
        }
        .frame(height: 180)
    }
    
    var heightSection: some View {
        VStack(spacing: 15) {
            Text("height_title")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text("\(viewModel.height, specifier: "%.0f") cm")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Slider(
                value: $viewModel.height,
                in: 100...250,
                step: 1,
                label: { EmptyView() },
                minimumValueLabel: { Text("100") },
                maximumValueLabel: { Text("250") }
            )
            .tint(Color("PrimaryAccent"))
            .padding(.horizontal)
        }
        .padding()
        .background(Color("BackgroundComponent"))
        .cornerRadius(15)
    }
    
    var ageWeightSection: some View {
        HStack(spacing: 15) {
            CounterCard(
                title: "age_title",
                value: $viewModel.age,
                range: 1...120,
                format: { "\($0)" }
            )
            
            CounterCard(
                title: "weight_title",
                value: $viewModel.weight,
                range: 20...300,
                format: { "\($0) kg" }
            )
        }
        .frame(height: 220)
    }
    
    var calculateButton: some View {
        Button(action: viewModel.calculateIMC) {
            HStack {
                Text("calculate_button")
                Image(systemName: "arrow.forward")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!viewModel.isFormValid)
        .opacity(viewModel.isFormValid ? 1 : 0.6)
    }
    
    var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(action: { focusedField = nil }) {
                Image(systemName: "keyboard.chevron.compact.down")
            }
        }
    }
}

// MARK: - ViewModel
final class IMCViewModel: ObservableObject {
    enum Gender: String {
        case male
        case female
    }
    
    @Published var gender: Gender = .male
    @Published var age: Int = 25
    @Published var weight: Int = 70
    @Published var height: Double = 170
    @Published var showResult = false
    
    var isFormValid: Bool {
        (20...300).contains(weight) && (100...250).contains(height)
    }
    
    func calculateIMC() {
        // Lógica de cálculo puede moverse aquí
        showResult = true
    }
}

// MARK: - Componentes Reutilizables
struct GenderButton: View {
    let title: LocalizedStringKey
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .symbolVariant(isSelected ? .fill : .none)
                
                Text(title)
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color("PrimaryAccent") : Color("BackgroundComponent"))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .animation(.easeInOut, value: isSelected)
        }
    }
}

struct CounterCard<T: Numeric & Comparable>: View {
    let title: LocalizedStringKey
    @Binding var value: T
    let range: ClosedRange<T>
    let format: (T) -> String
    
    var body: some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(format(value))
                .font(.title.bold())
            
            HStack(spacing: 20) {
                CounterButton(icon: "minus", action: decrement)
                CounterButton(icon: "plus", action: increment)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("BackgroundComponent"))
        .cornerRadius(15)
    }
    
    private func increment() {
        value = min(value + 1, range.upperBound)
    }
    
    private func decrement() {
        value = max(value - 1, range.lowerBound)
    }
}

struct CounterButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .padding(15)
                .background(Circle().fill(Color("PrimaryAccent")))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Previews
struct IMCView_Previews: PreviewProvider {
    static var previews: some View {
        IMCView()
            .environment(\.locale, .init(identifier: "es"))
    }
}
