const { DOMParser } = require('@xmldom/xmldom');

function getChild(el, tag) { return el?.getElementsByTagName(tag)[0] ?? null; }
function getText(el, tag)  { return getChild(el, tag)?.textContent.trim() ?? null; }

function parseXML(txt) {
  const errors = [];
  const start = txt.indexOf('<');
  const cleaned = (start > 0 ? txt.slice(start) : txt)
    .replace(/\s+xmlns:xsi="[^"]*"/g, '')
    .replace(/\s+xsi:[a-zA-Z]+=["'][^"']*["']/g, '');
  try {
    const doc = new DOMParser({ onError: (_, m) => errors.push(String(m)) })
      .parseFromString(cleaned, 'text/xml');
    return { doc, errors };
  } catch (err) {
    return { doc: null, errors: [err.message] };
  }
}

function validateXSD(doc) {
  const errors = [];
  const root   = doc.documentElement;

  const VALID_STATUSES = ['Activo', 'Graduado', 'Suspendido', 'Baja'];
  const DNI_REGEX      = /^[0-9]{8}[A-Z]$/;
  const EMAIL_REGEX    = /^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;

  const seenDnis = new Set();
  for (const student of root.getElementsByTagName('alumno')) {
    const id     = student.getAttribute('id') ?? '?';
    const dni    = getText(student, 'dni');
    const status = getText(student, 'estado');
    const email  = getText(student, 'email');
    const tasa   = getText(student, 'tasaMatricula');

    for (const field of ['nombre', 'apellidos', 'dni', 'email'])
      if (!getChild(student, field)) errors.push(`Falta <${field}> en alumno id="${id}"`);

    if (dni && !DNI_REGEX.test(dni))           errors.push(`DNI inválido: '${dni}' (alumno id="${id}")`);
    if (dni && seenDnis.has(dni))              errors.push(`DNI duplicado: '${dni}'`);
    if (dni) seenDnis.add(dni);
    if (status && !VALID_STATUSES.includes(status)) errors.push(`Estado inválido: '${status}' (alumno id="${id}")`);
    if (tasa !== null && parseFloat(tasa) < 0)       errors.push(`tasaMatricula negativa (alumno id="${id}")`);
    if (email  && !EMAIL_REGEX.test(email))          errors.push(`Email inválido: '${email}' (alumno id="${id}")`);
  }

  return errors;
}

function validateDTD(doc) {
  const errors = [];
  const root   = doc.documentElement;

  if (root.tagName !== 'escuela')      errors.push(`Elemento raíz incorrecto: <${root.tagName}>`);
  if (!root.getAttribute('modalidad')) errors.push('Falta atributo @modalidad');
  for (const tag of ['informacion', 'cursos', 'alumnos'])
    if (!root.getElementsByTagName(tag)[0]) errors.push(`Falta elemento <${tag}>`);

  const ids = new Set();
  for (const el of root.getElementsByTagName('*')) {
    const id = el.getAttribute('id');
    if (id) { if (ids.has(id)) errors.push(`ID duplicado: "${id}"`); ids.add(id); }
  }
  for (const el of root.getElementsByTagName('*'))
    for (const attr of ['idCurso', 'idResponsable', 'idAlumno']) {
      const ref = el.getAttribute(attr);
      if (ref && !ids.has(ref)) errors.push(`${attr}="${ref}" referencia ID inexistente`);
    }

  return errors;
}

module.exports = { parseXML, validateXSD, validateDTD };
