import csv
import pandas as pd
import plotly.express as px
from numpy import loadtxt
import urllib.request
import threading
import pickle


dataLocation = "C:/Users/Thembi/AppData/Roaming/MetaQuotes/Terminal/1DAFD9A7C67DC84FE37EAA1FC1E5CF75/tester/files/DataVehicle/dataVehicle.csv"

# load the model from disk
model = pickle.load(open('finalized_model.sav', 'rb'))

index = 0

def run_retriever():
    threading.Timer(1.0, run_retriever).start()
    data = loadtxt(dataLocation, delimiter=',')

    if index != data[0,0]:
        index = data[0,0] #Updating the index

        print("Making prediction...")

        X = data[0, 1:5]
        y = model.predict_classes(X)

        if y == 1:
            data[0, 0] = "BUY"
            numpy.savetxt(dataLocation, data)
        else:
            print("DON'T BUY")
    else:
        print("RETRYING...")


run_retriever()
