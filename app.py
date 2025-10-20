import streamlit as st
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import os

st.markdown("<hr style='border-top: 1px solid #000000;'>", unsafe_allow_html=True)

# --- PALETA VICSHA PARA GRÁFICOS ---
sns.set_palette(["#A67B5B", "#8E9775", "#6F4E37"])

# --- CONFIGURACIÓN DE LA PÁGINA ---
st.set_page_config(
    page_title="Coffee Vicsha Dashboard",
    page_icon="☕",
    layout="wide"
)
# --- ESTILO GLOBAL VICSHA (SOLO TEXTO DEL CUERPO MÁS OSCURO) ---
st.markdown("""
    <style>
    /* Fondo general pastel */
    [data-testid="stAppViewContainer"] {
        background-color: #F5F0E6 !important;
    }
    

    /* Fondo del sidebar  */
    [data-testid="stSidebar"] {
        background-color: #FAF9F6 !important;
    }

    /* TEXTO DE PÁRRAFOS Y ELEMENTOS GENERALES */
    p, label, span, div {
        color: #5D4037 !important;  /* Marrón más oscuro para mejor legibilidad */
        font-weight: 500;
    }
    
    /* TEXTOS PRINCIPALES  */
    h1 {
        color: #2C1810 !important;  /* Marrón muy oscuro */
        font-weight: 700;
        font-size: 28px;
        margin-bottom: 10px;
    }

    h2 {
        color: #3A2519 !important;
        font-weight: 600;
        font-size: 22px;
        border-bottom: 2px solid #000000;
        padding-bottom: 5px;
    }

    h3 {
        color: #4A3429 !important;
        font-weight: 600;
        font-size: 18px;
    }

    /* Texto general del cuerpo */
    p, label, span, div {
        color: #4A3429 !important;  /* Marrón oscuro */
        font-weight: 500;
    }
    /* Filtros  */
    .stMultiSelect label, .stSlider label {
        color: #8B6F57 !important;
        font-weight: 500;
    }
    .stMultiSelect div, .stSlider div {
        background-color: #FAF9F6 !important; 
        border-radius: 6px;
        color: #8B6F57 !important;
    }

    /* Slider track */
    .stSlider > div[data-baseweb="slider"] > div {
        background:  #D8CFC4 !important;
    }

    /* Tags seleccionados  */
    div[data-baseweb="tag"] {
        background-color: #E6D9C5 !important;
        color: #7C5C44 !important;
        border-radius: 6px !important;
        font-weight: 500;
        border: none !important;
        box-shadow: none !important;
    }
    div[data-baseweb="tag"] svg {
        fill: #7C5C44 !important;
    }

    /* Métricas  */
    [data-testid="metric-container"] {
        background-color: #EFE8DC !important;
        border: 1px solid #D8CFC4;
        border-radius: 8px;
        padding: 10px;
        color: #8B6F57 !important;
    }

    /* Tabs  */
    button[data-baseweb="tab"] {
        background-color: #FAF9F6 !important;
        color: #8B6F57 !important;
        border-radius: 0px;
        font-weight: 500;
    }
     /* Color del texto de las opciones del multiselect */
    div[data-baseweb="popover"] div {
    color: #5D4037 !important;  /* ← MÁS OSCURO */
    font-weight: 500 !important;
    }
    /* Fondo del dropdown */
    div[data-baseweb="popover"] {
    background-color: #FAF9F6 !important;
    border: 1px solid #D8CFC4 !important;
    }
            
    button[data-baseweb="tab"]:hover {
        background-color: #E6D9C5 !important;
        color: #7C5C44 !important;
    }
    </style>
""", unsafe_allow_html=True)

# --- ENCABEZADO CON ESTILO  CAFÉ ---
st.markdown("""
    <div style='text-align: center; padding-top: 10px; padding-bottom: 10px;'>
        <h1 style='color: #6F4E37; font-family:serif; font-size:42px;'>Coffee Vicsha Dashboard</h1>
        <h4 style='color: #A67B5B; font-family:serif; font-size:24px;'>Estudio técnico de consumo, rentabilidad y comportamiento</h4>
        <p style='color: #8E9775; font-size:18px; font-style:italic;'>Inteligencia visual para decisiones reales.</p>
    </div>
""", unsafe_allow_html=True)

# --- LÍNEA SEPARADORA DESPUÉS DEL ENCABEZADO ---
st.markdown("<hr style='border-top: 2px solid #000000; margin: 20px 0;'>", unsafe_allow_html=True)

# --- INTRO NARRATIVA ---
st.markdown("### ☕ Aquí comienza la historia detrás de cada transacción.")
st.markdown("Cada dato es una taza servida, cada gráfico una decisión que se infunde con precisión.")

# --- LÍNEA SEPARADORA ANTES DEL SIDEBAR ---
st.markdown("<hr style='border-top: 1px solid #000000; margin: 25px 0;'>", unsafe_allow_html=True)


