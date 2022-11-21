CHAPTER 1: Deployment, Provisioning and Automation.

#Ec2 :
-like vm
-capacity what you need right now,
-grow and shrink whenever, 
-pay only when instance is running
-by default, ec2 instances cannot use other services without permissions (need IAM Roles)
-EC2 can communicate with each other by default (if in same subnet), otherwise it depends of connection route (security groups, NACL, Route Table, even firewall. )

#EBS : elastic block store (ssd volumes, like physical disks) attachable to ec2 :
-Storage volumes that you can attach to EC2 instances. Its like a physical disc, but in a cloud.
-SSD: 'gp2' <=16k IOPS/v  'io1' <=64k IOPS/v OR 50 IOPS/GiB  'io2'<=500 IOPS/GiB
-HDD: 'st1' 500mb/v  'sc1' 250/v [hdd discs cannot be boot volumes]
-Encyptable (kms-keys)

Use Cases:
-File system,DB,OS,Store Data,install applications.

Pros:
-Highly Available : Automatically replicated within single AZ, to protect against hardware failures.
-Scalable : Dynamically "only increase" capacity and change type volume with no downtime (EC2>Volumes>select volume>action>modify).
-to decrease capacity : snapshot the volume, create new smaller volume,attach>format>mount new volume to ec2 > copy files > prepare volume (grub etc) > detach old volume
link:https://medium.com/@m.yunan.helmy/decrease-the-size-of-ebs-volume-in-your-ec2-instance-ea326e951bce#:~:text=1%20Getting%20started.%20Le%20t%20%E2%80%99s%20exercise.%20We,the%20new%20volume.%20Check%20whether%20the...%20More%20


#Bastion host :
-used for jumping from public subnet to private via ssh/rdp.
-located in public subnet
-need to use security groups associated with private subnet to connect via ssh (because its located in public subnet)

#Elastic Load Balancer:
-Distributes traffic across a group of servers.
-We can configure ELB to direct connections to server which is the least busy, or round-robin (one by one)
-When server is down, ELB will skip this server until it comes back online.
-is located in public subnet.

#Setting ELB load balancing algorythm :
 EC2>Load Balancers> "Target Groups">EDIT ATTRIBUTES> 
 -Round Robin - one by one, best for same ec2 instances
 -Least outstanding requests - these ec2, which have the least active requests
 
#Types of ELB :
Application load balancer (TCP : HTTP/HTTPS):
-Works on layer 7 of OSI model
-Can use HTTP request header to send request to defined server e.g -   at Car selling site every header has it own server.
                                                                            Repairs - own server
                                                                            Loans - own server 
                                                                            Sales - own server

Network load balancer (TCP/UDP):
-Used for low latency,high performance apps - most expensive.
-Works at Layer 4 (Transport)

Classic load balancer:
-HTTP/HTTPS/TCP (LEGACY)

Gateway load balancer:
-Third party virtual appliances like firewalls

X-forwarded-for:
-Identify the originating ipv4 adress of end user connecting through load balancer.
#eg. client ip 124.12.3.231 ---> ELB 10.0.0.23 ----> EC2 10.0.0.23
#Without x-forwarder-for hhtp header, the ec2 will see ELB ip (10.0.0.2) instead of client ip (124.12.3.231)

#OSI MODEL:
7. Application Layer [DATA] - Human-Computer interaction layer, e.g. Browser
6. Presentation Layer [DATA] - ensures that data is in usable format; data encyption occurs.
5. Session Layer [DATA] - starts and ends session, and also keeps them isolated.
4. Transport Layer [SEGMENTS] - transmits data using transmission protocols including TCP and UDP
3. Network Layer [PACKETS] - logical or IP adressing; determines best path to destination. 
2. Data-Link Layer [FRAMES] - switches - physically transmits data based on MAC adresses.
1. Physical Layer [BITS] - signal/cable - transmits bits and bytes over physical devices.

#ELB error massages :
client side - 4xx
"s"erver side - "5"xx


http 502 - security groups
http 503 - no target registered
http 504 - gateway timeout - app error

http 400 - bad request (malformed request)
http 408 - request timeout (timeout)
http 464 - unsupported protocol 

#Creating ELB
1. Launch Webserver (Ec2 instances with httpd or nginx installed)
2. Create an elastic load balancer
AWS Console>EC2>Load Balancers

#ELB access logs (Access logs - logs of all ELB request, that we want to store on e.g. s3):
-disabled by default
-stored in s3 (encypted, and will be decrypted when you access them)
-published every 5 minutes.

#Enabling Access logs:
EC2>Load Balancers>YOUR_LOAD_BALANCER>DESCRIPTION>EDIT ATTRIBUTES>ACCESS LOGS> ENABLE

#ELB cloud watch metrics :
-"ELB sends metrics into cloudwatch by default" (we can see them at ec2>load balancers>YOUR_LOAD_BALANCER>Monitoring)
examples :

HealthyHostCount - The number of healthy instances registered with your load balancer
UnHealthyHostCount -The number of UNHEALTHY instances registered with your load balancer
RequestCount - The number of "requests completed" or "connections made during the specified interval (1 or 5 minutes)".
TargetResponseTime - The total time elapsed (in seconds, with millisecond precision) from the time the load balancer sent the request to a target until the target started to send the response
HTTP Status Code - The number of errors with HTTP status. e.g. HTTP 5XXs

#Sticky sessions :
-Overrides load balancing algorythm, session 'cookie' indentifies that session belongs to the 'same user'.
While the cookie is valid, all request from the same user are sent to same target.
-are used to hold cache on web server, e.g shopping cart in e-store.

#Enabling Sticky Sessions:
EC2>Load Balancers>(Target Groups)>EDIT ATTRIBUTES>STICKYNESS

#Ec2 image builder (service, where we can create our ami images based on existing ones):
Steps:
1-Base OS - base os. e.g. Linux 2 AMI.
2-Software - Software, that we want to have installed e.g. Python, httpd,cloudwatch agent etc.
3-Test - aws will run tests of that image e.g. does it boot correctly
4-Distribute - distribute to the region of your choice , your actual region by default

