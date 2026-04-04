const express = require('express');
const path    = require('path');
const { parseXML, validateXSD, validateDTD } = require('./utils');

const app = express();
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  if (req.method === 'OPTIONS') return res.sendStatus(204);
  next();
});
app.use(express.json({ limit: '1mb' }));
app.use(express.static(path.join(__dirname, '..')));

app.post('/validar', (req, res) => {
  const { xml, modo } = req.body;
  if (!xml) return res.status(400).json({ error: 'Falta el campo xml' });

  const { doc, errors: parseErrors } = parseXML(xml);
  if (!doc || parseErrors.length) return res.json({ valido: false, errores: parseErrors });

  const errors = modo === 'dtd' ? validateDTD(doc) : validateXSD(doc);
  res.json({ valido: errors.length === 0, errores: errors });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor escuchando en el puerto:${PORT}`);
});
