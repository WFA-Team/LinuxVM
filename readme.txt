-- Pre-requisites -> Windows OS, Vagrant, Oracle VirtualBox
--Run doEverything with administrative privilages, in ideal cases, this should be enough, kafka broker will be available at 192.168.56.3:9092

-- Steps to Manually configure Windows Firewall: -  
Step 1: Allow Ping (ICMP) in Windows Defender Firewall
Press Win + R, type wf.msc, and hit Enter to open Windows Defender Firewall with Advanced Security.
In the left pane, click on Inbound Rules.
Find the rule named File and Printer Sharing (Echo Request - ICMPv4-In).
Enable it:
Double-click the rule.
Under General, select Allow the connection.
Under Advanced, ensure it's enabled for the Private and Public profiles.
Click OK.

Step 2: Create a Custom Rule for vboxnet0
In the Windows Defender Firewall with Advanced Security, go to Inbound Rules.
Click New Rule... (on the right).
Select Custom and click Next.
In the Program step, select All programs.
In the Protocol and Ports step:
Choose ICMPv4 from the dropdown.
In the Scope step:
Under Which local IP addresses does this rule apply to?, select This IP address or subnet.
Enter the VirtualBox Host-Only IP range, e.g., 192.168.56.0/24.
Click Next, then Allow the connection.
Ensure the rule is applied to the Private and Public profiles.
Give it a name like Allow Ping on vboxnet0 and click Finish.

-- Useful debugging commands : -
kafkacat -C -b 192.168.56.3 -t test-topic
nc -zv 192.168.56.1 9092
sudo docker run -it --rm confluentinc/ksqldb-cli:latest ksql http://192.168.56.3:9095

kafkacat -b 192.168.56.3:9092 \
     -t Sample \
     -s value=avro \
     -r http://192.168.56.3:9094 \
     -o beginning \
     -C
     
ksql> CREATE STREAM events (
>  key1 STRING,
>  key2 DOUBLE,
>  key3 BIGINT
>) WITH (
>  KAFKA_TOPIC = 'Sample',
>  VALUE_FORMAT = 'AVRO'
>);

SELECT * FROM events EMIT CHANGES;