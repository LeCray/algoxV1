import csv
import pandas as pd
import plotly.express as px

from numpy import loadtxt
from keras.models import Sequential
from keras.layers import Dense
from keras.models import model_from_json

import pickle

import h5py


dataset = loadtxt('Data/BuyData.csv', delimiter=',') #10357

row_count = sum(1 for row in dataset)

trainingData = dataset[0:round(row_count*0.7),:]
testingData = dataset[round(row_count*0.7):row_count,:]


X = trainingData[:,0:4]
y = trainingData[:,4]
A = testingData[:,0:4]
b = testingData[:,4]


#print(dataset[:,4])

# define the keras model
model = Sequential()
model.add(Dense(12, input_dim=4, activation='relu'))
model.add(Dense(4, activation='relu'))
model.add(Dense(1, activation='sigmoid'))

# compile the keras model
model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

# fit the keras model on the dataset
model.fit(X, y, epochs=150, batch_size=10)

# save the model to disk
#filename = 'finalized_model.sav'
#model.save("buyNN.h5")

# serialize model to JSON
model_json = model.to_json()
with open("model.json", "w") as json_file:
    json_file.write(model_json)
# serialize weights to HDF5
model.save_weights("model.h5")
print("Saved model to disk")

#pickle.dump(model, open(filename, 'wb'))

# evaluate the keras model
_, accuracy = model.evaluate(A, b)
print('Accuracy: %.2f' % (accuracy*100))
