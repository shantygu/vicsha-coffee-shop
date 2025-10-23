# ☕ Coffee Vicscha

<p align="center">
  <img src="portadaoficial.png" alt="Coffee Vicsha Banner" width="800">
</p>


**Análisis de Consumo y Estrategias de Rentabilidad**

Este repositorio contiene un análisis exploratorio de ventas de la franquicia *Vícsha Coffee*, y esta orientado a identificar patrones de consumo, productos clave y oportunidades estratégicas para mejorar la rentabilidad operativa de la franquicia ademas el estudio transforma transacciones brutas en información accionable mediante técnicas estadísticas, segmentación temporal y visualizaciones limpias.

### 📖 Descripción del Proyecto

El análisis identifica patrones de consumo, productos clave y oportunidades operativas en tres sucursales. Se aplican técnicas estadísticas, limpieza de datos y visualizaciones narrativas para optimizar la rentabilidad.

##  Planteamiento del problema

El éxito operativo y comercial de una cadena de cafeterías como 'VICSHA'  se encuentra en la capacidad de comprender y anticipar ciertos aspectos o  patrones de consumo de nuestros clientes. Comprendiendo que cada una de las transacciones registradas en sus múltiples sedes es una valiosa pieza de información que, al ser analizada, permite tomar decisiones estratégicas de alto impacto para la franquicia. Este análisis se sumerge en los datos de ventas de vicsha para entender qué impulsa el consumo, cuándo ocurre y cómo optimizarlo.

Este informe esta enfocado en realizar un Análisis Exploratorio de Datos del conjunto de datos de ventas de 'VICSHA'. Nuestro objetivo principal es convertir los datos brutos de transacciones en información práctica y útil para la toma de decisiones y asi poder optimizar la oferta de productos, gestionar el inventario y mejorar la rentabilidad en cada punto de venta.

Nos haremos preguntas sencillas para determinar puntos claves para el desarrollo y mejora de la compañía preguntadonos, ¿cómo puede una cafetería identificar sus productos estrella, sus horarios más rentables y sus oportunidades de mejora? para asi saber que  patrones de consumo revelan los datos y cómo pueden traducirse en decisiones estratégicas?

## 🎯 Objetivos del estudio

### ✅ Objetivo general

Analizar el comportamiento de consumo en la franquicia *VICSHA* a partir de datos reales de ventas, con el fin de identificar patrones de rentabilidad, segmentación temporal y oportunidades estratégicas para mejorar la eficiencia operativa y comercial.

### 📌 Objetivos específicos

- Identificar los productos con mayor impacto en los ingresos totales.
- Analizar la variación del consumo según categoría de producto.
- Detectar franjas horarias y días clave que concentran el flujo de ventas.
- Construir visualizaciones limpias y narrativas técnicas que faciliten la interpretación de los hallazgos.
- Proponer estrategias basadas en evidencia para optimizar la oferta, reforzar la operación y mejorar la experiencia del cliente.
## 🚀 Instalación


Este proyecto se ejecuta en RStudio con R Markdown. Para reproducir el análisis:

```r
install.packages

library(ggplot2)
library(dplyr)
library(readxl)
library(lubridate)
library(scales)
library(kableExtra)
library(knitr)
library(DT)

data <- read_excel("Coffee Shop Sales.xlsx")
```

## 🧪 Uso

El archivo principal es coffe_vicsha.rmd  Incluye:

• 	Procesamiento de datos: renombramiento semántico, derivación de variables, conversión de formatos.

• 	Limpieza: detección de nulos, validación estructural, revisión de extremos.

• 	Análisis por sucursal, categoría de producto, mes y turno horario.

• 	Visualizaciones: gráficos de violín, boxplots, mapas de calor, barras y pastel.

## 📊 Resultados Clave

• 	Astoria: consumo regular → operación eficiente

• 	Hell’s Kitchen: perfil mixto → oportunidad de diversificación

• 	Lower Manhattan: alto gasto → enfoque premium

• 	Café y panadería: núcleo del negocio

• 	Abril: mes pico en todas las sedes

• 	Turno mañana: 67% de ingresos → núcleo operativo

## 📸 Ver Dashboard

🔗 Explorar el dashboard interactivo  https://vicsha-coffee-shop-1.onrender.com

## 🛠️ Tecnologías

• 	Análisis: R + R Markdown

• 	Dashboard: Python + Streamlit 

• 	Datos: Excel (xlsx)

• 	Estilo visual: theme= "united" , highlight= "espresso", cafe_style.ccs

## 👥 Autoras

Victoria Díaz

Schantal Troja Gutiérrez 


