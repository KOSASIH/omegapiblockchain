import asyncio
import heapq

class TransactionPool:
    def __init__(self):
        self.transactions: List[Dict] = []
        self.transaction_heap: List[Tuple[int, Dict]] = []

    async def add_transaction(self, transaction: Dict):
        # Add a new transaction to the pool
        self.transactions.append(transaction)
        heapq.heappush(self.transaction_heap, (transaction['fee'], transaction))

    async def get_transactions(self, count: int) -> List[Dict]:
        # Get the top `count` transactions from the pool based on their fees
        transactions = []
        for _ in range(count):
            fee, transaction = heapq.heappop(self.transaction_heap)
            transactions.append(transaction)
        return transactions

    async def remove_transactions(self, transactions: List[Dict]):
        # Remove transactions from the pool
        for transaction in transactions:
            self.transactions.remove(transaction)
           self.transaction_heap.remove((transaction['fee'], transaction))
