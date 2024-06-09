import time
import numpy as np

class MinerStats:
    def __init__(self, miner):
        self.miner = miner
        self.hash_rate_history = []
        self.block_time_history = []
        self.transaction_fee_history = []

    def update_stats(self):
        # Update hash rate history
        self.hash_rate_history.append(self.miner.hash_rate)

        # Update block time history
        block_time = time.time() - self.miner.blockchain.get_latest_block()['timestamp']
        self.block_time_history.append(block_time)

        # Update transaction fee history
        transaction_fee = self.miner.transaction_fee
        self.transaction_fee_history.append(transaction_fee)

    def calculate_average_hash_rate(self):
        return np.mean(self.hash_rate_history)

    def calculate_average_block_time(self):
        return np.mean(self.block_time_history)

    def calculate_average_transaction_fee(self):
        return np.mean(self.transaction_fee_history)

    def print_stats(self):
        print("Average Hash Rate:", self.calculate_average_hash_rate())
        print("Average Block Time:", self.calculate_average_block_time())
        print("Average Transaction Fee:", self.calculate_average_transaction_fee())
