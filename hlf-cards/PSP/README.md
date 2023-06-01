## Adding PSP to the test network

You can use the `addPSP.sh` script to add another organization to the Fabric test network. The `addPSP.sh` script generates the PSP crypto material, creates an PSP organization definition, and adds PSP to a channel on the test network.

You first need to run `./network.sh up createChannel` in the `test-network` directory before you can run the `addPSP.sh` script.

```
./network.sh up createChannel
cd addPSP
./addPSP.sh up
```

If you used `network.sh` to create a channel other than the default `mychannel`, you need pass that name to the `addPSP.sh` script.
```
./network.sh up createChannel -c channel1
cd addPSP
./addPSP.sh up -c channel1
```

You can also re-run the `addPSP.sh` script to add PSP to additional channels.
```
cd ..
./network.sh createChannel -c channel2
cd addPSP
./addPSP.sh up -c channel2
```

For more information, use `./addPSP.sh -h` to see the `addPSP.sh` help text.
