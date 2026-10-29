console.log("Hello Node.js");
// fs Module
//  Write
const fs = require("fs");

fs.writeFileSync(
  "message.txt",
  "Welcome to Node.js"
);

console.log("File created");

// Read

const fs = require("fs");

const data = fs.readFileSync(
  "message.txt",
  "utf-8"
);

console.log(data);

// Async 
const data1 = fs.readFileSync("message.txt");

fs.readFile(
  "message.txt",
  "utf-8",
  (error, data1) => {

    if (error) {
      console.error(error);
      return;
    }

    console.log(data1);
  }
);
// Promises
const fs = require("fs").promises;

async function readFile() {

  const data = await fs.readFile(
    "message.txt",
    "utf-8"
  );

  console.log(data);
}

readFile();

// create server
const http = require("http");

const server = http.createServer(
  (request, response) => {

    response.write("Hello from Node.js");

    response.end();
  }
);

server.listen(3000, () => {
  console.log("Server running on port 3000");
});