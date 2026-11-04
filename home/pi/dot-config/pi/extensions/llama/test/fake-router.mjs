#!/usr/bin/env node
import http from 'node:http';
import { writeFileSync, appendFileSync } from 'node:fs';
import { join } from 'node:path';
const args = process.argv.slice(2);
const value = flag => args[args.indexOf(flag) + 1];
const root = value('--models-dir');
if (root) {
  writeFileSync(join(root, 'router.pid'), String(process.pid));
  appendFileSync(join(root, 'starts'), 'start\n');
  writeFileSync(join(root, 'args.json'), JSON.stringify(args));
}
const model = { id: 'gemma-test', source: 'models_dir', status: { value: 'unloaded', args: ['--ctx-size', '8192'] },
  architecture: { input_modalities: ['text', 'image'], output_modalities: ['text'] }, context_length: 262144 };
const server = http.createServer(async (req, res) => {
  res.setHeader('content-type', 'application/json');
  if (process.env.FAKE_LLAMA_AUTH && req.headers.authorization !== `Bearer ${process.env.FAKE_LLAMA_AUTH}`) {
    res.writeHead(401); res.end('{}'); return;
  }
  if (req.url === '/models') { res.end(JSON.stringify({ data: [model] })); return; }
  if (req.url.startsWith('/props')) {
    res.end(JSON.stringify({ models_autoload: !args.includes('--no-models-autoload'), chat_template: 'enable_thinking' })); return;
  }
  if (req.url === '/models/load') {
    model.status.value = 'loaded'; res.end('{}'); return;
  }
  res.writeHead(404); res.end('{}');
});
server.listen(Number(value('--port')), '127.0.0.1');
process.on('SIGTERM', () => server.close(() => process.exit(0)));