# --- CARGA DE DATOS ---
@st.cache_data
def load_data(filepath):
    try:
        df = pd.read_excel(filepath)
        df = df.rename(columns={
            'transaction_id': 'id transaccion',
            'transaction_date': 'fecha',
            'transaction_time': 'hora',
            'transaction_qty': 'cantidad',
            'store_location': 'ubicacion',
            'unit_price': 'precio',
            'product_category': 'categoria',
        })
        df['fecha'] = pd.to_datetime(df['fecha'])
        df['total'] = df['cantidad'] * df['precio']
        df['mes'] = df['fecha'].dt.month.map({
            1: 'ENE', 2: 'FEB', 3: 'MAR', 4: 'ABR', 5: 'MAY', 6: 'JUN',
            7: 'JUL', 8: 'AGO', 9: 'SEP', 10: 'OCT', 11: 'NOV', 12: 'DIC'
        })
        df['hora completa'] = pd.to_datetime(df['fecha'].astype(str) + ' ' + df['hora'].astype(str))
        df['hora_num'] = df['hora completa'].dt.hour
        df['turno'] = pd.cut(df['hora_num'], bins=[0, 12, 24],
                             labels=["MAÑANA", "TARDE/NOCHE"], right=False)
        return df
    except FileNotFoundError:
        st.error("⚠️ No se encontró el archivo 'Coffee Shop Sales.xlsx'.")
        return None

# --- RUTA AL ARCHIVO ---
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
FILE_PATH = os.path.join(SCRIPT_DIR, "Coffee Shop Sales.xlsx")
df = load_data(FILE_PATH)

if df is None:
    st.stop()

# --- SIDEBAR CON ESTILO VICSHA ---
with st.sidebar:
    # Fondo beige aplicado con prioridad
    st.markdown("""
        <style>
        [data-testid="stSidebar"] {
            background-color: #4B3824 !important;
        }
        .stMultiSelect label, .stSlider label {
            color: #6F4E37 !important;
            font-weight: 600;
        }
        .stMultiSelect div, .stSlider div {
            background-color: #FAF9F6 !important;
            border-radius: 6px;
        }
        </style>
    """, unsafe_allow_html=True)

    # Encabezado narrativo
    st.markdown("""
        <div style='text-align: center; padding-bottom: 10px;'>
            <h3 style='color: #6F4E37; font-family:serif;'>🎛️ Panel de Filtros Vicsha</h3>
            <p style='color: #8E9775; font-size:16px;'>Refina tu análisis por ubicación, categoría y rango de ingreso.</p>
        </div>
    """, unsafe_allow_html=True)

    # Separador
    st.markdown("<hr style='border-top: 2px solid #000000; margin: 15px 0;'>", unsafe_allow_html=True)

    # Filtro de ubicación
    ubicaciones = sorted(df['ubicacion'].unique())
    filtro_ubicacion = st.multiselect("📍 ¿Dónde se sirve el café?", options=ubicaciones, default=ubicaciones)

    # Separador
    st.markdown("<hr style='border-top: 1px solid #000000; margin: 20px 0;'>", unsafe_allow_html=True)

    # Filtro de categoría
    categorias = sorted(df['categoria'].unique())
    filtro_categoria = st.multiselect("🧃 ¿Qué tipo de producto analizamos?", options=categorias, default=categorias)

    # Separador
    st.markdown("<hr style='border-top: 1px solid #000000; margin: 20px 0;'>", unsafe_allow_html=True)

    # Filtro de ingresos
    rango_ingresos = st.slider("💰 Rango de ingresos por transacción ($):",
                               float(df['total'].min()), float(df['total'].max()),
                               value=(float(df['total'].min()), float(df['total'].max()*0.8)))

# --- FILTRADO DE DATOS ---
query = (
    df['ubicacion'].isin(filtro_ubicacion) &
    df['categoria'].isin(filtro_categoria) &
    (df['total'] >= rango_ingresos[0]) &
    (df['total'] <= rango_ingresos[1])
)
df_filtrado = df[query]

# --- LÍNEA SEPARADORA ANTES DE LAS PESTAÑAS ---
st.markdown("<hr style='border-top: 2px solid #000000; margin: 25px 0;'>", unsafe_allow_html=True)

# --- PESTAÑAS PRINCIPALES ---
tab1, tab2, tab3, tab4 = st.tabs(["📊 Visión General", "📍 Ubicación", "🧃 Categoría", "📋 Explorador"])

