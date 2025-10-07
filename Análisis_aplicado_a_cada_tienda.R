#TIENDA NRO 1. ASTORIA

df_agrupado_por_Astoria <- vicsha_basededatos%>%
  filter( ubicacion_tienda == 'Astoria')
  
  view(df_agrupado_por_Astoria)

Astoria_portipodeproducto <- df_agrupado_por_Astoria %>%
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

print(Astoria_portipodeproducto)

Astoria_pormes <- df_agrupado_por_Astoria %>%
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

print(Astoria_pormes)

Astoria_porturno <- vicsha_basededatos %>%
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

print(Astoria_porturno)

#TIENDA NRO 2. Lower Manhattan

df_agrupado_por_Lower_Manhattan <- vicsha_basededatos%>%
  filter(ubicacion_tienda == "Lower Manhattan")
  
  view(df_agrupado_por_Lower_Manhattan)

Manhattan_portipodeproducto <- df_agrupado_por_Lower_Manhattan %>%
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

print(Manhattan_portipodeproducto)

Manhattan_pormes <- df_agrupado_por_Lower_Manhattan %>%
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

print(Manhattan_pormes)

Manhattan_porturno <- df_agrupado_por_Lower_Manhattan %>%
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

print(Manhattan_porturno)

#TIENDA NRO 3. Hell's Kitchen

df_agrupado_por_Hells_Kitchen <- vicsha_basededatos%>%
  filter(ubicacion_tienda == "Hell's Kitchen")

view(df_agrupado_por_Hells_Kitchen)

Hells_portipodeproducto <- df_agrupado_por_Hells_Kitchen %>%
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

print(Hells_portipodeproducto)

Hells_pormes <- df_agrupado_por_Hells_Kitchen %>%
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

print(Hells_pormes)

Hells_porturno <- df_agrupado_por_Hells_Kitchen %>%
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

print(Hells_porturno)