Terminology:
image pipeline - settings and process
image recipe - source image (e.g. Amazon Linux 2 AMI) and build components (Apache Tomcat, RDS etc)
build components - the software to include

#How to create custom AMI
1.Create IAM role:
IAM>ROLES>Create Role>EC2>search for EC2InstanceProfileForImageBuilder and AmazonSSMManagedInstanceCore>Your_Name_Role>Create Role.

2.Create image pipeline:
EC2 Image Builder 
#e.g. EC2 Image Builder>Build schedule tab - Manual>Next>Create New Recipe> Amazon AMI >Your_Recipe_name + version>Managed images>Amazon Linux2>Quick start (amazon Managed)>
#> Image name (select version of ami)> use latest version>COMPONENTS (cloudwatch agent e.g) type update-linux> Test components - simple-boot-test-linux >create new infrastructure configuration>My_Config_name>
#> choose IAM role created before>t2micro>next

3.Execute the pipeline
Select pipeline>Actions>Run Pipeline. Now EC2 will be created and will build and test new image.

#CloudFormation - AWS IaaC like terraform
-Works only with AWS Resources!
-USES yaml/json :
parameters : custom values like name of SSH key.
conditions : provision resources based on environment
'RESOURCES : resources that CloudFormation will create (subnets/ec2/s3 etc.) - MANDATORY!'
Mappings : create custom mappings like -Region-AMI.
Transform : allows you to reference code located in S3 , e.g. Lambda code for providing Lambda function or reusable snippets of CloudFormation code.

CloudFormation stack is resulting set of resources CloudFormation builds from your template.
Resource Access Manager - allows to share resources with other accounts (like ec2,s3)

#Provisioning AWS Resources Using CloudFormation
1.Create New Key-Pair (EC2>Network & Security>Key-Pairs)
2.Create New Stack (CloudFormation>Create stack)
Steps:
a)Specify template - prepare or specify template
b)Specify stack details - assign stack name and KeyName created before
c)Configure stack options - Iam Roles, Stack failure options, Stack policy, Rollback configuration, SNS, Stack creation options(termination protection)
d)Review - DONE!

logging into that ec2 using ssh:
sudo chmod 400 mynewkp-pem.pem
sudo ssh ec2-user@3.87.193.199 -i mynewkp-pem.pem (we have to be in this key dir location)

#Updating CloudFormation stack
CloudFormation> Select existing stack> Update stack> Edit template in designer> Edit json/yaml > Create stack (cloud icon) > next > I acknowledge > next (DONE)

#Troubleshooting CloudFormation:
CloudFormation console> Events

"By Default CF will roll back to previous state if CF operation fails"

Common errors:
Invalid Ami - watch out for region of AMI (image AMI can be found at EC2>Images>AMI Catalog)
   eg. Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume. Type "ami-090fa75af13c156b4" (64-bit (x86)) / ami-020ef1e2f6c2cc6d6 (64-bit (Arm)))
IAM - lack of permissions, for creating e.g. Ec2.
Limits - Resource limit exceeded e.g "20 EC2 instance limit per region".
Failed Rollback - CF is unable to roll back a change.

Common errors solutions:
Insufficient Permissions - add permissions to resources you are trying to create,delete,modify
Resource Limit Exceeded - request a limit increase or delete unnecesary resources and retry.
Update_Rollback_Failed - fix the error causing the failure and retry. Maybe something was changed Manually, so you need to repair stack manually too.

#CloudFormation Best Practices:
IAM - control access to Cloudformation using IAM
Service Limits - If you hit a limit, Cloudformation will fail to create your stack.
Avoid manual updates!
Use Cloud Trail - use to track changes, along with who made them.
Use a "Stack Policy" (stack=caly szablon cloudformation)- Protect critical stack resources from unintentional updates and mistakes caused by human error.

#CloudFormation stack sets:
StackSets are for Create/delete/update CF stacks "across multiple AWS accounts and regions" using single operation. 
eg. launching same EC2 for 2 different regions us-east-1 and us-east-2

To launch a CF stack in another AWS account, we need the "cross-account role".
#1: In Administrator account (which will launch StackSets) Create IAM role with AWSCloudFormationStackSetExecutionRole policy 

....

#Blue/Green Deployment :
"low risk", set traffic to new version if tests were ok. easy to rollback - just redirect traffic to original env.

#Rolling deployment :
deploying in "batches", we need only 1 server so its "cost effiective". But its complexity because of mixed env. Rolling back involves a re-deployment.

#Canary Deployment :
deploying new version to small numer of servers, direct e.g 10% of traffic to new version, and that 10% will be testing new version. 
To roll back just direct 100% again to the original version

#OpsWorks (Automated configuration management service - like ansible)  
-compatible with Puppet and Chef.
-configuration as a code.

#Systems Manager (Amazon SSM):
Run Command: 
-to use a command on all/selected EC2 e.g. run pre-defined commands and scripts.
-Stop/restart,terminate, or re-size instances
-Attach/detach EBS volumes
-Install invidual patches and packages

Automated patching using AWS Systems Manager (AWS PATCH MANAGER) "SSM Run Command" :
1.Create IAM role : AmazonEC2RoleForSSM #Create permissions for EC2 to use SSM.
2.Launch a EC2 Instance : attach the role created above #Create a EC2 and attach created IAM Role to it.
3.Apply your own shell script

a)IAM>Roles>Create Role>in AWS SERVICE pick EC2 and hit Next> search for SSM and pick "AmazonEC2RoleForSSM" and hit NEXT> Name a Role and Next (DONE)
b)EC2>name etc> Advanced settings > Assign created IAM Role > and finish creating ec2
c)Systems Manager> SSM>RUN COMMAND>RUN COMMAND> AWS-RunShellScript> Commands > Targets>RUN     #also there are Output Options(location of output), SNS, and CLI command for that
#To view output of Run Command, go to s3 bucket you selected, or SSM>Run Command> Command History> select instance > view output.

Patch Manager:
-to patch all/selected EC2

