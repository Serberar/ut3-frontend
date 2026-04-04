const API_VALIDAR = 'https://ut3-backend.onrender.com/validar';

function mostrar(html) {
  const div = document.getElementById('resultado');
  div.style.display = 'block';
  div.innerHTML = html;
}

async function verificar() {
  const xml  = document.getElementById('xml').value.trim();
  const modo = document.getElementById('modo').value;

  if (!xml) { alert('Pega el código XML primero.'); return; }

  mostrar('<div style="color:#888;font-size:.85em">Validando...</div>');

  try {
    const { valido, errores, error } = await fetch(API_VALIDAR, {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify({ xml, modo })
    }).then(r => r.json());

    if (error)   return mostrar(`<div class="resultado-fail"><div class="resultado-etiqueta">Error: ${error}</div></div>`);
    if (valido)  return mostrar(`<div class="resultado-ok"><div class="resultado-etiqueta">✓ Documento válido</div></div>`);

    const items = errores.map(e => `<div class="resultado-err">${e}</div>`).join('');
    mostrar(`<div class="resultado-fail">
      <div class="resultado-etiqueta">✗ ${errores.length} error${errores.length > 1 ? 'es' : ''} encontrado${errores.length > 1 ? 's' : ''}</div>
      <div class="resultado-errores">${items}</div>
    </div>`);

  } catch {
    mostrar(`<div class="resultado-fail">
      <div class="resultado-etiqueta">No se puede conectar con el servidor</div>
      <div class="resultado-errores"><div class="resultado-err">Ponte en contacto con el administrador del sistema</div></div>
    </div>`);
  }
}

function limpiar() {
  document.getElementById('xml').value = '';
  document.getElementById('resultado').style.display = 'none';
}
