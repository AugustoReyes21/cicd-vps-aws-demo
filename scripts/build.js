const fs = require("fs");
const path = require("path");

const outputDir = path.join(__dirname, "..", "dist");
const outputFile = path.join(outputDir, "build-info.json");

fs.mkdirSync(outputDir, { recursive: true });
fs.writeFileSync(
  outputFile,
  JSON.stringify(
    {
      app: "cicd-vps-aws-demo",
      buildTime: new Date().toISOString(),
      node: process.version
    },
    null,
    2
  )
);

console.log(`Build generado en ${outputFile}`);
