import hashlib
import secrets

class Cryptography:
    @staticmethod
    def generate_key_pair():
        # Generate a new key pair using the secp256k1 curve
        private_key = secrets.token_bytes(32)
        public_key = Cryptography.private_to_public(private_key)
        return private_key, public_key

    @staticmethod
    def private_to_public(private_key: bytes) -> bytes:
        # Convert a private key to a public key
        curve_order = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141
        point = int.from_bytes(private_key, 'big') % curve_order
        x, y = Cryptography._double_and_add(point, 7)
        return x.to_bytes(32, 'big') + y.to_bytes(32, 'big')

    @staticmethod
    def _double_and_add(point: int, index: int) -> (int, int):
        # Perform double-and-add operations on the secp256k1 curve
        if index == 0:
            return 0, 1
        elif index == 1:
            return point & 1, (point >> 1) & ((1 << 256) - 1)
        else:
            half = Cryptography._double_and_add(point, index // 2)[1]
            if index % 2 == 0:
                return (half << 1) & ((1 << 256) - 1), half & ((1 << 256) - 1)
            else:
                return (half << 1) & ((1 << 256) - 1) + 1, half & ((1 << 256) - 1)

    @staticmethod
    def sign_transaction(private_key: bytes, transaction: Dict) -> Dict:
        # Sign a transaction using the ECDSA algorithm
        message = transaction['sender'] + transaction['recipient'] + str(transaction['amount'])
        signature = ecdsa.SigningKey.from_string(private_key, curve=ecdsa.SECP256k1).sign(message.encode())
        return {
            **transaction,
            'signature': signature.hex()
        }

    @staticmethod
    def verify_transaction(public_key: bytes, transaction: Dict) -> bool:
        # Verify a transaction signature using the ECDSA algorithm
        message = transaction['sender'] + transaction['recipient'] + str(transaction['amount'])
        try:
            ecdsa.VerifyingKey.from_string(public_key, curve=ecdsa.SECP256k1).verify(
                bytes.fromhex(transaction['signature']),
                message.encode()
            )
            return True
        except ecdsa.BadSignatureError:
            return False
