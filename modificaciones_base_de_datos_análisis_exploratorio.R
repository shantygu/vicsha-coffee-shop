library(readxl)
library(dplyr)
library (tidyverse)
library(knitr)
library(kableExtra)
library(lubridate)
library(dplyr)


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

#Modificamos el formato de hora para simplificar el manejo de los datos más adelante. 
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

#Verificamos los cambios. 
view(vicsha_basededatos)