library(reshape2)
library(ggplot2)

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
  
  