# Add Monitoring to Beacon Node

# To Run This file 

You need to do the following 

```
curl -o monitor.sh https://raw.githubusercontent.com/yashLN/Beacon_Presync/grafana/grafana/monitor.sh
chmod +x monitor.sh
./monitor.sh
```
---

This will install grafana to you and will provision it on port `3000` but in order to access it you need to allow port `3000` from the console by doing the following:

-  Login to aws console 
-  Go to your [ec2 console]( https://us-east-1.console.aws.amazon.com/ec2/home)
-  Click on your `EC2 Instance ID` ex i-03811ccxxxxxx 
-  Click on the security tab like the following 
    <img width="1119" alt="Screen Shot 2023-01-04 at 2 51 28 PM" src="https://user-images.githubusercontent.com/30278308/210559348-a33dc2ce-d96e-4a7b-b49b-1cc13118c5a2.png">

- Click on `sg url` in security group section  
