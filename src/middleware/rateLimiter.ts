// src/middleware/rateLimiter.ts
import { rateLimiterMiddleware } from 'rate-limiter-flexible';

const rateLimiterMiddleware = rateLimiter.middleware({
  points: 10, // 10 requests per 1 hour
  duration: 1 * 60 * 60, // 1 hour
});

export { rateLimiterMiddleware };
