from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS
from dotenv import load_dotenv, main
import os


load_dotenv()

token = os.getenv('INFLUXDB_TOKEN')
org = os.getenv('INFLUXDB_ORG')
bucket = os.getenv('INFLUXDB_BUCKET')
url = os.getenv('INFLUXDB_URL')

def query(start):
    tables = query_api.query('from(bucket: "{bucket}")\
            |> range(start: {start}, stop: now())\
            |> filter(fn: (r) => r["_measurement"] == "random")\
            |> yield(name: "last")'.format(start=start,bucket=bucket)
            ,org=org)

    results = []
    for table in tables:
        for record in table.records:
            results.append(int(record.get_value()))

    return results


influx_client = InfluxDBClient(url=url, token=token)
write_api = influx_client.write_api(write_options=SYNCHRONOUS)
query_api = influx_client.query_api()
