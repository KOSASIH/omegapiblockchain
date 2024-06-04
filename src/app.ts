// src/app.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { router } from './routes';
import { rateLimiter } from './middleware/rateLimiter';

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

app.use(rateLimiter);
app.use('/api', router);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
