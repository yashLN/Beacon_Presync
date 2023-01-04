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
    <img width="1138" alt="image" src="https://user-images.githubusercontent.com/30278308/210559247-b3d6f79c-524c-4ab3-8f72-e586951b9905.png">

- Click on `sg url` in security group section  
