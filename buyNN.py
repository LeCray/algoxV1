import csv
import pandas as pd
import plotly.express as px
import numpy as np
import urllib.request
import threading
import pickle

#import keras
import tensorflow
from tensorflow.keras import backend

from keras.models import Sequential
from keras.layers import Dense
from keras.models import model_from_json
#import pickle
import h5py

mql_to_python_data = "C:/Users/Thembi/AppData/Roaming/MetaQuotes/Terminal/1DAFD9A7C67DC84FE37EAA1FC1E5CF75/tester/files/Data/MqlPython.csv"
python_to_mql_data = "C:/Users/Thembi/AppData/Roaming/MetaQuotes/Terminal/1DAFD9A7C67DC84FE37EAA1FC1E5CF75/tester/files/Data/PythonMql.csv"
# load the model from disk
#model = pickle.load(open('finalized_model.sav', 'rb'))
#loaded_model = tensorflow.keras.models.load_model('buyNN.h5')


# load json and create model
json_file = open('model.json', 'r')
loaded_model_json = json_file.read()
json_file.close()
loaded_model = model_from_json(loaded_model_json)
# load weights into new model
loaded_model.load_weights("model.h5")
print("Loaded model from disk")


def run_retriever():
    threading.Timer(1.0, run_retriever).start()
    data = np.loadtxt(mql_to_python_data, delimiter=',')
    predictionIndex = 0

    featuresIndex = data[0]
    print("Features Index: ", featuresIndex)

    if featuresIndex > predictionIndex:

        print("Making prediction...")

        X = np.array(data[1:5])
        print(X)


        y = loaded_model.predict_classes(X)
        print("Prediction: ", y)

        predictionIndex = data[0] #Updating the index to match last features index from mql-server

        if y == 1:
            predictionData[0] = predictionIndex
            predictionData[1] = 1
            np.savetxt(python_to_mql_data, predictionData)
            print("Buy prediction sent to mql-server: 1")
        else:
            predictionData[0] = predictionIndex
            predictionData[1] = 0
            np.savetxt(python_to_mql_data, predictionData)
            print("Buy prediction sent to mql-server: 0")

    else:
        print("RETRYING...")
        run_retriever()


run_retriever()
