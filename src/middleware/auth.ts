// src/middleware/auth.ts
import jwt from 'jsonwebtoken';

const authenticate = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET as string);
    req.user = decoded;
    next();
  } catch (error) {
    returnres.status(401).json({ message: 'Unauthorized' });
  }
};

export { authenticate };
