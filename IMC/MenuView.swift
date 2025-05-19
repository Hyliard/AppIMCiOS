//
//  MenuView.swift
//  IMC
//
//  Created by Hyliard on 25/11/2024.
//

import SwiftUI

struct MenuView: View {
    @State private var isTitleVisible = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()
                
                VStack(spacing: 0) {
                    headerSection
                        .opacity(isTitleVisible ? 1 : 0)
                        .animation(.easeIn.delay(0.2), value: isTitleVisible)
                    
                    mainContentSection
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
            .onAppear { isTitleVisible = true }
        }
    }
}

// MARK: - Subviews
private extension MenuView {
    var headerSection: some View {
        VStack(spacing: 20) {
            Text("app_title")
                .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                .foregroundColor(.white)
                .transition(.move(edge: .top))
            
            Image("body-mass")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .padding(.vertical)
        }
    }
    
    var mainContentSection: some View {
        VStack(spacing: 30) {
            NavigationLink(destination: IMCView()) {
                MenuButton(
                    title: "enter_data_button",
                    icon: "person.fill.viewfinder",
                    colors: [.green, .mint]
                )
            }
            
            NavigationLink(destination: HistoryView()) {
                MenuButton(
                    title: "view_history_button",
                    icon: "clock.arrow.circlepath",
                    colors: [.blue, .purple]
                )
            }
            
            NavigationLink(destination: SettingsView()) {
                MenuButton(
                    title: "settings_button",
                    icon: "gearshape.fill",
                    colors: [.orange, .yellow]
                )
            }
        }
        .padding(.top, 40)
    }
}

// MARK: - Componentes Reutilizables
struct MenuButton: View {
    let title: LocalizedStringKey
    let icon: String
    let colors: [Color]
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
            
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, y: 3)
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
    }
}

struct AppBackground: View {
    var body: some View {
        Color("BackgroundApp")
            .ignoresSafeArea()
            .overlay(
                LinearGradient(
                    colors: [.clear, .black.opacity(0.2)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
}

// MARK: - Previews
struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environment(\.locale, .init(identifier: "es"))
    }
}
