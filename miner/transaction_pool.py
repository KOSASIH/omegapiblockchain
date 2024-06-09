import asyncio
import heapq
from pyswarms import SwarmOptimizer

class TransactionPool:
    def __init__(self):
        self.transactions: List[Dict] = []
        self.transaction_heap: List[Tuple[int, Dict]] = []
        self.swarm_optimizer = SwarmOptimizer(n_particles=100, dimensions=2)

    async def add_transaction(self, transaction: Dict):
        # Add a new transaction to the pool
        self.transactions.append(transaction)
        self.swarm_optimizer.optimize(self.fitness_function, iters=100)
        score = self.swarm_optimizer.gbest_cost
        heapq.heappush(self.transaction_heap, (score, transaction))

    async def get_transactions(self, count: int) -> List[Dict]:
        # Get the top `count` transactions from the pool based on
