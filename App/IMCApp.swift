//
//  IMCApp.swift
//  IMC
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI

@main
struct IMCApp: App {
    // Configuración inicial para inyección de dependencias (opcional)
    @StateObject private var viewModel = IMCViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel) // Para compartir el ViewModel
                .preferredColorScheme(.light) // Fuerza tema claro (opcional)
                .onAppear {
                    // Configuración global de UI (ej: fuentes personalizadas)
                    UINavigationBar.appearance().titleTextAttributes = [
                        .font: UIFont(name: "Avenir-Heavy", size: 20)!
                    ]
                }
        }
    }
}
