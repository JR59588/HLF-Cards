## Adding ACD to the test network

You can use the `addACD.sh` script to add another organization to the Fabric test network. The `addACD.sh` script generates the ACD crypto material, creates an ACD organization definition, and adds ACD to a channel on the test network.

You first need to run `./network.sh up createChannel` in the `test-network` directory before you can run the `addACD.sh` script.

```
./network.sh up createChannel
cd addACD
./addACD.sh up
```

If you used `network.sh` to create a channel other than the default `mychannel`, you need pass that name to the `addACD.sh` script.
```
./network.sh up createChannel -c channel1
cd addACD
./addACD.sh up -c channel1
```

You can also re-run the `addACD.sh` script to add ACD to additional channels.
```
cd ..
./network.sh createChannel -c channel2
cd addACD
./addACD.sh up -c channel2
```

For more information, use `./addACD.sh -h` to see the `addACD.sh` help text.
