<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:esc="http://escuelaprogramacion.es/schema"
  version="1.0">

  <!-- Formato de salida: texto plano -->
  <xsl:output method="text" encoding="UTF-8"/>

  <!-- Variables globales para navegación cruzada -->
  <xsl:variable name="todosAlumnos" select="//esc:alumno"/>
  <xsl:variable name="todosCursos"  select="//esc:curso"/>

  <!-- Template auxiliar: imprime una línea de separación -->
  <xsl:template name="separador">
    <xsl:text>&#10;========================================&#10;</xsl:text>
  </xsl:template>

  <xsl:template name="separador-fino">
    <xsl:text>&#10;----------------------------------------&#10;</xsl:text>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE RAÍZ
       ============================================================ -->
  <xsl:template match="/">
    <xsl:apply-templates select="esc:escuela"/>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE ESCUELA
       ============================================================ -->
  <xsl:template match="esc:escuela">
    <xsl:call-template name="separador"/>
    <xsl:text>  INFORME DE LA ESCUELA&#10;</xsl:text>
    <xsl:call-template name="separador"/>

    <xsl:apply-templates select="esc:informacion"/>
    <xsl:apply-templates select="esc:cursos"/>
    <xsl:apply-templates select="esc:alumnos"/>
    <xsl:apply-templates select="esc:proyectos"/>

    <xsl:text>&#10;Documento generado mediante transformación XSLT 1.0&#10;</xsl:text>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE INFORMACIÓN GENERAL
       ============================================================ -->
  <xsl:template match="esc:informacion">
    <xsl:text>&#10;ESCUELA  : </xsl:text>
    <xsl:value-of select="esc:nombre"/>
    <xsl:text>&#10;CIF      : </xsl:text>
    <xsl:value-of select="esc:cif"/>
    <xsl:text>&#10;MODALIDAD: </xsl:text>
    <xsl:value-of select="../@modalidad"/>
    <xsl:text>&#10;TEL      : </xsl:text>
    <xsl:value-of select="esc:telefono"/>
    <xsl:text>&#10;EMAIL    : </xsl:text>
    <xsl:value-of select="esc:email"/>
    <!-- xsl:if: muestra la web solo si el elemento existe -->
    <xsl:if test="esc:web">
      <xsl:text>&#10;WEB      : </xsl:text>
      <xsl:value-of select="esc:web"/>
    </xsl:if>
    <xsl:text>&#10;DIR      : </xsl:text>
    <xsl:value-of select="esc:direccion/esc:calle"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="esc:direccion/esc:numero"/>
    <xsl:if test="esc:direccion/esc:piso">
      <xsl:text> – </xsl:text>
      <xsl:value-of select="esc:direccion/esc:piso"/>
    </xsl:if>
    <xsl:text> · </xsl:text>
    <xsl:value-of select="esc:direccion/esc:codigoPostal"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="esc:direccion/esc:ciudad"/>
    <xsl:text> (</xsl:text>
    <xsl:value-of select="esc:direccion/esc:provincia"/>
    <xsl:text>)</xsl:text>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE CURSOS
       ============================================================ -->
  <xsl:template match="esc:cursos">
    <xsl:call-template name="separador"/>
    <xsl:text>CURSOS (</xsl:text>
    <xsl:value-of select="count(esc:curso)"/>
    <xsl:text>)&#10;</xsl:text>
    <xsl:call-template name="separador-fino"/>
    <!-- xsl:for-each + xsl:sort: ordenados alfabéticamente por nombre -->
    <xsl:for-each select="esc:curso">
      <xsl:sort select="esc:nombre" order="ascending"/>
      <xsl:text>&#10;[</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>] </xsl:text>
      <xsl:value-of select="esc:nombre"/>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@nivel"/>
      <xsl:text>)&#10;  Responsable : </xsl:text>
      <xsl:variable name="idResp" select="esc:responsable"/>
      <xsl:choose>
        <xsl:when test="$idResp != ''">
          <xsl:value-of select="$todosAlumnos[@id = $idResp]/esc:nombre"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="$todosAlumnos[@id = $idResp]/esc:apellidos"/>
        </xsl:when>
        <xsl:otherwise>No asignado</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#10;  Horas       : </xsl:text>
      <xsl:value-of select="esc:horasLectivas"/>
      <xsl:text> h&#10;  Precio      : </xsl:text>
      <xsl:value-of select="esc:precio"/>
      <xsl:text> EUR</xsl:text>
      <xsl:if test="esc:descripcion">
        <xsl:text>&#10;  Descripcion : </xsl:text>
        <xsl:value-of select="esc:descripcion"/>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE ALUMNOS
       ============================================================ -->
  <xsl:template match="esc:alumnos">
    <xsl:call-template name="separador"/>
    <xsl:text>ALUMNOS (</xsl:text>
    <xsl:value-of select="count(esc:alumno)"/>
    <xsl:text>)&#10;</xsl:text>
    <xsl:call-template name="separador-fino"/>
    <!-- Ordenados por apellidos -->
    <xsl:for-each select="esc:alumno">
      <xsl:sort select="esc:apellidos" order="ascending"/>
      <xsl:text>&#10;[</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>] </xsl:text>
      <xsl:value-of select="esc:nombre"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="esc:apellidos"/>
      <xsl:text>&#10;  DNI         : </xsl:text>
      <xsl:value-of select="esc:dni"/>
      <xsl:text>&#10;  Estado      : </xsl:text>
      <xsl:value-of select="esc:estado"/>
      <xsl:text>&#10;  Tasa        : </xsl:text>
      <xsl:value-of select="esc:tasaMatricula"/>
      <xsl:text> EUR&#10;  Curso       : </xsl:text>
      <xsl:variable name="idCurso" select="@idCurso"/>
      <xsl:value-of select="$todosCursos[@id = $idCurso]/esc:nombre"/>
      <xsl:text>&#10;  Matricula   : </xsl:text>
      <xsl:value-of select="esc:fechaMatricula"/>
      <!-- xsl:if: muestra el teléfono solo si el alumno lo tiene registrado -->
      <xsl:if test="esc:telefono">
        <xsl:text>&#10;  Telefono    : </xsl:text>
        <xsl:value-of select="esc:telefono"/>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

  <!-- ============================================================
       TEMPLATE PROYECTOS
       ============================================================ -->
  <xsl:template match="esc:proyectos">
    <xsl:call-template name="separador"/>
    <xsl:text>PROYECTOS (</xsl:text>
    <xsl:value-of select="count(esc:proyecto)"/>
    <xsl:text>)&#10;</xsl:text>
    <xsl:call-template name="separador-fino"/>
    <!-- Ordenados por fecha de inicio descendente -->
    <xsl:for-each select="esc:proyecto">
      <xsl:sort select="esc:fechaInicio" order="descending"/>
      <xsl:text>&#10;[</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>] </xsl:text>
      <xsl:value-of select="esc:nombre"/>
      <xsl:text> [</xsl:text>
      <xsl:value-of select="esc:estado"/>
      <xsl:text>]&#10;  Inicio      : </xsl:text>
      <xsl:value-of select="esc:fechaInicio"/>
      <xsl:text>&#10;  Entrega     : </xsl:text>
      <!-- xsl:choose: fecha entrega o "Por determinar" si está ausente -->
      <xsl:choose>
        <xsl:when test="esc:fechaEntrega">
          <xsl:value-of select="esc:fechaEntrega"/>
        </xsl:when>
        <xsl:otherwise>Por determinar</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#10;  Presupuesto : </xsl:text>
      <xsl:value-of select="esc:presupuesto"/>
      <xsl:text> EUR&#10;  Responsable : </xsl:text>
      <xsl:variable name="idResp" select="@idResponsable"/>
      <xsl:value-of select="$todosAlumnos[@id = $idResp]/esc:nombre"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="$todosAlumnos[@id = $idResp]/esc:apellidos"/>
      <xsl:text>&#10;  Equipo      :</xsl:text>
      <xsl:for-each select="esc:participantes/esc:participacion">
        <xsl:variable name="idAlumno" select="@idAlumno"/>
        <xsl:text>&#10;    - </xsl:text>
        <xsl:value-of select="$todosAlumnos[@id = $idAlumno]/esc:nombre"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$todosAlumnos[@id = $idAlumno]/esc:apellidos"/>
        <xsl:if test="@rol">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="@rol"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
