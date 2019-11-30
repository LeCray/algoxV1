import csv
import pandas as pd
import plotly.express as px

"""
x = []
y = []

with open('Data/Prices1.csv', 'r') as csvFile:
    reader = csv.reader(csvFile)
    #print(reader)

    for row in reader:
        print(row[0])
        #x.append(int(row[0]))
    #    y.append(int(row[1]))

#plt.plot(x,y, label='Loaded from file!')

csvFile.close()
"""

df = pd.read_csv('Data/Prices1.csv')

fig = px.line(df, x = "TIME", y = "PRICE", title='EURUSD M5 ClOSING PRICES')
fig.show()


"""
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
"""