Automated patching using AWS Systems Manager "SSM Patch Manager" :
1.Create IAM role with AmazonEC2RoleForSSM policy #Create permissions for EC2 to use SSM.
2.Launch an EC2 Instance : attach the role created above #Create a EC2 and attach created IAM Role to it.
3.Patch your EC2 with latest Python patch : 
#We''ll find our EC2 instances with SSM-Role attached in the Fleet Manager section of SSM.

a)IAM>Roles>Create Role>in AWS SERVICE pick EC2 and hit Next> search for SSM and select AmazonEC2RoleForSSM and hit NEXT> Name a Role and Next (DONE)
b)EC2>name etc> Advanced settings > Assign created IAM Role > and finish creating ec2
c)Systems Manager> Patch Manager>view predefined patches>search for Python, pick and PATCH NOW>Scan and Install > Reboot if needed > Patch only targets i specify, use tag and click patch now.

#Chapter 1 Quiz errors
Throughput Optimized HDD - for big data,data warehouses, and log processing.
Resource Access Manager - "share"  with other accounts / CloudFormation Stack-Set - "create" stacks across multiple accounts and Region

Score: 94%


'DO POWTORZENIA I PRAKTYKI - IAM !!!' - in next chapters
-----------------------------------------------------------------------------------------------------------------------------

CHAPTER 2
#CloudWatch :
Monitoring the performance and health of systems.

#What can CloudWatch Monitor :
"Compute":   
EC2 / ASG / ELB /Route 53 health checks / Lambda

"Storage" :
-EBS volumes/ Storage gateway / CloudFront

"Databases and Analytics":
-DynamoDB tables /ElastiCache nodes / RDS instances / Redshift/ Elastic Map Reduce

"Other":
-SNS topics/ SQS queues/ API Gateway/ Estimated AWS Charges

#CloudWatch Metrics:
All EC2 instances "by default" sends "HOST-LEVEL METRICS" (health and performance) to CloudWatch e.g.:
-CPU UTILIZATION
-Network number of packets recieved and sent by the instance
-Disk read and write operations
-Status checks
+You can retrieve data from EC2 or ELB instance, even after it has been terminated.

#CloudWatch Metric Frequency:
-5 min intervals by default
-1 min interval for additional charge

#CloudWatch Agent Metrics:
We need to install Cloudwatch Agent to gather "OPERATING SYSTEM-LEVEL METRICS" (only available from within OS) e.g. :
-Memory Usage
-Processes
-Free disk
-CPU idle time

CloudWatch "AGENT" Metric Frequency:
-1 min interval or even 1 second

#Cloudwatch Dashboard :
-Custom View (my metrics)
-Multi-region 

#Creating CloudWatch Dashboard:
For ec2 metrics:
CloudWatch>Dashboards>Create Dashboard>Line>Metrics>EC2>Per-Instance Metrics> Paste instance id (e.g. i-0c8b8412dad38bf5a) and pick metrics you desire > create widget (done)

#CloudWatch Logs:
-Allows to monitor operating system and application logs.
-"CloudWatch Agent need to be installed" on that EC2

Use Cases:
1.Centralized logs :
-Application logs , e.g. Apache logs
-Systems logs, e.g. EC2
-AWS Services, e.g. Cloudtrail
2.View, search, filter by error code or messages
3.Set notifications

Terminology:
Log Events - Event message and time stamp
Log Stream - Sequence of log events, e.g. an apache log from a specific host. Must belong to a log group.
Log Group - Group "LOG STREAMS" together. No limit on the number of log streams in a log group.
e.g: 2x EC2 are sending "LOG EVENTS" to Cloudwatch in "LOG STREAMS". Both "LOG STEAMS" are "LOG GROUP"

Retention Settings: #retention - zatrzymanie/ jak dlugo logi beda "lezec"
-from 1day to 10years
-expired log events are automatically deleted
-retention settings can be applied o an entire log group

#[LAB] Collecting metrics and logs using Cloudwatch agent:
1.Launch EC2 instance with CloudWatchAgentServerPolicy and add inbound HTTPS in Security Group. #CloudWatch agent uses HTTPS to talk with our EC2.
2.Install and launch the CloudWatch Agent #bootstrap below
3.Add metrics/logs to CloudWatch dashboard. CloudWatchAgent metrics should be there too.
Snippets:

1. Bootstrap script: 
#!/bin/bash
yum update -y

2. Install the CloudWatch Agent: 
sudo yum install amazon-cloudwatch-agent -y

3. Configure the CloudWatch agent: 
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

**** Say no to monitoring CollectD ****
**** Monitor /var/log/messages ****

4. cd /opt/aws/amazon-cloudwatch-agent/bin
   /opt/aws/amazon-cloudwatch-agent/bin/config.json is the config file

5. Start the CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

6. Generate some activity on our system by installing stress - it’s in the Extra Packages for Enterprise Linux (EPEL) repository, so first we'll install the epel repository, then we'll install stress:

sudo amazon-linux-extras install epel -y
sudo yum install stress -y
stress --cpu 1

#[LAB] CloudWatch metric filter:
"Lambda sends logs to CloudWatch by default"
1.Create a Basic Lambda funtion #just basic lambda function "hello world" > save> deploy > test
2.Test #click test few times
3. Go to CloudWatch>Log Groups for your lambda funtion logs
4.Create metric filter -> #CloudWatch>Log Groups>Lambda_funtion_name>ACTIONS-> Create Metric filter
options:
Filter Pattern : specific word, or other conditions (case sensitive)

We can create SNS with metric:
CloudWatch>Metrics> All Metrics> Pick Lambda Metric -> GRAPHED METRICS > Actions -> ALARM.

#[LAB] CloudWatch Logs insight:
Interactive viewing logs
1.Create lamba function>CloudWatch logs insight>Select lambda log group> set querry> run querry

#receiving notifications with CloudWatch:
CloudWatch Alarm:
-Alarms - can select ec2 CPUUtlization, ELb latency, or charges.
-Tresholds - when to trigger alarm
-Use Case - sends SNS or execute Auto Scaling policy 

AWS Health - can sends health event to AWS EventBridge , triggering CloudWatch alarm , which will trigger an action.

