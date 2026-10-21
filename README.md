# UT3 · Lenguajes de Marcas – Web de presentación

Web que presenta las cuatro actividades de XML de la Unidad 3 del módulo «Lenguajes de Marcas y Sistemas de Gestión de Información» (1º DAW, curso 2025-26), con una página por actividad y un **validador de XML online**.

## Páginas

| Página | Contenido |
|---|---|
| `index.html` | Portada con las cuatro actividades. |
| `actividad1.html` | Diseño de esquemas XML (XSD). |
| `actividad2.html` | Creación de documentos XML. |
| `actividad3.html` | Transformación XSLT a HTML y a texto. |
| `actividad4.html` | Validación con DTD y XML Schema. |
| `validacion.html` | Pega un XML y valídalo contra el esquema o la DTD. |

## Cómo funciona el validador

`validacion.js` envía el XML a la API de [ut3-backend](https://github.com/Serberar/ut3-backend), desplegada en `https://ut3-backend.onrender.com/validar`, y muestra los errores que devuelve. Para usar un backend local, cambia `API_VALIDAR` en `validacion.js` por `http://localhost:3000/validar`.

> El backend está en el plan gratuito de Render, así que la primera validación puede tardar unos segundos mientras arranca.

## Tecnologías

HTML5, CSS3 y JavaScript sin frameworks; XML, XSD, DTD y XSLT.

## Autor

Sergio Bernabé
