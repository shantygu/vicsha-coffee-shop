library(readxl)
library(dplyr)
library (tidyverse)
library(knitr)
library(kableExtra)

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

