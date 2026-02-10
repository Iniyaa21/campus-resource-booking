import express from "express";

const app = express(); 

app.use(express.json()); 

app.get("/", (req, res) => {
  res.send("Hello from backend");
});

app.listen(8000, () => {
  console.log("Server listening at http://localhost:8000");
})