<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:esc="http://escuelaprogramacion.es/schema"
  version="1.0">

  <!-- Formato de salida: HTML con codificación UTF-8 -->
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Formato numérico europeo mediante translate(): evita limitaciones de Saxon-JS
       con xsl:decimal-format nombrados. Se formatea con separadores US y luego se invierten. -->

  <!-- Variables globales para navegación cruzada entre entidades -->
  <xsl:variable name="todosAlumnos" select="//esc:alumno"/>
  <xsl:variable name="todosCursos"  select="//esc:curso"/>

  <!-- ============================================================
       TEMPLATE RAÍZ: genera el esqueleto HTML completo
       ============================================================ -->
  <xsl:template match="/">
    <html lang="es">
      <head>
        <meta charset="UTF-8"/>
        <title>
          <xsl:value-of select="esc:escuela/esc:informacion/esc:nombre"/>
        </title>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          h1 { color: #333; }
          h2 { color: #555; margin-top: 25px; }
          h3 { margin-top: 15px; }
          table { border-collapse: collapse; width: 100%; margin-top: 8px; }
          th { background-color: #4472C4; color: white; padding: 8px; text-align: left; }
          td { border: 1px solid #ccc; padding: 6px; vertical-align: top; }
          .info-grid { }
          .info-item { display: inline-block; margin-right: 20px; margin-bottom: 8px; }
          .info-label { font-weight: bold; }
          .badge { padding: 2px 8px; color: white; font-size: 0.85em; margin-left: 6px; }
          .estado-planificado  { background-color: #FBC02D; color: black; }
          .estado-en-desarrollo { background-color: #E65100; }
          .estado-entregado    { background-color: #1565C0; }
          .estado-evaluado     { background-color: #2E7D32; }
          .proyecto-card { border: 1px solid #ccc; padding: 10px; margin-bottom: 12px; }
          ul.equipo { margin-left: 20px; }
          footer { margin-top: 30px; color: #888; font-size: 0.8em; }
        </style>
      </head>
      <body>
        <div class="contenedor">
          <xsl:apply-templates select="esc:escuela"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE ESCUELA
       ============================================================ -->
  <xsl:template match="esc:escuela">
    <h1>
      <xsl:value-of select="esc:informacion/esc:nombre"/>
      <small>
        <xsl:text> — Modalidad: </xsl:text>
        <xsl:value-of select="@modalidad"/>
      </small>
    </h1>

    <xsl:apply-templates select="esc:informacion"/>
    <xsl:apply-templates select="esc:cursos"/>
    <xsl:apply-templates select="esc:alumnos"/>
    <xsl:apply-templates select="esc:proyectos"/>

    <footer>
      Documento generado mediante transformación XSLT 1.0 desde empresa.xml
    </footer>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE INFORMACIÓN GENERAL
       ============================================================ -->
  <xsl:template match="esc:informacion">
    <h2>Información general</h2>
    <div class="info-grid">
      <div class="info-item">
        <div class="info-label">CIF</div>
        <div><xsl:value-of select="esc:cif"/></div>
      </div>
      <div class="info-item">
        <div class="info-label">Teléfono</div>
        <div><xsl:value-of select="esc:telefono"/></div>
      </div>
      <div class="info-item">
        <div class="info-label">Email</div>
        <div><xsl:value-of select="esc:email"/></div>
      </div>
      <!-- xsl:if: muestra la web solo si existe (elemento opcional) -->
      <xsl:if test="esc:web">
        <div class="info-item">
          <div class="info-label">Web</div>
          <div><xsl:value-of select="esc:web"/></div>
        </div>
      </xsl:if>
      <div class="info-item">
        <div class="info-label">Dirección</div>
        <div>
          <xsl:value-of select="esc:direccion/esc:calle"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="esc:direccion/esc:numero"/>
          <!-- xsl:if: muestra el piso solo si existe (elemento opcional) -->
          <xsl:if test="esc:direccion/esc:piso">
            <xsl:text> – </xsl:text>
            <xsl:value-of select="esc:direccion/esc:piso"/>
          </xsl:if>
        </div>
      </div>
      <div class="info-item">
        <div class="info-label">Ciudad</div>
        <div>
          <xsl:value-of select="esc:direccion/esc:codigoPostal"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="esc:direccion/esc:ciudad"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="esc:direccion/esc:provincia"/>
          <xsl:text>)</xsl:text>
        </div>
      </div>
    </div>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE CURSOS
       ============================================================ -->
  <xsl:template match="esc:cursos">
    <h2>
      <xsl:text>Cursos (</xsl:text>
      <xsl:value-of select="count(esc:curso)"/>
      <xsl:text>)</xsl:text>
    </h2>
    <table>
      <tr>
        <th>Nombre</th>
        <th>Nivel</th>
        <th>Horas</th>
        <th>Precio</th>
        <th>Responsable</th>
        <th>Descripción</th>
      </tr>
      <!-- xsl:for-each + xsl:sort: itera los cursos ordenados por nombre -->
      <xsl:for-each select="esc:curso">
        <xsl:sort select="esc:nombre" data-type="text" order="ascending"/>
        <tr>
          <td><xsl:value-of select="esc:nombre"/></td>
          <td><xsl:value-of select="@nivel"/></td>
          <td><xsl:value-of select="esc:horasLectivas"/> h</td>
          <td>
            <xsl:value-of select="translate(format-number(number(esc:precio), '#,##0.00'), '.,', ',.')"/>
            <xsl:text> €</xsl:text>
          </td>
          <td>
            <!-- Navegación cruzada: busca el alumno cuyo @id coincide con responsable -->
            <xsl:variable name="idResp" select="esc:responsable"/>
            <xsl:choose>
              <xsl:when test="$idResp != ''">
                <xsl:value-of select="$todosAlumnos[@id = $idResp]/esc:nombre"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$todosAlumnos[@id = $idResp]/esc:apellidos"/>
              </xsl:when>
              <xsl:otherwise>—</xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="esc:descripcion">
                <xsl:value-of select="esc:descripcion"/>
              </xsl:when>
              <xsl:otherwise>—</xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE ALUMNOS
       ============================================================ -->
  <xsl:template match="esc:alumnos">
    <h2>
      <xsl:text>Alumnos (</xsl:text>
      <xsl:value-of select="count(esc:alumno)"/>
      <xsl:text>)</xsl:text>
    </h2>
    <table>
      <tr>
        <th>Nombre</th>
        <th>DNI</th>
        <th>Estado</th>
        <th>Tasa matrícula</th>
        <th>Curso</th>
        <th>Matrícula</th>
      </tr>
      <!-- Ordenados por apellidos -->
      <xsl:for-each select="esc:alumno">
        <xsl:sort select="esc:apellidos" data-type="text" order="ascending"/>
        <tr>
          <td>
            <xsl:value-of select="esc:nombre"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="esc:apellidos"/>
          </td>
          <td><xsl:value-of select="esc:dni"/></td>
          <td><xsl:value-of select="esc:estado"/></td>
          <td>
            <xsl:value-of select="translate(format-number(number(esc:tasaMatricula), '#,##0.00'), '.,', ',.')"/>
            <xsl:text> €</xsl:text>
          </td>
          <td>
            <!-- Navegación cruzada: resuelve el nombre del curso desde su @id -->
            <xsl:variable name="idCurso" select="@idCurso"/>
            <xsl:value-of select="$todosCursos[@id = $idCurso]/esc:nombre"/>
          </td>
          <td><xsl:value-of select="esc:fechaMatricula"/></td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE PROYECTOS
       ============================================================ -->
  <xsl:template match="esc:proyectos">
    <h2>
      <xsl:text>Proyectos (</xsl:text>
      <xsl:value-of select="count(esc:proyecto)"/>
      <xsl:text>)</xsl:text>
    </h2>
    <!-- Ordenados por fecha de inicio descendente (más recientes primero) -->
    <xsl:for-each select="esc:proyecto">
      <xsl:sort select="esc:fechaInicio" data-type="text" order="descending"/>
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="esc:proyecto">
    <div class="proyecto-card">
      <h3>
        <xsl:value-of select="esc:nombre"/>
        <!-- xsl:attribute: genera la clase CSS del badge dinámicamente según el estado -->
        <span>
          <xsl:attribute name="class">
            <xsl:text>badge estado-</xsl:text>
            <xsl:choose>
              <xsl:when test="esc:estado = 'En desarrollo'">en-desarrollo</xsl:when>
              <xsl:when test="esc:estado = 'Planificado'">planificado</xsl:when>
              <xsl:when test="esc:estado = 'Entregado'">entregado</xsl:when>
              <xsl:otherwise>evaluado</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:value-of select="esc:estado"/>
        </span>
      </h3>

      <xsl:if test="esc:descripcion">
        <p><xsl:value-of select="esc:descripcion"/></p>
      </xsl:if>

      <table>
        <tr>
          <th>Inicio</th>
          <th>Entrega</th>
          <th>Presupuesto</th>
          <th>Responsable</th>
        </tr>
        <tr>
          <td><xsl:value-of select="esc:fechaInicio"/></td>
          <td>
            <xsl:choose>
              <xsl:when test="esc:fechaEntrega">
                <xsl:value-of select="esc:fechaEntrega"/>
              </xsl:when>
              <xsl:otherwise>Por determinar</xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:value-of select="translate(format-number(number(esc:presupuesto), '#,##0.00'), '.,', ',.')"/>
            <xsl:text> €</xsl:text>
          </td>
          <td>
            <xsl:variable name="idResp" select="@idResponsable"/>
            <xsl:value-of select="$todosAlumnos[@id = $idResp]/esc:nombre"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$todosAlumnos[@id = $idResp]/esc:apellidos"/>
          </td>
        </tr>
      </table>

      <p><strong>Equipo asignado:</strong></p>
      <ul class="equipo">
        <xsl:for-each select="esc:participantes/esc:participacion">
          <li>
            <xsl:variable name="idAlumno" select="@idAlumno"/>
            <xsl:value-of select="$todosAlumnos[@id = $idAlumno]/esc:nombre"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$todosAlumnos[@id = $idAlumno]/esc:apellidos"/>
            <xsl:if test="@rol">
              <xsl:text> — </xsl:text>
              <xsl:value-of select="@rol"/>
            </xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

</xsl:stylesheet>
