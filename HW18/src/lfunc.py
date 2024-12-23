import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    # Get instance
    instances = ec2.describe_instances(Filters=[{'Name': 'tag:Env', 'Values': ['my-instance']}])
    
    # Get id and stop
    instance_ids = [i['InstanceId'] for r in instances['Reservations'] for i in r['Instances']]
    if instance_ids:
        ec2.stop_instances(InstanceIds=instance_ids)
