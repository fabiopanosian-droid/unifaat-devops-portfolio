const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.json({
    orders: [],
    message: 'Módulo de pedidos em construção'
  });
});

module.exports = router;
