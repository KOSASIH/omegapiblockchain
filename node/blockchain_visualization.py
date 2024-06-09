import json
import requests
import matplotlib.pyplot as plt

class BlockchainVisualization:
    def __init__(self,blockchain: 'Blockchain'):
        self.blockchain = blockchain

    def visualize_blockchain(self):
        # Visualize the blockchain using matplotlib
        blocks = self.blockchain.chain
        heights = [block['index'] for block in blocks]
        plt.bar(range(len(blocks)), heights)
        plt.xlabel('Block Index')
        plt.ylabel('Block Height')
        plt.show()

    def visualize_transaction_flow(self):
        # Visualize the transaction flow using matplotlib
        transactions = []
        for block in self.blockchain.chain:
            transactions.extend(block['transactions'])
        senders = [t['sender'] for t in transactions]
        recipients = [t['recipient'] for t in transactions]
        plt.hist(senders, bins=50, alpha=0.5, label='Senders')
        plt.hist(recipients, bins=50, alpha=0.5, label='Recipients')
        plt.xlabel('Address')
        plt.ylabel('Transaction Count')
        plt.legend()
        plt.show()
