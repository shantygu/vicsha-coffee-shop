moda <- function(x) {
  # Eliminar NA para evitar problemas
  x <- na.omit(x)
  # Calcular la frecuencia de cada valor
  freq <- table(x)
  # Obtener el valor(es) con la frecuencia máxima
  modas <- names(freq)[freq == max(freq)]
  # Convertir a tipo numérico si es posible
  if (all(!is.na(as.numeric(modas)))) {
    modas <- as.numeric(modas)
  }
  
  return(modas)
}

desviacion_mediana <- function(x) {
  x <- na.omit(x)
  med <- median(x)
  # Calcular la raíz cuadrada del promedio de los cuadrados de las diferencias con la mediana
  sqrt(mean((x - med)^2))
}

vicsha_portienda <- vicsha_basededatos %>%
  group_by(ubicacion_tienda)%>%
  summarise(
    transacciones.realizadas = n(),
    ingresos.totales = sum(total_ingresos, na.rm = TRUE),
    minimo = min(total_ingresos, na.rm = TRUE),
    maximo = max(total_ingresos, na.rm =  TRUE),
    rango = (maximo - minimo ), 
    media = mean(total_ingresos, na.rm = TRUE),
    mediana = median(total_ingresos, na.rm = TRUE),
    desviacion = sd(total_ingresos, na.rm = TRUE),
    desviacion_mediana = desviacion_mediana(total_ingresos), 
    moda = moda(total_ingresos),
    q1 = quantile(total_ingresos, 0.25, na.rm = TRUE),
    q3 = quantile(total_ingresos, 0.75, na.rm = TRUE), 
  )

  print(vicsha_portienda)

vicsha_portipodeproducto <- vicsha_basededatos %>%
  group_by(categoria_producto)%>%
  summarise(
    conteo = n(),
    ingresos.totales = sum(total_ingresos, na.rm = TRUE),
    minimo = min(total_ingresos, na.rm = TRUE),
    maximo = max(total_ingresos, na.rm =  TRUE),
    rango = (maximo - minimo), 
    media = mean(total_ingresos, na.rm = TRUE),
    mediana = median(total_ingresos, na.rm = TRUE),
    desviacion = sd(total_ingresos, na.rm = TRUE),
    desviacion_mediana = desviacion_mediana(total_ingresos), 
    moda = moda(total_ingresos),
    q1 = quantile(total_ingresos, 0.25, na.rm = TRUE),
    q3 = quantile(total_ingresos, 0.75, na.rm = TRUE), 
  )

  print(vicsha_portipodeproducto)

# Definimos los niveles por los que queremos ordenar nuestra variable condicionada.
niveles_meses_abreviados <- c("MES ENE", "MES FEB", "MES MAR", "MES ABR", "MES MAY", "MES JUN")

vicsha_pormes <- vicsha_basededatos %>%
  mutate(mes_abreviado = factor(mes_abreviado, levels = niveles_meses_abreviados, ordered = TRUE)) %>%
  group_by(mes_abreviado) %>%
  summarise(
    conteo = n(),
    ingresos.totales = sum(total_ingresos, na.rm = TRUE),
    minimo = min(total_ingresos, na.rm = TRUE),
    maximo = max(total_ingresos, na.rm = TRUE),
    rango = (maximo - minimo),  
    media = mean(total_ingresos, na.rm = TRUE),
    mediana = median(total_ingresos, na.rm = TRUE),
    desviacion = sd(total_ingresos, na.rm = TRUE),
    desviacion_mediana = desviacion_mediana(total_ingresos), 
    cv = sd(total_ingresos, na.rm = TRUE) / mean(total_ingresos, na.rm = TRUE), 
    moda = moda(total_ingresos),  
    q1 = quantile(total_ingresos, 0.25, na.rm = TRUE),
    q3 = quantile(total_ingresos, 0.75, na.rm = TRUE)
  ) %>%
  arrange(mes_abreviado)

  print(vicsha_pormes)
  # ordena por mes en orden cronológico
  
  # Definimos los niveles por los que queremos ordenar nuestra variable condicionada.
  niveles_horarios_abreviados <- c("HORARIO DE LA MAÑANA", "HORARIO DE LA TARDE/NOCHE", "HORARIO DE LA NOCHE")
  
  vicsha_porturno <- vicsha_basededatos %>%
    mutate(turno = factor(turno, levels = niveles_horarios_abreviados, ordered = TRUE)) %>%
    group_by(turno) %>%
    summarise(
      conteo = n(),
      ingresos.totales = sum(total_ingresos, na.rm = TRUE),
      minimo = min(total_ingresos, na.rm = TRUE),
      maximo = max(total_ingresos, na.rm = TRUE),
      rango = (maximo - minimo),  
      media = mean(total_ingresos, na.rm = TRUE),
      mediana = median(total_ingresos, na.rm = TRUE),
      desviacion = sd(total_ingresos, na.rm = TRUE),
      desviacion_mediana = desviacion_mediana(total_ingresos), 
      cv = sd(total_ingresos, na.rm = TRUE) / mean(total_ingresos, na.rm = TRUE), 
      moda = moda(total_ingresos),  
      q1 = quantile(total_ingresos, 0.25, na.rm = TRUE),
      q3 = quantile(total_ingresos, 0.75, na.rm = TRUE)
    ) %>%
    arrange(turno)
  
  print(vicsha_porturno)
    
