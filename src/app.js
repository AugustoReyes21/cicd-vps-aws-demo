const express = require("express");

function createApp() {
  const app = express();

  app.get("/", (_req, res) => {
    res.type("html").send(`<!doctype html>
<html lang="es">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>CI/CD en VPS AWS</title>
    <style>
      :root {
        color-scheme: light;
        font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        background: #f6f7fb;
        color: #18212f;
      }

      body {
        margin: 0;
        min-height: 100vh;
        display: grid;
        place-items: center;
      }

      main {
        width: min(900px, calc(100vw - 32px));
        padding: 40px;
        border: 1px solid #d9dee8;
        border-radius: 8px;
        background: #ffffff;
        box-shadow: 0 16px 50px rgb(30 41 59 / 12%);
      }

      h1 {
        margin: 0 0 12px;
        font-size: clamp(2rem, 5vw, 4rem);
        line-height: 1;
        letter-spacing: 0;
      }

      p {
        margin: 0;
        max-width: 62ch;
        color: #465568;
        font-size: 1.08rem;
        line-height: 1.6;
      }

      dl {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 14px;
        margin: 28px 0 0;
      }

      div {
        border-left: 4px solid #0f766e;
        padding: 4px 0 4px 14px;
      }

      dt {
        color: #64748b;
        font-size: 0.78rem;
        font-weight: 700;
        text-transform: uppercase;
      }

      dd {
        margin: 4px 0 0;
        font-size: 1rem;
        font-weight: 700;
      }
    </style>
  </head>
  <body>
    <main>
      <h1>Despliegue CI/CD funcionando</h1>
      <p>
        Esta aplicacion fue validada, construida y desplegada automaticamente
        hacia una VPS en AWS usando GitHub Actions, SSH y Docker Compose.
      </p>
      <dl>
        <div>
          <dt>Entorno</dt>
          <dd>VPS AWS EC2</dd>
        </div>
        <div>
          <dt>Pipeline</dt>
          <dd>Validacion, build y deploy</dd>
        </div>
        <div>
          <dt>Estado</dt>
          <dd>Servicio activo</dd>
        </div>
      </dl>
    </main>
  </body>
</html>`);
  });

  app.get("/health", (_req, res) => {
    res.json({
      status: "ok",
      service: "cicd-vps-aws-demo",
      timestamp: new Date().toISOString()
    });
  });

  return app;
}

module.exports = { createApp };
