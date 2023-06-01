## Adding AAD to the test network

You can use the `addAAD.sh` script to add another organization to the Fabric test network. The `addAAD.sh` script generates the AAD crypto material, creates an AAD organization definition, and adds AAD to a channel on the test network.

You first need to run `./network.sh up createChannel` in the `test-network` directory before you can run the `addAAD.sh` script.

```
./network.sh up createChannel
cd addAAD
./addAAD.sh up
```

If you used `network.sh` to create a channel other than the default `mychannel`, you need pass that name to the `addAAD.sh` script.
```
./network.sh up createChannel -c channel1
cd addAAD
./addAAD.sh up -c channel1
```

You can also re-run the `addAAD.sh` script to add AAD to additional channels.
```
cd ..
./network.sh createChannel -c channel2
cd addAAD
./addAAD.sh up -c channel2
```

For more information, use `./addAAD.sh -h` to see the `addAAD.sh` help text.
