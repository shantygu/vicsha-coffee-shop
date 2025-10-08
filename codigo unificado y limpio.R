library(readxl)
library(dplyr)
library (tidyverse)
library(knitr)
library(kableExtra)
library(lubridate)
library(reshape2)
library(ggplot2)

data_coffe <- data.frame(read_excel("C:/Users/sytpr/Documents/Coffee Shop Sales.xlsx"))

# Evaluar los elementos de cada una de las variables.
# Categorías a las que pertenecen cada uno de los productos. 
elementos_productcategory <- data_coffe %>%
  distinct(product_category) %>%
  arrange(product_category)

print(elementos_productcategory)

#Sucursales a la que pertenecen los registros.
elementos_storelocation <- data_coffe %>%
  distinct(store_location) %>%
  arrange(store_location)

print(elementos_storelocation)

#Productos que se ofrecen en las distintas sucursales. 
elementos_producttype <- data_coffe %>%
  distinct(product_type) %>%
  arrange(product_type)

print(elementos_producttype)

#Fechas existentes dentro de la base de datos.  
fechas <- data_coffe %>%
  distinct(transaction_date) %>%
  arrange(transaction_date)

print(fechas)

#Obtenemos los nombres de nuestras variables en el DF y nos aseguramos de comprender cómo están construidas y estructuradas las variables.
str(data_coffe)

#Desarrollamos éste df para documentar el análisis exploratorio y la toma de decisiones en la modificación de las variables 
resumen_analisis_exploratorio <- data.frame( 
  `Variable por Defecto` = c('transaction_id','transaction_date','transaction_time','transaction_qty','store_id','store_location','product_id','unit_price','product_category','product_type',
                             'product_detail','total_ingresos'),
  `Tipo de Variable` = c('cualitativa nominal politómica', 'cualitativa nominal politómica','cualitativa nominal politómica','cuantitativa de razón','cualitativa nominal politómica','cualitativa nominal politómica',
                         'cualitativa nominal politómica','cuantitativa de razón','cualitativa nominal politómica','cualitativa nominal politómica','cualitativa nominal politómica','cuantitativa de razón'),
  `Tipo de Dato` = c('num','POSIXct','POSIXct','num','num','chr','num','num','chr','chr','chr','num'),
  `Cambios` =c('modificar el nombre','modificar el nombre y el formato de la fecha','modificar el nombre y el formato de la hora','modificar el nombre','modificar el nombre','modificar el nombre',
               'modificar el nombre','modificar el nombre','modificar el nombre','modificar el nombre','modificar el nombre','nueva variable')
)%>%
  kable(
    caption = "Análisis Exploratorio y Modificación de Variables",
    col.names = c("Variable por Defecto", "Tipo de Variable", "Tipo de Dato", "Cambios"),
    align = c("l", "l", "c", "l")
  ) %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed"),
    full_width = FALSE,
    font_size = 12,
    position = "center"
  ) %>%
  row_spec(0, bold = TRUE, background = "#f8f9fa") %>%
  column_spec(1, width = "3cm") %>%
  column_spec(2, width = "4cm") %>%
  column_spec(3, width = "2.5cm") %>%
  column_spec(4, width = "3cm") %>%
  footnote(
    general = "Documentación del proceso de transformación de variables para el análisis.",
    general_title = "Nota:"
  )


#Aplicamos las modificaciones documentadas en nuestro nuevo dataframe, que será el que utilizaremos como base para el resto del trabajo. 
vicsha_basededatos <- data_coffe %>%
  rename(
    id_transaccion = transaction_id,
    fecha_de_transaccion = transaction_date,
    hora_de_transaccion = transaction_time,
    cantidad_vendida = transaction_qty,
    id_tienda = store_id,
    ubicacion_tienda = store_location,
    id_producto = product_id,
    precio_unitario = unit_price,
    categoria_producto = product_category,
    tipo_de_producto = product_type,
    detalles_del_producto = product_detail
  )%>%
  mutate(
    total_ingresos = cantidad_vendida * precio_unitario,
    mes_abreviado = toupper(paste("MES", format(fecha_de_transaccion, "%b")))
  )