#[lab] Creating Cloudwatch alarms:
1. create ec2 with detailed monitoring - Ec2> Launch instance> Advaned > Cloudwatch detailed monitoring.
2.Create alarm - CloudWatch>Alarms>Create Alarm
3. Configure an Email Alert - Cloudwatch>alarms>in alarm>create alarm> select metric in which instance you want.

#CloudTrail 
-Tracks user activity (with "API calls") in aws account.
-CloudTrail is enabled by default.
-tracks events related to creation,modification, or deletion resources (s3/ec2/iam etc.)
-keeps "90 days" worth of event history

Keeping logs longer than 90 days:
-We can extend it by creating a "trail" and save logs to s3 (These logs are "encrypted" by default with SSE)
-"Log integrity validation" -  (keeps tracks of log changes/deletion)
-Trail will apply to "all regions" by default.

Use Cases:
-After-the-fact investigation of incidents in our AWS account
-Near-real-time Security analysis of user activity
-Can be used to help ypu meet industry compliance and autid requirements.

#[lab] Working with CloudTrail:
Keeping logs for more than 90 days:
Create Trail - CloudTrail>Trails>Create Trail>
#while creating a trail, we can send these logs to CloudWatch Logs, to notify us when specific activity occurs.
#e.g. we can search for keyword "create" in logs, and set notification, when new resource is created and send alarm to our email. 

#AWS Config (checking compliance and desired state, but can also remediate(korygowac) to our desired state using Systems Manager):
-Configuration monitoring : Continously monitors the configuration of you AWS resources.
-Desired State : evaluates configurations against desired state that you define.
-Can sends notifications to EventBridge and SNS, if resource is in non-compliant state.
-Automatic Remediation : Automatically Remediates (koryguje) non-compliant resources by triggering an action that you define. 
-Resource Inventory - in AWS Config (it shows compliance and non-compliance resources)

Use Cases:
-Stores change history of resources in S3 bucket
-AWS Config is great for compliance and security governance.

AWS config terminology:
-Rule: desired configuration
-Managed Rules: aws created rules, we can also create our own.

Examples of managed rules:
s3-bucket-public-read-prohibited  
desired-instance-type
cloud-trail-encryption-enabled
ec2-ebs-encryption-by-default

Conformance(zgodnosc) Packs:
-a set of rules managed as one, e.g. Operational Best practices for S3,EC2,IAM etc.

[LAB] Using AWS CONFIG
Objectives:
1.Create an S3 bucket with defualt settings
2.Create AWS Config Rule - s3-bucket-server-side-encryption-enabled.
3.After the rule is evaluated Config should report that our s3 bucket is non-compliant.

Answers:
ad1. s3>create bucket
ad2. aws config> one click setup (will create s3 bucket) > rules> add rule> search for s3-bucket-server-side-encryption-enabled > all defaults > go back to the created rule >>>
 click ACTIONS> Re-evaluate 
ad3. At the end go to the aws config dashboard and look for Compliance status tab.

[LAB-Hands-on]
https://learn.acloud.guru/handson/b0e842b6-2254-4a4e-be50-14e01bf8233b/course/aws-certified-sysops-admin-associate


#AWS systems manager & AWS Config:
AWS Systems manager 

Use Cases:
-Management: visibility and control over EC2 instances
-Operations: Perform common operational task on groups of instances sim. without logging to each one
-Automation: Patching, installing aps, running scripts, stopping and starting instances, AWS API CALLS.

[DEMO]
Configuring Automatic Remediation using systems manager and aws config:

Objectives:
1.Launch 2 Ec2 instances, 1 with amazon linux, second with red-hat 
2. Create aws config rule which checks if EC2 are with amazon linux
3.Check compliant ec2s 
4.Use AWS config to Configure Automatic Remediation which will stop non-compliant ec2.
5. IAM roles 

IAM role
MyAutomationRole with:
-managed policy : AmazonSSMAutomationRole  - contains permissions to stop an ec2 instance
-inline policy : allows this role to be passed to another service (SSM)
-Trust policy: allows SSM and EC2 to assume the role. This enables ec2 to register with SSM, and SSM to stop the ec2 instance.

Solution:
1.create 2 ec2 instances
5. Cloud-shell > git clone https://github.com/ACloudGuru-Resources/course-aws-sysops-administrator-associate.git > cd to /automation.../roleconfig.sh > chmod u+x roleconfig.sh
 and run ./ruleconfig.sh > copy created iam ARN.
|
2.config> rule> add rule> type ami > approved-amis-bt-Id > paste ami of amazon linux > next > done
3. go to aws config > rules> select our ami rule and click ACTION> re-evaluate rule.
4. AWS config > dashboard > our non-compliance resources > ACTION> Manage remediation > automatic remediation > Remediation actions -> AWS-StopEC2-Instance > Resource ID Parameter -> InstanceId >
Parameters> AutomationAssumeRole -> ARN of our IAM role arn:aws:iam::596296296333:role/MyAutomationRole > get back to rules> our ec2 rule > Resources in scope tab > select id of non-compliant
instance and click Remediate

#Eventbridge
EventBridge is all about event-driven architecture. An event is a change in state.
EventBridge is "PREFFERED WAY" to manage events.

AWSConfig,CloutTrail,CloudWatch creates "EVENTS" which can be directed to EventBridge, where we can configure rules, which match the events, and route them to the correct target ->
and a target will define an action that will be taken on an associated AWS service.

Examples:
-shutting down an EC2 which is non-compliant in AWSConfig
-trigger a lambda funcion, to take some action in reponse to an event
-send sns notification to notify you of an event in cloudTrail or CloudWatch 

"Scheduled events":
We can use event bridge run on schedule, even with "CRON" expressions.

[lab] using amazon event bridge
objectives :
1.launch ec2 instance
2. create sns topic in awsSNS service.
3.Create a eventbridge rule 
4. stop instance.

ad 1. launch default ec2
ad 2. 
sns > create topic> default. 
Sns > subscriptions > select created topic > protocol (destination) Email. 
Eventbridge>create rule> EC2 > ec2 instance state-change notification (here we can choose state and instance id) 

[lab]
Scheduling
https://learn.acloud.guru/course/aws-certified-sysops-admin-associate/learn/55da9f48-b0da-4615-9406-ecaa1528c55a/49e32c45-26bf-450f-bb03-3256af7af473/watch

