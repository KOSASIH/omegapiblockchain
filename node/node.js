// node.js
import express from 'express';
import bodyParser from 'body-parser';
import { Blockchain } from './blockchain';
import { OmegaPiAI } from './ai/model';
import { OmegaPiIPFS } from './ipfs';

const app = express();
app.use(bodyParser.json());

const blockchain = new Blockchain();
const ai = new OmegaPiAI();
const ipfs = new OmegaPiIPFS();

app.post('/transactions', (req, res) => {
  const transaction = req.body;
  blockchain.addTransaction(transaction);
  res.send(`Transaction added: ${transaction}`);
});

app.get('/blockchain', (req, res) => {
  res.send(blockchain.getBlockchain());
});

app.post('/ai/predict', (req, res) => {
  const input = req.body;
  const output = ai.predict(input);
  res.send(`AI prediction: ${output}`);
});

app.post('/ipfs/add', (req, res) => {
  const file = req.body;
  const cid = ipfs.addFile(file);
  res.send(`File added to IPFS: ${cid}`);
});

app.get('/ipfs/get', (req, res) => {
  const cid = req.query.cid;
  const file = ipfs.getFile(cid);
  res.send(`File retrieved from IPFS: ${file}`);
});

app.listen(3000, () => {
  console.log('Node.js server listening on port 3000');
});
