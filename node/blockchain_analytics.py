import json
import requests

class BlockchainAnalytics:
    def __init__(self, blockchain: 'Blockchain'):
        self.blockchain = blockchain

    def get_blockchain_info(self) -> Dict:
        # Get information about the entire blockchain
        return {
            'chain_length': len(self.blockchain.chain),
            'difficulty': self.blockchain.mining_difficulty,
            'genesis_block': self.get_block_info(0)
        }

    def get_block_info(self, block_index: int) -> Dict:
        # Get information about a specific block
        block = self.blockchain.chain[block_index]
        return {
            'index': block['index'],
            'previous_hash': block['previous_hash'],
            'transactions': block['transactions'],
            'timestamp': block['timestamp'],
            'nonce': block['nonce'],
            'hash': block['hash']
        }

    def get_transaction_info(self, transaction_hash: str) -> Dict:
        # Get information about a specific transaction
        for block in self.blockchain.chain:
            for transaction in block['transactions']:
                if transaction['hash'] == transaction_hash:
                    return transaction
        return {}

    def get_balance(self, address: str) -> float:
        # Get the balance of a specific address
        balance = 0
        for block in self.blockchain.chain:
            for transaction in block['transactions']:
                if transaction['sender'] == address:
                    balance -= transaction['amount']
                elif transaction['recipient'] == address:
                    balance += transaction['amount']
        return balance

    def get_rich_list(self, count: int) -> List[Dict]:
        # Get the top `count` richest addresses
        addresses = {}
        for block in self.blockchain.chain:
            for transaction in block['transactions']:
                if transaction['sender'] not in addresses:
                    addresses[transaction['sender']] = 0
                if transaction['recipient'] not in addresses:
                    addresses[transaction['recipient']] = 0
                addresses[transaction['sender']] -= transaction['amount']
                addresses[transaction['recipient']] += transaction['amount']
        sorted_addresses = sorted(addresses.items(), key=lambda x: x[1], reverse=True)
        return sorted_addresses[:count]
