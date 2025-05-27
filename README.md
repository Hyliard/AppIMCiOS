# 📱 IMC Calculator – SwiftUI

Calculadora de Índice de Masa Corporal (IMC) desarrollada en **SwiftUI**. Esta aplicación permite al usuario ingresar su sexo, edad, peso y estatura para calcular su IMC y mostrar el resultado con una interpretación visual y textual.

## 🧮 ¿Qué es el IMC?

El Índice de Masa Corporal (IMC) es una medida que relaciona el peso con la altura. Es útil como referencia general para evaluar el estado nutricional de una persona.

## ✨ Características

- Selección de género: Hombre / Mujer
- Controles interactivos para:
  - Edad
  - Peso
  - Altura
- Cálculo del IMC al presionar un botón
- Pantalla de resultados con:
  - IMC numérico
  - Categoría (peso bajo, normal, sobrepeso, obesidad)
  - Color asociado a la categoría

## 🛠️ Tecnologías

- **Swift 5**
- **SwiftUI**
- Arquitectura en componentes reutilizables (botones, contadores, vistas)
- Colores personalizados definidos en `Assets.xcassets`

## 🚀 Cómo ejecutar el proyecto

1. Clona el repositorio:

   ```bash
   git clone https://github.com/tu_usuario/IMC.git

2. Abre IMC.xcodeproj en Xcode (preferiblemente Xcode 15 o superior).

3. Ejecuta el proyecto en el simulador o en tu dispositivo iOS.
📂 Estructura del proyecto

IMC/
├── IMCApp.swift           # Punto de entrada de la app
├── IMCView.swift          # Vista principal con inputs
├── IMCResult.swift        # Vista del resultado con interpretación
├── MenuView.swift         # (opcional) Menú de navegación si existe
├── Assets.xcassets        # Paleta de colores personalizados
├── Preview Content        # Vistas de prueba
├── .gitignore             # Ignora archivos temporales y del sistema
└── README.md              # Este archivo
🎨 Capturas de pantalla (opcional)


📄 Licencia

Este proyecto fue desarrollado por Hyliard como parte de su aprendizaje en SwiftUI. Puedes usarlo con fines educativos o personales.
