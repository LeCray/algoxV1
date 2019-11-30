import csv
import pandas as pd
import plotly.express as px

'''
from numpy import loadtxt
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
'''




df = pd.read_csv('Data/BuyData2.csv')

fig = px.line(df, x = "TIME", y = "PROFIT", title='PROFIT')
fig.show()
