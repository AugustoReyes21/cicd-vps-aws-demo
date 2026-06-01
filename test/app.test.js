const test = require("node:test");
const assert = require("node:assert/strict");
const request = require("supertest");
const { createApp } = require("../src/app");

test("GET /health responde con estado ok", async () => {
  const response = await request(createApp()).get("/health").expect(200);

  assert.equal(response.body.status, "ok");
  assert.equal(response.body.service, "cicd-vps-aws-demo");
});

test("GET / muestra la pagina principal", async () => {
  const response = await request(createApp()).get("/").expect(200);

  assert.match(response.text, /Despliegue CI\/CD funcionando/);
});