vicsha_basededatos <- vicsha_basededatos %>%
  mutate(
    hora_de_transaccion = ymd_hms(hora_de_transaccion),  # convertir a datetime
    hora = hour(hora_de_transaccion),
    turno = case_when(
      hora >= 6 & hora < 14 ~ "HORARIO DE LA MAÑANA",
      hora >= 14 & hora < 22 ~ "HORARIO DE LA TARDE/NOCHE",
      TRUE ~ "HORARIO DE LA NOCHE"
    )
  )
#Verificamos los cambios en la nueva base de datos antes de pasar a la limpieza.
view(vicsha_basededatos)

#PROCESO DE LIMPIEZA DE LA BASE DE DATOS. 

# Verificar cuántos valores nulos hay por columna
valores_nulos <- colSums(is.na(vicsha_basededatos))
print(valores_nulos)

# Porcentaje de nulos por columna
porcentaje_nulos <- colMeans(is.na(vicsha_basededatos)) * 100
print(porcentaje_nulos)

# Creamos un resumen de los valores nulos 
resumen_nulos <- vicsha_basededatos %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Nulos") %>%
  mutate(Porcentaje = round((Nulos / nrow(vicsha_basededatos)) * 100, 2))

# Creamos el gráfico que permita visualizar los valores nulos 
ggplot(resumen_nulos, aes(x = Variable, y = Porcentaje)) +
  geom_bar(stat = "identity", fill = ifelse(resumen_nulos$Nulos > 0, "red", "green"), alpha = 0.7) +
  geom_text(aes(label = ifelse(Nulos > 0, paste0(Nulos, " (", Porcentaje, "%)"), "Sin nulos")), 
            vjust = -0.5, size = 3) +
  labs(title = "Porcentaje de Valores Nulos por Variable",
       subtitle = paste("Total de observaciones:", nrow(vicsha_basededatos)),
       x = "Variables", 
       y = "Porcentaje de Nulos (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        plot.title = element_text(size = 14, face = "bold")) +
  ylim(0, max(resumen_nulos$Porcentaje) + 5)

# Verificar precios y cantidades razonables
summary(vicsha_basededatos$precio_unitario)
summary(vicsha_basededatos$cantidad_vendida)

# ¿Hay precios negativos o cero?
sum(vicsha_basededatos$precio_unitario <= 0)
sum(vicsha_basededatos$cantidad_vendida <= 0)


#CALCULOS POR TIENDA. 
#Creamos las funciones que necesitaremos más adelante que no vienen incluidas con R. 

desviacion_mediana <- function(x) {
  # Validaciones
  if (length(x) == 0 || all(is.na(x))) {
    return(NA)
  }
  
  x <- na.omit(x)
  med <- median(x)
  
  # Para evitar problemas con un solo valor
  if (length(x) == 1) {
    return(0)
  }
  
  # Calcular la desviación mediana correctamente
  sqrt(mean((x - med)^2))
}

#FUNCION PARA APLICAR EL ANÁLISIS ESTADÍSTICO 

analizar_y_formatear <- function(df, grupo, 
                                 titulo = "Análisis Estadístico de Ingresos",
                                 subtitulo = NULL,
                                 nota = NULL) {
  
  # Validaciones iniciales 
  if (!exists(deparse(substitute(df)))) {
    stop("El dataframe no existe")
  }
  
  if (!deparse(substitute(grupo)) %in% names(df)) {
    stop("La variable de agrupación no existe en el dataframe")
  }
  
  # Calcular estadísticas de interés para el análisis de cada tienda
  resultado <- df %>%
    group_by(across({{grupo}})) %>%
    summarise(
      transacciones = n(),
      ingreso_total = sum(total_ingresos, na.rm = TRUE),
      ingreso_minimo = min(total_ingresos, na.rm = TRUE),
      ingreso_maximo = max(total_ingresos, na.rm = TRUE),
      rango_ingresos = ingreso_maximo - ingreso_minimo,
      ingreso_promedio = mean(total_ingresos, na.rm = TRUE),
      ingreso_mediano = median(total_ingresos, na.rm = TRUE),
      desviacion_ingresos = sd(total_ingresos, na.rm = TRUE),
      desviacion_mediana = desviacion_mediana(total_ingresos),
      cv_ingresos = (desviacion_ingresos/ingreso_promedio)*100,
      q1_ingresos = quantile(total_ingresos, 0.25, na.rm = TRUE),
      q3_ingresos = quantile(total_ingresos, 0.75, na.rm = TRUE),
      .groups = 'drop'
    ) %>%
    mutate(across(where(is.numeric), ~ round(., 2)))
  
  # Crear tabla formateada con nombres interpretativos
  tabla_formateada <- resultado %>%
    kable(
      caption = titulo,
      col.names = c("Grupo", 
                    "N° Transacciones",
                    "Ingreso Total ($)",
                    "Ingreso Mínimo por Transacción ($)",
                    "Ingreso Máximo por Transacción ($)", 
                    "Rango de Ingresos ($)",
                    "Ingreso Promedio por Transacción ($)",
                    "Ingreso Mediano por Transacción ($)",
                    "Desviación Estándar de Ingresos ($)",
                    "Desviación Mediana de Ingresos ($)",
                    "Coeficiente de Variación",
                    "Primer Cuartil Q1 ($)",
                    "Tercer Cuartil Q3 ($)"),
      align = c("l", rep("c", ncol(resultado) - 1)),
      digits = 2
    ) %>%
    kable_styling(
      bootstrap_options = c("striped", "hover", "condensed"),
      full_width = TRUE,  # Ahora sí puede ser full width por los nombres largos
      font_size = 11,
      position = "center"
    ) %>%
    row_spec(0, bold = TRUE, background = "#f8f9fa") %>%
    column_spec(1, bold = TRUE, width = "3cm") %>%
    column_spec(2, width = "2cm") %>%
    column_spec(3:8, width = "2.5cm") %>%
    column_spec(9:12, width = "2.2cm") %>%
    column_spec(10, background = "#f0f8ff") %>%  # Destacar CV
    scroll_box(width = "100%", height = "500px")  # Scroll para tablas muy anchas
  
  # Agregar subtítulo si se proporciona
  if (!is.null(subtitulo)) {
    tabla_formateada <- tabla_formateada %>%
      add_header_above(c(" " = 1, "Estadísticas Descriptivas de Ingresos por Transacción" = ncol(resultado) - 1))
  }
  
  # Agregar nota si se proporciona
  if (!is.null(nota)) {
    tabla_formateada <- tabla_formateada %>%
      footnote(
        general = paste(nota, "| Todas las métricas en dólares ($) excepto CV (adimensional)"),
        general_title = "Nota:",
        footnote_as_chunk = TRUE
      )
  }
  
  return(list(
    datos = resultado,
    tabla = tabla_formateada
  ))
}

#ANÁLISIS GENERAL DE LA SUCURSAL: POR TIENDA, POR TIPO DE PRODUCTO, POR MES Y POR TURNO. 

niveles_meses_abreviados <- c("MES ENE", "MES FEB", "MES MAR", "MES ABR", "MES MAY", "MES JUN")

vicsha_ordenado <- vicsha_basededatos %>%
  mutate(mes_abreviado = factor(mes_abreviado, levels = niveles_meses_abreviados, ordered = TRUE))

niveles_horarios_abreviados <- c("HORARIO DE LA MAÑANA", "HORARIO DE LA TARDE/NOCHE", "HORARIO DE LA NOCHE")
vicsha_ordenadoporturno <- vicsha_basededatos %>%
  mutate(mes_abreviado = factor(turno, levels = niveles_horarios_abreviados, ordered = TRUE))

#Luego de ordenar nuestros factores de interés para obtener una mejor presentación lógica en términos de tiempo, utilizamos nuestra función. 


vicsha_pormes <- analizar_y_formatear(
  df = vicsha_ordenado,
  grupo = mes_abreviado,
  titulo = "Análisis comparativo de los ingresos por cada mes",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(vicsha_pormes)


vicsha_porturno<- analizar_y_formatear(
  df = vicsha_ordenadoporturno,
  grupo = turno,
  titulo = "Análisis comparativo de los ingresos por cada mes",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(vicsha_porturno)


vicsha_portienda <- analizar_y_formatear(
  df = vicsha_basededatos,
  grupo = ubicacion_tienda,
  titulo = "Análisis comparativo de los ingresos por cada tienda",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(vicsha_portienda)


vicsha_porproducto <- analizar_y_formatear(
  df = vicsha_basededatos,
  grupo = categoria_producto,
  titulo = "Análisis comparativo de los ingresos por cada categoría del menú",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(vicsha_porproducto)

#TIENDA NRO 1. ASTORIA

df_agrupado_por_Astoria_orderm <- vicsha_ordenado%>% #orderm= ordenado por mes 
  filter( ubicacion_tienda == 'Astoria')

df_agrupado_por_Astoria_ordert <- vicsha_ordenadoporturno%>%   #orderm= ordenado por turno
  filter( ubicacion_tienda == 'Astoria')

Astoria_pormes <- analizar_y_formatear(
  df = df_agrupado_por_Astoria_orderm,
  grupo = mes_abreviado,
  titulo = "Análisis comparativo de los ingresos por cada mes en la Sucursal Astoria",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(Astoria_pormes)

Astoria_porturno <- analizar_y_formatear(
  df = df_agrupado_por_Astoria_ordert,
  grupo = turno,
  titulo = "Análisis comparativo de los ingresos por turno en la Sucursal Astoria",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(Astoria_porturno)

Astoria_portipodeproducto<- analizar_y_formatear(
  df = df_agrupado_por_Astoria_ordert, #Acá es indiferente si utilizamos el ordert o orderm porque el orden no altera el resultado. 
  grupo = categoria_producto,
  titulo = "Análisis comparativo de los ingresos por cada categoría del menú en la Sucursal Astoria",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(Astoria_portipodeproducto)

#TIENDA NRO 2. Hell's Kitchen

df_agrupado_por_Hell_orderm <- vicsha_ordenado%>% #orderm= ordenado por mes 
  filter( ubicacion_tienda == "Hell's Kitchen")

df_agrupado_por_Hell_ordert <- vicsha_ordenadoporturno%>%   #orderm= ordenado por turno
  filter( ubicacion_tienda == "Hell's Kitchen")

Hell_pormes <- analizar_y_formatear(
  df = df_agrupado_por_Hell_orderm,
  grupo = mes_abreviado,
  titulo = "Análisis comparativo de los ingresos por cada mes en la Sucursal Hell's Kitchen",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(Hell_pormes)

Hell_porturno <- analizar_y_formatear(
  df = df_agrupado_por_Hell_ordert,
  grupo = turno,
  titulo = "Análisis comparativo de los ingresos por turno en la Sucursal Hell's Kitchen",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(Hell_porturno)

Hell_portipodeproducto<- analizar_y_formatear(
  df = df_agrupado_por_Hell_ordert, #Acá es indiferente si utilizamos el ordert o orderm porque el orden no altera el resultado. 
  grupo = categoria_producto,
  titulo = "Análisis comparativo de los ingresos por cada categoría del menú en la Sucursal Hell's Kitchen",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(Hell_portipodeproducto)

#TIENDA NRO 3. Lower Manhattan

df_agrupado_por_Lower_orderm <- vicsha_ordenado%>% #orderm= ordenado por mes 
  filter( ubicacion_tienda == "Lower Manhattan")

df_agrupado_por_Lower_ordert <- vicsha_ordenadoporturno%>%   #orderm= ordenado por turno
  filter( ubicacion_tienda == "Lower Manhattan")

Lower_pormes <- analizar_y_formatear(
  df = df_agrupado_por_Lower_orderm,
  grupo = mes_abreviado,
  titulo = "Análisis comparativo de los ingresos por cada mes en la Sucursal Lower Manhattan",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(Lower_pormes)

Lower_porturno <- analizar_y_formatear(
  df = df_agrupado_por_Lower_ordert,
  grupo = turno,
  titulo = "Análisis comparativo de los ingresos por turno en la Sucursal Lower Manhattan",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(Lower_porturno)

Lower_portipodeproducto<- analizar_y_formatear(
  df = df_agrupado_por_Lower_ordert, #Acá es indiferente si utilizamos el ordert o orderm porque el orden no altera el resultado. 
  grupo = categoria_producto,
  titulo = "Análisis comparativo de los ingresos por cada categoría del menú en la Sucursal Lower Manhattan",
  nota = "La información proporcionada comprende la cantidad total de datos de un semestre"
)

print(Lower_portipodeproducto)
