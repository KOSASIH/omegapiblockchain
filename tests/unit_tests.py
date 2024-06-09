# unit_tests.py
import unittest
from omega_pi_blockchain.blockchain import Blockchain
from omega_pi_blockchain.ai.model import OmegaPiAI
from omega_pi_blockchain.ipfs import OmegaPiIPFS

class TestBlockchain(unittest.TestCase):
    def test_blockchain_init(self):
        blockchain = Blockchain()
        self.assertIsNotNone(blockchain)

    def test_add_transaction(self):
        blockchain = Blockchain()
        transaction = {'from': 'Alice', 'to': 'Bob', 'amount': 10}
        blockchain.add_transaction(transaction)
        self.assertIn(transaction, blockchain.transactions)

    def test_get_blockchain(self):
        blockchain = Blockchain()
        blockchain_data = blockchain.get_blockchain()
        self.assertIsNotNone(blockchain_data)

class TestOmegaPiAI(unittest.TestCase):
    def test_ai_init(self):
        ai = OmegaPiAI()
        self.assertIsNotNone(ai)

    def test_ai_predict(self):
        ai = OmegaPiAI()
        input_data = [1, 2, 3]
        output = ai.predict(input_data)
        self.assertIsNotNone(output)

class TestOmegaPiIPFS(unittest.TestCase):
    def test_ipfs_init(self):
        ipfs = OmegaPiIPFS()
        self.assertIsNotNone(ipfs)

    def test_ipfs_add_file(self):
        ipfs = OmegaPiIPFS()
        file_data = b'Hello, World!'
        cid = ipfs.add_file(file_data)
        self.assertIsNotNone(cid)

if __name__ == '__main__':
    unittest.main()
