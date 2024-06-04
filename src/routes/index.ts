// src/routes/index.ts
import { Router } from 'express';
import { exampleController } from '../controllers';

const router = Router();

router.get('/example', exampleController.getExample);

export { router };