1. AWS config rule (to check that ec2 instances dont have public ip )
2. SNS TOPIC (to alert on email when event triggers) 
3. EventBridge (to redirect config rules non-compliance to SNS)

#Health Dashboards (service health)
-to view the status of all AWS status per region.

#Personal Health Dashboard
-to view issues with AWS services that will impact you, based on "resources you are using"

quiz result : 100% !!! <3

--------------------------------------------------------------------------------------------------------

Chapter 3 - Storage and Data Management.

#S3
-Used to upload any files (photos etc)
-unlimited Storage
-max "5TB" file 
-data is stored redundancy across >=3 AZ


#S3 characteristics:
-Tiered storage - a lot of storage classes eg. glacier
-Lifecycle Management - using "rules" to automatically managing your files e.g delete after some time, or change tier of files when unused for a long time e.g. move to glacier.
-Versioning - to create versions of often accessed/important files, can be retrieved when deleted.

#S3 storage classes:
S3 Standard: Provides  99.99 percent availability and 99.999999999 percent durability (aka “11 nines”).
S3 Infrequent Access: same as s3 standard but 40% cheaper with 99.9% availability , and 99.999999999% durability - "30 days min -40% off S3 standard price"
S3 One Zone-Infrequent Access: same IA, but in "single AZ with 99.5% avaibility" (non-critical data), "30 days, -20% off IA price"
S3 Intelligent Tiering: 2 tiers :
1.frequent 2. Infrequent - ai moves your data to most effective tier based on how frequently you access each object. 
S3 Glacier: 1/5 price of S3 and is designed for archiving and long-term storage. Restore times are between one minute and seven hours, depending on the type of request. "90 days min".
S3 Glacier Deep Archive: "Cheapest" (1/4 of glacier). For very long-term storage and has the longest restore times of up to 12 hours. "180 days min".
S3 Outposts: Delivers the content from an on-premises AWS Outpost deployment of the S3 service.

#S3 Versioning
-With versioning enabled, S3 stores multiple versions of the same object, allowing you to revert to a previous version of an object.
-not enabled by default
-deleting creates a delete marker instead of deleting file,

#mfa delete
-requires s3 versioning enabled!

#S3 Encryption
We can set Server-side-encryption during creating S3, or afterwards.

Types of encryption:
-Encryption in transit - SSL/TLS - HTTPS - download, and upload files between our local system and S3.
-Encryption at Rest - Server-Side-Encryption - data is encrypted, when stored in disk :
1. SSE-S3 - S3 managed (by AWS) keys using AES 256-bit encryption
2. SSE-KMS - AWS Key Management Service managed keys.
3. SSE-C - Customer-provided keys

-Encryption at Rest - Client-Side Encryption - you encrypt the files yourself before you upload them into S3.


#EFS : Elastic File System
-Highly available, scalable shared file system for Linux-based workloads.
-Multiple EC2 instances can access one EFS at once (even from another AZ/REGION/VPC)
-Have lifecycle policy like s3
-"Encyptable at rest (only during creation), and in transit (when mounting a file system)"
-cannot be boot volume.
-best for sharing resources across EC2s



more :
https://www.bmc.com/blogs/aws-efs-elastic-file-system/

#EFS Storage Classes:
-EFS Standard - frequently, 99.99% availability ">=3 AZs"
-EFS Standard IA - infrequently, same ^ , but per GB retrieval fees.
-EFS One Zone -  frequently, 99.90 availability , "1 AZ"
-EFS One Zone IA - infrequently, same ^ , but per GB retrieval

[LAB] Working with EFS:
https://learn.acloud.guru/course/aws-certified-sysops-admin-associate/learn/e6e4e2b6-24b1-496a-8096-d6218f997ee2/1842564d-0215-4dd3-b1f0-68a133204902/watch

During creating EFS :
- by default Automatically backup your file system data with AWS Backup using recommended settings
- lifecycle management is set by default  to move to IA storage class after 30 days.

Performance mode :
-General purpose - web servers etc.
-Max i/o - scale to higher levels to aggregate throughput and operations per second.

Throughput mode:
Bursting -  default, throughput scales with file system size.
Provisioned - if you need more throughput than in bursting mode (specified amount).

1.Create EFS in the console
2.Mount EFS to EC2. EFS>yourEFS>ATTACH>yourEC2instance.

sudo yum install -y amazon-efs-utils
sudo mkdir efs
sudo mount -t efs -o tls fs-02af6e2456a05c05c:/ efs    #EFS>yourEFS>ATTACH> 1st command.

#EFS and multi-az apps:
By default EFS multi AZ allows you to create mount target in every avaibility zones, you are working in.


IF you are using an EFS One-Zone storage class, you can only create one mount target in the same AZ as your EFS file system.
EC2 from another AZ will charge you to connect to that one-zone mount target.
e.g. :

us-east-1a                          us-east-1a
Ec2         --> Mount target --->  EFS-One Zone
                    ^
us-east-1b ---------^ #additional charges for connecting to this mount point from another AZ.


#Athena (works with s3):
-is "interactive query service", which enables you to "run standard SQL querries on data stored in S3" (using standard SQL).
-its "Serverless", pay only per query/per TB scanned.

Use cases: 
-for query "log files stored in s3" e.g. ELB logs, s3 access logs, etc.
-analyze AWS Cost and Usage reports.

[DEMO] Working with Athena:
1.Configure a CloudTrail trail (will save logs in S3)
2.Create additional s3 bucket for results of athena querries.
3.Create Athena table:

-Athena>Settings>Manage - choose created s3 bucket for athena querries.
-in Athena query editor type : CREATE DATABASE myathenadb     #and click  "RUN QUERRY"
-New Querry and paste contents of a file from git : #and edit location to s3 at the end of it :)
git :  https://github.com/ACloudGuru-Resources/course-aws-sysops-administrator-associate/blob/main/Working_With_Athena_Demo/Athena_Query_Create_Table.txt
e.g. : LOCATION 's3://aws-cloudtrail-logs-315105850655-3d1789c5/AWSLogs/315105850655/';
and RUN QUERY # that will create a table cloudtrail_logs

