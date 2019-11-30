import numpy as np
import random
from DWX_ZeroMQ_Connector_v2_0_1_RC8 import DWX_ZeroMQ_Connector
from Orders import *

state_size = 4
action_size = 3
running = True

# Initialize q-table values to 0: Rows = states, Colmns = Actions
qtable = np.zeros((state_size, action_size))

epsilon = 0.2 # Initial level of exploitation. Exploitation grows over time.
gamma   = 0.8


#buy()
#sell()

#getAllTrades()
#subscribeToEurUsd()
#unsubscribe()
marketData()

#sell()
#closeAllTrades()
"""
while running:
    if random.uniform(0, 1) > epsilon:
        #Explore
        x = random.uniform(0,1)

        if x < 0.3:
            action = buy()
        elif x > 0.3 && x < 0,6:
            action = sell()
        else:
            action = doNothing()
    else:
        #Exploit
        actionIndex = np.argmax(qtable[state, :])
        switch (actionIndex) {
            case 0:
                action = buy();
                break;
            case 1:
                action = sell();
                break;
            case 2:
                action = doNothing();
                break;
        }




# Update q values
qtable[state, action] = qtable[state, action] + lr*(reward + gamma*np.max(qtable[new_state, :]) — qtable[state, action])

print(random.uniform(99, 400))
"""