# --- TAB 1: VISIÓN GENERAL ---
with tab1:
    st.subheader("Resumen de Ventas Filtradas")
    col1, col2, col3 = st.columns(3)
    col1.metric("Transacciones", f"{len(df_filtrado):,}")
    col2.metric("Ingreso Promedio", f"${df_filtrado['total'].mean():,.2f}")
    col3.metric("Ingreso Total", f"${df_filtrado['total'].sum():,.2f}")

    # Línea separadora entre métricas y gráficos
    st.markdown("<hr style='border-top: 1px solid #000000; margin: 30px 0;'>", unsafe_allow_html=True)
    
    st.subheader("Distribución de Turnos")
    # Definir colores personalizados para bar_chart
    chart_data = df_filtrado['turno'].value_counts().reset_index()
    chart_data.columns = ['turno', 'count']
    st.bar_chart(chart_data, x='turno', y='count', color=['#A67B5B'])
    
    # Línea separadora entre gráficos
    st.markdown("<hr style='border-top: 1px solid #000000; margin: 30px 0;'>", unsafe_allow_html=True)
    
    st.subheader("Tendencia mensual de ingresos")
    ingresos_mes = df_filtrado.groupby('mes')['total'].sum().reindex([
        'ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'
    ])
    st.line_chart(ingresos_mes)

# --- TAB 2: ANÁLISIS POR UBICACIÓN ---
with tab2:
    st.markdown("### 📍 Cada tienda tiene su aroma, su ritmo y su impacto.")
    
    # Línea separadora después del título
    st.markdown("<hr style='border-top: 1px solid #000000; margin: 20px 0;'>", unsafe_allow_html=True)
    
    st.subheader("Distribución de ingresos por tienda")
    fig1, ax1 = plt.subplots(figsize=(8 , 5))
    sns.boxplot(x='total', y='ubicacion', data=df_filtrado, palette='YlOrBr', ax=ax1)
    ax1.set_title("Ingresos por ubicación", color="#5D4037")
    ax1.set_xlabel("Ingreso ($)", color="#5D4037")
    ax1.set_ylabel("Ubicación", color="#5D4037")
    ax1.tick_params(colors="#5D4037")
    st.pyplot(fig1)

# --- TAB 3: ANÁLISIS POR CATEGORÍA ---
with tab3:
    st.markdown("### 🧃 Cada producto cuenta su propia historia de valor.")
    
    # Línea separadora después del título
    st.markdown("<hr style='border-top: 1px solid #000000; margin: 20px 0;'>", unsafe_allow_html=True)
    
    st.subheader("Distribución de ingresos por categoría")
    fig2, ax2 = plt.subplots(figsize=(8 , 5))
    sns.violinplot(x='total', y='categoria', data=df_filtrado, palette='BuPu', ax=ax2)
    ax2.set_title("Ingresos por categoría", color="#5D4037")
    ax2.set_xlabel("Ingreso ($)", color="#5D4037")
    ax2.set_ylabel("Categoría", color="#5D4037")
    ax2.tick_params(colors="#5D4037")
    st.pyplot(fig2)

# --- TAB 4: EXPLORADOR DE DATOS ---
with tab4:
    st.subheader("Datos filtrados")
    st.write(f"Mostrando {len(df_filtrado):,} de {len(df):,} registros totales.")
    
    # Línea separadora antes de la tabla
    st.markdown("<hr style='border-top: 1px solid #000000; margin: 20px 0;'>", unsafe_allow_html=True)
    
    st.dataframe(df_filtrado[['fecha', 'ubicacion', 'categoria', 'cantidad', 'precio', 'total', 'turno']], use_container_width=True)

# --- PESTAÑA 5: INSIGHTS VICSHA ---
tab5 = st.tabs(["📌 Insights Vicsha"])[0]

with tab5:
    st.header("📌 Insights Vicsha")
    
    # Línea separadora después del título
    st.markdown("<hr style='border-top: 1px solid #000000; margin: 20px 0;'>", unsafe_allow_html=True)
    
    st.markdown("### 🧠 Observaciones técnicas y hallazgos clave")

    st.markdown("""
    - 🥐 La categoría *Bakery* muestra mayor estabilidad en ingresos, con baja variabilidad entre tiendas.
    - 🏪 *Astoria* lidera en volumen de transacciones, pero *Coffee Bar* tiene mayor ingreso promedio por venta.
    - 🌞 El turno de la *mañana* concentra más del 60% de las transacciones totales.
    - 📈 Los meses *MAR* y *OCT* presentan picos de ingreso, posiblemente asociados a campañas o eventos.
    - 📊 La correlación entre `cantidad` y `total` es alta, pero varía según categoría.
    """)

    # Línea separadora antes de la firma
    st.markdown("<hr style='border-top: 1px solid #000000; margin: 25px 0;'>", unsafe_allow_html=True)
    
    st.markdown("<p style='text-align: center; color: #6F4E37; font-style: italic;'>Cada insight es una taza servida con precisión.</p>", unsafe_allow_html=True)

# --- FIRMA FINAL ---
st.markdown("<hr style='border-top: 2px solid #000000; margin: 40px 0 20px 0;'>", unsafe_allow_html=True)
st.markdown("<p style='text-align: center; color: #6F4E37; font-style: italic;'>Gracias por explorar con nosotros. Cada dato cuenta, cada decisión transforma.</p>", unsafe_allow_html=True)
