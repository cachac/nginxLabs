// import React from "react";
import ReactDOM from "react-dom/client.js";
import App from "./App.jsx";
import Micro from "./SSR.js";
import "./index.css";
import { BrowserRouter, Routes, Route } from "react-router-dom";

ReactDOM.createRoot(document.getElementById("root")).render(
  <BrowserRouter>
    <Routes>
      <Route exact path="/" element={<App />} />
      <Route exact path="/micro" element={<Micro />} />
    </Routes>
  </BrowserRouter>
);
