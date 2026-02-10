import express from "express";
import dotenv from "dotenv";
import { listResources } from "./services/resources.js";
import { createBooking } from "./services/bookings.js";

dotenv.config();

const app = express();
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Hello from backend");
});

app.get("/resources", async (req, res) => {
  try {
    const rows = await listResources();
    res.json(rows);
  } catch (err) {
    console.error("Error fetching resources", err);
    res.status(500).json({ error: "database_error" });
  }
});

app.post("/bookings", async (req, res) => {
  const { resource_id, user_id, start_time, end_time } = req.body;
  if (!resource_id || !user_id || !start_time || !end_time) {
    return res.status(400).json({ error: "missing_fields" });
  }

  try {
    const result = await createBooking({
      resource_id,
      user_id,
      start_time,
      end_time,
    });
    if (result.conflict)
      return res.status(409).json({ error: "booking_conflict" });
    res.status(201).json(result.booking);
  } catch (err) {
    console.error("Error creating booking", err);
    res.status(500).json({ error: "database_error" });
  }
});

const port = process.env.PORT ? parseInt(process.env.PORT, 10) : 8000;
app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