to show chosen results from cloudtrail_logs table create new query and paste :

SELECT
 useridentity.arn,
 eventname,
 sourceipaddress,
 eventtime
FROM cloudtrail_logs
LIMIT 100;


thats all folks !

#AWS Opensearch Service - ElasticSearch:
Its fully "managed" Open-source "data analysis service" enabling you to get real-time insights from your data. AWS does all the heavy lifting for you, e.g. :
- Hardware provisioning, Configuring the ElasticSearch cluster.
- Software installing and patching.
- Failure recovery, automated backups, and monitoring.
 
Use Cases:
-Search application, infrastructure, and security logs to understand how your systems are operating.

Best practices:
- 3 master nodes, 3 Data nodes (and multiples of 3), 3 DB per each AZ in multi-AZ deployment.

#Configuring Static Web Hosting using S3:
1.Create S3 bucket (with public access)
2.Upload a file "index.html" and grant public read access "to this file". # via bucket policy, or ACL settings.
3.Enable Static Web Hosting in bucket properties.
4.Test

#Pre-Signed URL
-Pre-Signed URLs S3 pre-signed URLs are a form of an S3 URL that temporarily grants restricted access to a single S3 object to perform a single operation.
-Pre signed URLs lasts 60 mins by default, we can extend it by --expires-in 300 (in seconds). e.g. :

Creating a s3 presigned url in aws cli:
aws s3 presign s3://dusiek-bucket-to-connect-to-s3-222/hello.txt --expires-in 300

#restricting S3 accessability with IP Adresses:
Use Cases:
-To limit access for specific IP range e.g. if you have confidental files in your bucket.

In bucket policy in "Condition" we can add IpAdress or NotIpAdress (CIDR range)

#awsConfig with S3:
Some Config states for S3:
-s3-bucket-server-side-ecryption-enabled
-s3-bucket-public-read-prohibited
-s3-bucket-public-write-prohibited
-s3-bucket-versioning-enabled

#Storage Gateway - DATACENTER:
On-prem software appliance installed in your own "Data center" allowing you to integrate your "on-prem IT ENV with AWS-based storage".

File Gateway - Files in S3 
Volume Gateway - files in your data-center, backups on S3.
Volume Gateway , Gateway Cached - S3 is primary storage, frequently accessed data is cached locally.
Tape Gateway (VTL) - Virtual tape library which enables low-cost data archieving to glacier. Integrates with existing tape backup software, which connects to the VTL.



Quiz Score : 1st try 86% / 2nd try : 97%

Bad answers:

-S3 archieve - glacier/deep glacier
-AWS recommends that you access an EFS file system using a mount target within the same Availability Zone.
The best solution is to create a "mount target for each of the Availability Zones" where your application servers are located.
-S3 static webpage - > enable public read access in bucket permissions > Upload the index.html file + update the object ACL to grant public read access for the object in your bucket.
   Enable static web hosting. 
-s3 bucket from specific ip range - in bucket policy restrict access to ony the desired specific ip
-"S3 Intelligent-Tiering is designed to optimize costs by automatically moving data to the most cost-effective access tier, without operational overhead." 
It is specifically designed for storing data which has an unpredictable or unknown access pattern.

--------------------------------------------------------------------------------------------------------------------------

Chapter 4: Reliability and Business Continuity.


#Elasticity and Scalability:
EC2:
-Elasticity - Auto Scaling Group - short time period
-Scalability  Increase instance sizes/Use reserved instances - long time period

DynamoDB ("noSQL"):
-Elasticity - increase/decrease IOPS based on traffic spikes
-Scalability - Unlimited amount of storage

RDS ("SQL"):
-Elasticity - -Can''t scale on demand
-Scalability - Increase instance size/Add additional of instances

Amazon Aurora:
-Elasticity - Autoscale up and down to meet varying demand on the database
-Scalability - Modify the instance type/read replicas

#Auto Scaling:

Target Group - is used to route requests to one or more registered targets - #for ALB
Launch Template -  instance configuration that can be reused, shared and launched at a later time



"If we have created auto scaling group, these instances will be created to desired state."

-Scaling Plans - set of directions for scaling your resources.
-Scaling Strategy - Instructs AWS Auto Scaling on How to optimize resources.

Dynamic Scaling - when Tresholds reaches certain level e.g. CPUUtlization above 80%
Predictive Scaling - scales load by analyzing resources historical load (by AI and forecasting)

#Scaling Plans:
Cloudformation scripting - Find scalable resources through existing CloudFormation templates.
EC2 Auto Scaling Groups - Select one or more existing EC2 Auto Scaling Groups.
Tagged Resources - Search for scalable resources using tags applied to them.

Scalable AWS Services:
-EC2 
-DynamoDB
-ECS 
-Aurora 

[LAB] Creating Auto Scaling plans.

1.Create launch template: #which type of ec2 we want to create
-EC2 -> launch templates > create template - amazon ami/t2micro/ default SG/ key pair 
2.Create Auto Scaling Group:
-EC2 -> Auto Scaling Group -> Create -> use created Launch template -> set desired number of instances -> add tag -> end
3.Create Scaling Plan:
-awsAutoScaling -> 


#Vertical Scaling (Scalability - long term)
-more disk i/o
-more Storage           } on the instance.
-more CPU
-more Memory

#Horizontal Scaling (Elasticity - short term)
-more instances or nodes
-load balancer
-auto scaling groups
-making app multi-az

               #VERTICAL                        #HORIZONTAL
EC2 -  increase instance size        Add instances/Configure Auto Scaling
RDS -  increase instance size            Create Read replicas

#AWS Elasticache
Caching service, which holds frequently used queries in AWS, so there is no need to "ask" RDS every time.
Cache hit - if Elasticache already had wanted information.
Cache Miss - if Elasticache dont have infotmation, and needs "ask" RDS.

Use Cases:
-Improves latency for read-heavy app workloads(gaming,media sharing / recommendation engine).
-Improves Application Performance (stores critical pieces of data in-memory for "fast data retrieval")

