# MELI Mobile Candidate

## Arquitectura
El proyecto se ha implementado siguiendo la arquitectura de Modelo-Vista-ViewModel (MVVM). Esta estructura proporciona una separación clara de responsabilidades, facilitando la organización y mantenimiento del código.

## UI
El 90% de la interfaz de usuario (UI) se ha desarrollado utilizando SwiftUI, aprovechando sus capacidades modernas y declarativas para la construcción de interfaces. Algunas pantallas hacen uso de capas de UIKit, pero siempre se integran en una vista de SwiftUI al ser mostradas.

## Observaciones Técnicas Generales
- **Programación Reactiva con Combine:** Se ha utilizado el framework Combine para implementar programación reactiva, permitiendo una gestión eficiente de eventos y cambios en el estado de la aplicación.

- **Test Unitarios:** Se han implementado y ejecutado con éxito pruebas unitarias para garantizar la calidad del código y su comportamiento esperado.

- **Inyección de Dependencias:** Se ha aplicado el principio de inyección de dependencias para facilitar la gestión de componentes y mejorar la testabilidad del código.

- **Selección de País en Pantalla de Inicio:** Se ha añadido una pantalla inicial que permite al usuario elegir el país (SITE_ID) para realizar la búsqueda de ítems, brindando una experiencia personalizada.

- **Carga de Información de Ítems:** En el momento de la notificación sobre la subida del proyecto, la carga de información de los ítems se realiza utilizando los datos proporcionados por la búsqueda, en lugar de cargarlos de forma individual, lo que evita que se tenga carrete de fotos. Consideré implementar la carga individual en una actualizacion post aviso de subida.
