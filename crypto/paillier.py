# paillier.py
import random
import math
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

class Paillier:
    def __init__(self, key_size=2048):
        self.key_size = key_size
        self.p, self.q = self.generate_large_primes(key_size)
        self.n = self.p * self.q
        self.lambda_ = (self.p - 1) * (self.q - 1)
        self.g = self.find_generator(self.n)
        self.mu = self.compute_mu(self.lambda_, self.n)

    def generate_large_primes(self, key_size):
        # Generate two large prime numbers, p and q
        p = random.randint(2**(key_size-1), 2**key_size - 1)
        while not self.is_prime(p):
            p = random.randint(2**(key_size-1), 2**key_size - 1)
        q = random.randint(2**(key_size-1), 2**key_size - 1)
        while not self.is_prime(q) or q == p:
            q = random.randint(2**(key_size-1), 2**key_size - 1)
        return p, q

    def is_prime(self, num):
        # Check if a number is prime using the Miller-Rabin primality test
        if num < 2:
            return False
        for _ in range(5):
            a = random.randint(2, num - 2)
            x = pow(a, num - 1, num)
            if x == 1 or x == num - 1:
                continue
            for _ in range(4):
                x = pow(x, 2, num)
                if x == num - 1:
                    break
            else:
                return False
        return True

    def find_generator(self, n):
        # Find a generator, g, for the multiplicative group of integers modulo n
        for g in range(2, n):
            if self.is_generator(g, n):
                return g
        raise ValueError("No generator found")

    def is_generator(self, g, n):
        # Check if g is a generator for the multiplicative group of integers modulo n
        for i in range(1, self.lambda_):
            if pow(g, i, n) == 1:
                return False
        return True

    def compute_mu(self, lambda_, n):
        # Compute the value of mu, which is used in the decryption process
        return pow(self.g, lambda_, n)

    def keygen(self):
        # Generate a public and private key pair
        public_key = (self.g, self.n)
        private_key = (self.lambda_, self.mu)
        return public_key, private_key

    def encrypt(self, message, public_key):
        # Encrypt a message using the Paillier encryption scheme
        g, n = public_key
        r = random.randint(1, n - 1)
        c = (pow(g, message, n**2) * pow(r**n, n, n**2)) % n**2
        return c

    def decrypt(self, ciphertext, private_key):
        # Decrypt a ciphertext using the Paillier decryption scheme
        lambda_, mu = private_key
        n = self.n
        c = ciphertext
        m = (pow(c, lambda_, n**2) * mu) % n
        return m

    def homomorphic_add(self, ciphertext1, ciphertext2, public_key):
        # Perform homomorphic addition on two ciphertexts
        g, n = public_key
        c1, c2 = ciphertext1, ciphertext2
        c_add = (c1 * c2) % n**2
        return c_add

    def homomorphic_multiply(self, ciphertext, scalar, public_key):
        # Perform homomorphic multiplication on a ciphertext and a scalar
        g, n = public_key
        c, scalar = ciphertext, scalar
        c_mul = pow(c, scalar, n**2)
        return c_mul
