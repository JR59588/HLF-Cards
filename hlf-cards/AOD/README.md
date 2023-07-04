## Adding AOD to the test network

You can use the `addAOD.sh` script to add another organization to the Fabric test network. The `addAOD.sh` script generates the AOD crypto material, creates an AOD organization definition, and adds AOD to a channel on the test network.

You first need to run `./network.sh up createChannel` in the `test-network` directory before you can run the `addAOD.sh` script.

```
./network.sh up createChannel
cd addAOD
./addAOD.sh up
```

If you used `network.sh` to create a channel other than the default `mychannel`, you need pass that name to the `addAOD.sh` script.
```
./network.sh up createChannel -c channel1
cd addAOD
./addAOD.sh up -c channel1
```

You can also re-run the `addAOD.sh` script to add AOD to additional channels.
```
cd ..
./network.sh createChannel -c channel2
cd addAOD
./addAOD.sh up -c channel2
```

For more information, use `./addAOD.sh -h` to see the `addAOD.sh` help text.
