import db from "../db.js";

export async function listResources() {
  const res = await db.query(
    `SELECT resource_id, name, resource_type, capacity, created_at
     FROM resources
     ORDER BY name`,
  );
  return res.rows;
}