2 types of Elasticache:
-Memcached - multithreading, no snapshots, no replication
-Redis elasticache engine - Snapshots, replication, Advanced Data Structures.

#AWS Aurora
- AWS MySQL-PostgreSQL RDS database.
- has fault-tolerant and self-healing storage system which lowers the risk of dat loss.

Aurora DB Cluster:
-3-AZ, with Data Copies in every AZ.
-First AZ has a PRIMARY INSTANCE, other AZs has Aurora Replica
-Primary insance read/writes from Data Copy in same AZ, and Writes to another Data copies in another AZs.
-creates a backup (snapshot, every 1-35days) 

Aurora 100% CPUUtlization issue:
-if "Write", increase the "instance size"
-if "Read", increase the number of "replicas"

Aurora Serverless:
-auto scaling version of Aurora, which automatically scales capacity to fit the needs of app.
-supports standard AWS Aurora features.
-best for infrequent and unpredictable workloads, which still needs high availability.

#Logging to aurora instance:
mysql -h <WRITER_ENDPOINT> -u admin -p

show databases;

#RDS and Multi-AZ Failover:
Multi-AZ :
-Keeps a copy of production db in separated AZ.
-Manages the failure from one AZ to another "Automatically" through AWS.

MySQL, Oracle, PostgreSQL - use synchronous "physical" replication (keeps standby instance data current with primary instance)
SQL Server - uses synchronous "logical" replication (and SQL server''s native Mirroring to ensure the standby is up to date)

How Failover works:
RDS will automatcally detect AZ failure, and take endpoint and update DNS to AZ which is running proprely.

"RDS Multi-AZ is for Disaster Recovery and" ,use "READ REPLICAS" to improve "performance" and some "availibility". 

#Multi-AZ PROS:
-High Availability
-Backups + Restores (these are taken from secondary db = "no I/O suspension")

[tip] we can force a failover, by rebooting instance (console, or RebootDBInstance API call in cli)

[LAB] Creating and Encrypting RDS Snapshots
1.Take snapshot of existing RDS instance
2.Copy snapshot to the same/different region
3.Encrypt the Snapshot during the copy process.
4.Restore a snapshot.

[TIP] 5 Elastic IPs per Region (IPv4).

#RTO and RPO:
RTO (Recovery "Time" Objective) - How long it takes to back on track after disaster recovery.
RPO (Recovery "Point" Objective) - "what is most important to backup and how frequent backups need to be taken"  #How many backups, or how much data we need to capture for a given point. 

#AWS Backup:
1. Create a backup plan.
2. Assign AWS resources.
3. Monitor, modify and restore backups.

#Disaster Recovery strategies:
Backup and Restore ($ HOURS) - Lower priority, restore data after event , deploy resources after event.
Pilot Light ($$ 10s of Minutes) - Core services, Start and scale resource after event.
Warm Standby ($$$ Minutes) - Business critical services, scale resources after event.
Multi-site active/active ($$$$ Real Time) - Zero downtime, Near zero loss, Mission critical services.

#Service-level backups vs snapshots
Service-Level "backups":
-FSx
-EFS
-DynamoDB
-EC2

Service-Level "snapshots":
-Aurora
-Amazon RDS
-Amazon EBS
-Amazon Storage Gateway

#AWS Service Maintenance Windows:
Scheduled downtime to apply configuration changes or update to your app components.

#S3 cross-region replication:
- Moving data to different regions to create a higher level of availability within or application.
pros:
-improve latency
-improve Effeciency 

Configuration:
1.Create S3 buckets in separate regions.
2.Turn Versioning ON 
3.Create Replication Rule.

#SQS
Producers -> SQS Queue -> Consumers
(from)        (wait)       (processed by)

[LAB] Automating SBS Snapshots Using Data Lifecycle Manager:

1. Launch an EC2 instance with an Attached EBS Volume.
2. Create a Lifecycle Policy within Data Lifecycle Manager
3. Enable Cross-Regional Replication for Our EBS Snapshot.

#backing up dynamodb table to another region using DynamoDB Streams.
1.Create DynamoDB Table
2.Enable DynamoDB streams - DynamoDB>Your_Table>EXPORT AND STREAMS
3.Add Replica Table and Select the Desired Region - Your_Table> GLOBAL TABLES> Create Replica

---------------------------

Chapter 5: Security and Compliance

#DDoS:
-use "AWS Shield" to prevent DDoS attacks.

#AWS Shield:
A service that protects "all" AWS customers on :
-ELB
-Amazon CloudFront
-Route 53
 
#AWS Marketplace :
-We can buy there a third-party security tools, custom AMis etc.

#IAM
Policies - list of permissions
Roles - 

#Enabling MFA:
by console or CLI.

#SSO - Single Sign On
-is a service which manages identity federation within AWS.
-Allows users to be able to sign on to all of their accounts with one single password.
-integrates with AWS Organizations 

Federated Identity:
-process of authenticating user id across multiple systems and applications.

#IAM Access Analyzer 
-Helps identify resources shared with an external entity. 

1. Create an analyzer (choose between organization, or your account - "your zone of trust")
2. Review active findings (look which resources are available outside "your zone of trust")
3. Take action. (in result you will accept current state, or you can be redirected to "out of trust zone resource")

#IAM policy simulator
- simulate policy within IAM (to check if everything is as you desire)

#AWS Inspector - security and network accessibility of EC2 instances!
AWS Inspector - (needs AWS Agent on EC2) provides automated security assessments on your "EC2 applications". e.g. :
-Common Vulnerabilities and Exposures
-Network Security Best Practices
-App security best practices.
-Generates reports

#AWS Trusted Advisor: best practices to optimize your Multiple Services !e.g. :
- Cost Optimalization - recommendations to eliminate unused and idle resources.
- Performance - monitors over ulilitized instances, and check that service usages are above 80%.
- Security - checking security permissions and enabling security features.
- Fault Tolerance - leveraging backup, auto scaling, health checks, and multi-az capabilities.
- Service limits -
-generates reports.

[AWS Organizations:]
Manage multiple AWS accounts in One Place.


                           ROOT
OU                 OU              OU             OU
AWS ACCOUNTS    AWS ACCOUNTS   AWS ACCOUNTS   AWS ACCOUNTS

