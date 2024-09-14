const express = require("express");


const db = require("../db/connectDb");
const app = express();

app.use(express.json());

const signupRoutes = require("../routes/signupRoutes");
app.use("/api", signupRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));