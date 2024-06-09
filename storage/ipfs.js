// ipfs.js
import { create } from 'ipfs-http-client';
import { Buffer } from 'buffer';

const ipfs = create({
  host: 'localhost',
  port: 5001,
  protocol: 'http'
});

class OmegaPiIPFS {
  async addFile(file) {
    // Add a file to IPFS
    const fileBuffer = Buffer.from(file);
    const fileCID = await ipfs.add(fileBuffer);
    return fileCID;
  }

  async getFile(cid) {
    // Get a file from IPFS
    const fileBuffer = await ipfs.cat(cid);
    return fileBuffer.toString();
  }

  async addDirectory(directory) {
    // Add a directory to IPFS
    const directoryCID = await ipfs.add(directory);
    return directoryCID;
  }

  async getDirectory(cid) {
    // Get a directory from IPFS
    const directoryBuffer = await ipfs.cat(cid);
    return directoryBuffer.toString();
  }

  async pin(cid) {
    // Pin a CID to IPFS
    await ipfs.pin.add(cid);
  }

  async unpin(cid) {
    // Unpin a CID from IPFS
    await ipfs.pin.rm(cid);
  }

  async get_pins() {
    // Get a list of pinned CIDs
    const pins = await ipfs.pin.ls();
    return pins;
  }

  async get_cid_info(cid) {
    // Get information about a CID
    const cidInfo = await ipfs.dag.get(cid);
    return cidInfo;
  }
}

export default OmegaPiIPFS;
