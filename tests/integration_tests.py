# integration_tests.py
import unittest
from omega_pi_blockchain.node import app

class TestNode(unittest.TestCase):
    def test_node_init(self):
        node = app
        self.assertIsNotNone(node)

    def test_node_transactions(self):
        node = app
        transaction = {'from': 'Alice', 'to': 'Bob', 'amount': 10}
        response = node.post('/transactions', json=transaction)
        self.assertEqual(response.status_code, 200)

    def test_node_blockchain(self):
        node = app
        response = node.get('/blockchain')
        self.assertEqual(response.status_code, 200)

    def test_node_ai_predict(self):
        node = app
        input_data = [1, 2, 3]
        response = node.post('/ai/predict', json=input_data)
        self.assertEqual(response.status_code, 200)

    def test_node_ipfs_add_file(self):
        node = app
        file_data = b'Hello, World!'
        response = node.post('/ipfs/add', json=file_data)
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
