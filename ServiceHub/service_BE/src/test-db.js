import pool from "./config/db.js";

async function testConnection() {
  try {
    const result = await pool.query(
      "SELECT NOW() AS server_time"
    );

    console.log("PostgreSQL connected successfully!");
    console.log(result.rows[0]);
  } catch (error) {
    console.error("Connection failed:", error.message);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
}

testConnection();