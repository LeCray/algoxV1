import random
import numpy as np
from DWX_ZeroMQ_Connector_v2_0_1_RC8 import DWX_ZeroMQ_Connector

_zmq = DWX_ZeroMQ_Connector()

#print(_zmq._generate_default_order_dict())

print(_zmq.remote_recv)
