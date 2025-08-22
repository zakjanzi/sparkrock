const express = require('express');
const app = express();
app.get('/', (_, res) => res.json({ ok: true, service: 'backend', ts: new Date().toISOString() }));
const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`backend listening on ${port}`));
