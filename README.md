# Simulación de la Trayectoria de un Dipolo Magnético

## Descripción General
Este proyecto, desarrollado en MATLAB por un equipo, simula la trayectoria de un dipolo magnético que cae a través del campo magnético de un solenoide. El código calcula el campo magnético generado por el solenoide utilizando la ley de Biot-Savart, simula el movimiento del dipolo bajo las fuerzas magnética, gravitacional y de fricción, y genera una animación que muestra la trayectoria superpuesta sobre una imagen del campo magnético. Los resultados principales incluyen un video de la trayectoria y una gráfica que compara el movimiento del dipolo con la caída libre.

## Componentes del Proyecto
El proyecto está compuesto por varias funciones en MATLAB que trabajan en conjunto para realizar la simulación:

1. **espiras.m**: Genera la geometría de las espiras del solenoide y sus elementos diferenciales para los cálculos del campo magnético.
2. **campoS.m**: Calcula el campo magnético del solenoide usando la ley de Biot-Savart y, opcionalmente, lo visualiza.
3. **trayectoria.m**: Simula el movimiento del dipolo magnético utilizando el método de Runge-Kutta 4 (RK4).
4. **animar_con_fondo.m**: Crea una animación de la trayectoria del dipolo sobre una imagen de fondo del campo magnético.
5. **a_total.m**: Calcula la aceleración total que actúa sobre el dipolo.
6. **rk4_step.m**: Implementa un paso del método de integración numérica RK4.
7. **Script Principal**: Establece las condiciones iniciales y coordina la ejecución de la simulación.

## Funcionamiento del Código
El equipo diseñó el proyecto para modelar el movimiento de un dipolo magnético a lo largo del eje z a través del campo magnético de un solenoide. Los pasos clave son:

- **Geometría del Solenoide**: La función `espiras` crea un solenoide con `nl` espiras, cada una con radio `R` y `N` puntos, separadas por una distancia `sz`. Calcula las posiciones y elementos diferenciales (`dl`) de las espiras para los cálculos del campo magnético.
- **Cálculo del Campo Magnético**: La función `campoS` calcula los componentes del campo magnético (`Bx`, `By`, `Bz`) en puntos específicos utilizando la ley de Biot-Savart. Puede generar una visualización 2D del campo en el plano xz o calcular `Bz` a lo largo del eje z para la simulación de la trayectoria.
- **Simulación de la Trayectoria**: La función `trayectoria` utiliza el método RK4 para resolver las ecuaciones de movimiento del dipolo, considerando las fuerzas magnética, gravitacional y de fricción. Compara el movimiento del dipolo con la caída libre.
- **Animación**: La función `animar_con_fondo` genera un video que muestra la posición del dipolo a lo largo del tiempo, superpuesta sobre una imagen del campo magnético.

## Ecuaciones y su Relevancia

### 1. Ley de Biot-Savart (Cálculo del Campo Magnético)
El campo magnético \(\mathbf{B}\) generado por el solenoide se calcula con la ley de Biot-Savart:

$$
d\mathbf{B} = \frac{\mu_0 I}{4\pi} \frac{d\mathbf{l} \times \mathbf{r}}{|\mathbf{r}|^3}
$$

- **Parámetros**:
  - \(\mu_0 = 4\pi \times 10^{-7} \, \text{T·m/A}\): Permeabilidad magnética del vacío.
  - \(I\): Corriente en el solenoide (A).
  - \(d\mathbf{l}\): Elemento diferencial de longitud de las espiras.
  - \(\mathbf{r}\): Vector desde el elemento de corriente hasta el punto donde se calcula el campo.
  - \(|\mathbf{r}|\): Distancia, ajustada por un pequeño grosor del alambre \(rw\) para evitar singularidades.

- **Por qué se usa**: La ley de Biot-Savart es fundamental para calcular el campo magnético de una distribución de corriente. En este proyecto, permite obtener los componentes del campo (\(B_x\), \(B_y\), \(B_z\)), con enfoque en \(B_z\) para el movimiento del dipolo.

### 2. Fuerza Magnética
La fuerza sobre un dipolo magnético con momento \(\mathbf{m}\) en un campo magnético \(\mathbf{B}\) es:

$$
\mathbf{F_m} = -\nabla (\mathbf{m} \cdot \mathbf{B})
$$

Dado que el momento del dipolo está alineado con el eje z (\(\mathbf{m} = m \hat{z}\)) y solo se considera \(B_z\), esto se simplifica a:

$$
F_m = -m \frac{dB_z}{dz}
$$

- **Parámetros**:
  - \(m\): Momento magnético del dipolo (A·m²).
  - \(\frac{dB_z}{dz}\): Gradiente del campo magnético a lo largo del eje z, calculado numéricamente mediante diferencias centradas.

- **Por qué se usa**: La fuerza magnética depende del gradiente del campo, lo que provoca que el dipolo se acelere o desacelere según la variación del campo del solenoide.

### 3. Fuerza Total y Aceleración
La fuerza total sobre el dipolo incluye la fuerza magnética, la gravitacional y la de fricción:

$$
\mathbf{F} = \mathbf{F_m} + \mathbf{F_g} + \mathbf{F_f}
$$

$$
F = -m \frac{dB_z}{dz} - m g - \gamma v
$$

$$
a = \frac{F}{m} = -\frac{m}{m} \frac{dB_z}{dz} - g - \frac{\gamma}{m} v
$$

- **Parámetros**:
  - \(m\): Masa del dipolo (kg).
  - \(g = 9.81 \, \text{m/s}^2\): Aceleración gravitacional.
  - \(\gamma\): Coeficiente de fricción (kg/s).
  - \(v\): Velocidad del dipolo (m/s).

- **Por qué se usa**: Esta ecuación modela la dinámica del dipolo, equilibrando la atracción/repulsión magnética, el peso gravitacional y el amortiguamiento por fricción.

### 4. Ecuaciones de Movimiento (Integración RK4)
El movimiento se resuelve usando el método RK4 para el sistema:

$$
\frac{dz}{dt} = v
$$

$$
\frac{dv}{dt} = a(z, v) = -\frac{m}{m} \frac{dB_z}{dz} - g - \frac{\gamma}{m} v
$$

- **Por qué se usa**: El método RK4 proporciona una integración numérica precisa y estable de las ecuaciones diferenciales, capturando la posición y velocidad del dipolo a lo largo del tiempo.

## Justificación de las Ecuaciones
- **Ley de Biot-Savart**: Esencial para calcular el campo magnético del solenoide, que impulsa el movimiento del dipolo.
- **Fuerza Magnética**: Modela la interacción entre el dipolo y el gradiente del campo, crucial para la física de la simulación.
- **Fuerza Total**: Integra todas las fuerzas para modelar un movimiento realista, incluyendo el efecto de amortiguamiento por fricción.
- **Integración RK4**: Garantiza precisión y estabilidad en la resolución de las ecuaciones diferenciales acopladas.

## Conclusión
El equipo desarrolló con éxito una simulación en MATLAB que modela la trayectoria de un dipolo magnético en el campo de un solenoide, integrando la ley de Biot-Savart, fuerzas magnéticas, gravitacionales y de fricción, y el método RK4 para una solución precisa. El proyecto genera visualizaciones claras y un video animado, demostrando la interacción entre el dipolo y el campo magnético, y ofrece una herramienta valiosa para estudiar fenómenos electromagnéticos y dinámicos.

