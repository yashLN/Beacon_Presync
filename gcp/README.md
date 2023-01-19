# Pre-Synced Beacon Node Set up Instruction on GCP


1. Select the `Compute Image` and click on `CREATE INSTANCE` button from image
  <img width="667" alt="image" src="https://user-images.githubusercontent.com/30278308/213388002-9bbf0967-1d23-4efa-aacb-9caa6afbe223.png">
2. Name your beacon node.
  <img width="540" alt="image" src="https://user-images.githubusercontent.com/30278308/213388433-e340380f-de0b-41bb-833e-1233a28c028e.png">
  
3. In `Machine family` please select `E2` in series and `E2-Standard-4` as machine type
   <img width="526" alt="image" src="https://user-images.githubusercontent.com/30278308/213388783-b10c7f7e-455a-41d5-b51b-fe015bd2798d.png">
4. Click on `Create` 
  <img width="510" alt="image" src="https://user-images.githubusercontent.com/30278308/213389052-e2b1a928-d25e-4427-9623-b7a0b15d5caa.png">
5. Login to your Compute Engine using SSH, and give the following commands:
   
```
curl -o deploy.sh https://raw.githubusercontent.com/yashLN/Beacon_Presync/main/deploy.sh
```
6. Enter the following command to change permissions

```
chmod +x deploy.sh
```
7. If you have a JWT token, run the following command:

```
./deploy.sh
```
> **_NOTE:_** It will prompt you to enter your fee recipient/Ethereum/Metamask address.
After entering the address, it will prompt you to enter a JWT token.
> 
8. If you don't have a JWT token, use the following command:

```
./deploy.sh --jwt
```
> **_NOTE:_** It will prompt you to enter your fee recipient/Ethereum/Metamask address.