SCP - Service Control Policy : can be attached to either OU or account or users.

#Consolidated billing - single payment method for all AWS accounts in your organization. 
-We can use AWS Compute Optimizer, to undersstand resource utilization of "compute" resources.
-Configure budgets and cost alarms via AWS Cost Explorer/ AWS Budgets.


Controlling Access and permissions:
AWS SSO - grant access to multiple AWS accounts using Active Directory, and customize permissions based on job roles.
SCP - SCP can be applied to "users, accounts, or OU" to control access to AWS resources, services, and regions within your organization.
Share resources across accounts - share resources using "AWS Resource Access Manager (RAM)"

Policies:

SCP: 
-AI Services Opt-Out Policies.
-Backup Policies
-Tag Policies.

Services integration:
Amazon Guard Duty - security reporting within your accounts.
AWS Resource Access Manager - sharing resources within your account
AWS Config
System Manager

#SCP
By Default all services all allowed (block list strategy).
Service control policies can be used as an "allow" or "deny" list.

Allow list: #all prohibited
-Actions are "prohibited" by default - we need to "allow them"
-Specify which "services and actions" are allowed.

Deny List: #all allowed
- all actions are allowed by default.
- Specify which services and actions are prohibited.

SCP Inheritance:
-If OU has access to EC2 and S3, child OU or account can have only access to EC2 and S3, even if scp attached to child OU or that account says different.

#AWS Control Tower.
Service to securing multiple accounts. It Works with AWS Organizations.
                     AWS Control Tower
                              | 
                              | creating, configuring and managing multiple accounts through ongoing policy management and "guardrails."
                              v
                     AWS Organizations
                              |
                              | Create accounts, apply guardrails, and utilize Consolidated billing.
                              v

\

Landing Zones - default configuration for future accounts.
Account Factory - account template which helps provision new accounts with pre-approved standardizedaccount configuration.
Guardrails - Rules which provide governance within AWS environment. Guardrails are applied to OU and the accounts within them.

#STS - Security Token Service
Temporary Security Credentials that grant trusted users access to our AWS Resources.
Credentials are returned with three components :
-Security Token
-Access Key ID
-Secret Access Key

-active from few minutes to several hours, and expires after.
-easy access through AWS CLI
-AWS STS supports AWS CloudTrail and can be configured to deliver log files into S3.

Use Cases :
"Enterprise Identity Federation" 
-Uses SAML 2.0
-Grants temporary access based on user credentials in Active Directory
-SSO
-Custom Federation Broker 

"Web identity Federation":
-Uses Facebook/Amazon/Google or other "OpenID" providers to log in.

"Cross-Account Access":
-Lets users from one AWS account access resources in another
 
"Roles for EC2 and other AWS Services":
-Runs app on EC2 instances with access to another aws services, without embedding credentials.


#KMS - Key Management Service
KMS Allows to create, store, manage encryption keys within AWS.

-logs key usage with "CloudTrail"
- simplifies encrypting data by just checking box in select service.

CMK (Customer Master Key) - master key which hold key material to encypt data. Used to Generate, encrypt and decrypt the "Data Key". "Data key" is used to "encypt or decrypt" your data.

Accessing KMS:
AWS Managed Keys - automatically generated AWS KMS keys for services integrated with KMS.
Custom Key Stores - all custom keys must be created first within CloudHSM.

#AWS Certificate Manager:
AWS Certificate Manager is a key method for "encrypting data in Transit""

SSL (Secure Sockets Layer) - Encryption Certificate. When a web browser contacts your secured website, the SSL certificate enables an encrypted connection.
TLS (Transport Layer Security) - 

#AWS WAF (Web APPlication Firewall) :
AWS WAF is a web application firewall that allows you to monitor HTTP/HTTPS requests.

-Filters web traffic (e.g wchich ip adresses are allowed to make a request)
- Offers full API (can be deployed via CloudFormation)
- Real time visibility (metrics and details from app requests about IP adresses, URIs, Geolocationm abd refferers. - "Through CloudWatch metrics")

WAF integrates with "Application Load Balancers, Amazon CloudFront and Amazon API Gateway"
-We can block origin ip adress e.g from U.S or another country.

#Dedicated instances vs Dedicated Hosts:
Dedicated instances - Reserved physical hardware for EC2 instances (separated space on physical server, not entire server!)
Dedicated Host - Reserved Whole server for EC2 instances.

#Parameter Store:
Stores Secrets and parameters.

#AWS Secrets Manager:
Securely stores secrets. AWS Secrets Manager provides cross-account access, automatic password rotation, and password generator.

#AWS SERVICE QUOTAS:
-service limits e.g max ElasticIPs per VPC.

#Protecting CloudTrail Logs:
-SSE
-Log file integrity
-Secure the S3 bucked used to store your logs.

#AWS Security HUB:
Security service, that allows us to view and manage security alerts, as well as automate security checks (runs assessment to checks for security purposes all resources within AWS account)

-Centrailized view - single centralized view of your AWS account''s security.
-Compliance - monitors compliance with security standards and best practices.
- uses AWS Config to perform many of its security checks.

#AWS GuardDuty:
-Threat detection service which uses machine learning to detect malucious behaviour in your AWS account.
-can analyze cloudtrail logs, vpc flow logs and DNS logs.
-displays findings in the GuardDuty dashboard.

#AWS Secrets Manager:
-hold secrets used to access resources inside and outside the AWS.
-can configure "Automatic rotation" of secrets e.g. 30/60/90 or custom number of days.

Database Secrets : (for MySQL, PostgreSQL,Oracle, MariaDB, SQL Server)
-Username nad password
-server adress
-database name and port

Quiz - 80%

-------------------------------

Networking:

SG - no inbound, just outbound by default 
nACL - all traffic disabled by default.















-networking

SG - all tcp for ssh

EC2 using sudo update command is using port 443 (HTTPS)



----------------------
Lambda at Edge - lambdy ktore uruchamiasz na edgach. 
AWS Organizations
CloudFront
CodeDeploy
CodeCommit




cloudFront :
bucket. index html.



