import asyncio
import hashlib
import json
import os
import random
import time
from typing import Dict, List

class MinerNode:
    def __init__(self, node_id: str, blockchain: 'Blockchain'):
        self.node_id = node_id
        self.blockchain = blockchain
        self.peers: List['MinerNode'] = []
        self.pending_transactions: List[Dict] = []
        self.mining_difficulty: int = 3

    async def start_mining(self):
        while True:
            # Get pending transactions and create a new block
            block = self.create_block(self.pending_transactions)
            self.pending_transactions = []

            # Mine the block
            nonce, hash = self.mine_block(block)

            # Broadcast the block to peers
            await self.broadcast_block(block, nonce, hash)

            # Update the blockchain
            self.blockchain.add_block(block)

            # Sleep for a random time to avoid collisions
            await asyncio.sleep(random.uniform(1, 5))

    def create_block(self, transactions: List[Dict]) -> Dict:
        # Create a new block with the given transactions
        block = {
            'index': len(self.blockchain.chain) + 1,
            'previous_hash': self.blockchain.chain[-1]['hash'],
            'transactions': transactions,
            'timestamp': int(time.time()),
            'nonce': 0,
            'hash': ''
        }
        return block

    def mine_block(self, block: Dict) -> (int, str):
        # Mine the block using the proof-of-work algorithm
        nonce = 0
        while True:
            block['nonce'] = nonce
            block_hash = self.calculate_hash(block)
            if self.validate_hash(block_hash):
                return nonce, block_hash
            nonce += 1

    def calculate_hash(self, block: Dict) -> str:
        # Calculate the block hash using SHA-256
        block_str = json.dumps(block, sort_keys=True)
        return hashlib.sha256(block_str.encode()).hexdigest()

    def validate_hash(self, block_hash: str) -> bool:
        # Validate the block hash based on the mining difficulty
        return block_hash.startswith('0' * self.mining_difficulty)

    async def broadcast_block(self, block: Dict, nonce: int, hash: str):
        # Broadcast the block to peers using WebSockets or another communication mechanism
        pass

class Blockchain:
    def __init__(self):
        self.chain: List[Dict] = [self.create_genesis_block()]

    def create_genesis_block(self) -> Dict:
        # Create the genesis block
        return {
            'index': 0,
            'previous_hash': '',
            'transactions': [],
            'timestamp': int(time.time()),
            'nonce': 0,
            'hash': self.calculate_hash({
                'index': 0,
                'previous_hash': '',
                'transactions': [],
                'timestamp': int(time.time()),
                'nonce': 0
            })
        }

    def add_block(self, block: Dict):
        # Add a new block to the blockchain
        self.chain.append(block)

    def calculate_hash(self, block: Dict) -> str:
        # Calculate the block hash using SHA-256
        block_str = json.dumps(block, sort_keys=True)
        return hashlib.sha256(block_str.encode()).hexdigest()
